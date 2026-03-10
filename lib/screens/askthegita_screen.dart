import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../widgets/common_widgets.dart'; 

class AskTheGitaScreen extends StatefulWidget {
  const AskTheGitaScreen({super.key});

  @override
  State<AskTheGitaScreen> createState() => _AskTheGitaScreenState();
}

class _AskTheGitaScreenState extends State<AskTheGitaScreen> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  
  String? _shlok;
  String? _translation;
  String? _verseRef;
  String? _interpretation;
  String? _simpleResponse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // We now rely on didChangeMetrics, so the focus listener is no longer needed for scrolling.
  }

  @override
  void didChangeMetrics() {
    if (!mounted) return;
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0 && _focusNode.hasFocus) {
      if (_simpleResponse == null && _shlok == null) {
        // By using a post-frame callback, we wait until the layout is
        // finalized before starting the scroll animation. This prevents
        // the keyboard animation and scroll animation from fighting,
        // resulting in a much smoother (less laggy) experience.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _resetScreen() {
    _focusNode.unfocus();
    setState(() {
      _controller.clear();
      _shlok = null;
      _translation = null;
      _verseRef = null;
      _interpretation = null;
      _simpleResponse = null;
    });
  }

  void _onTextChanged(String value) {
    if (_simpleResponse != null || _shlok != null) {
      setState(() {
        _shlok = null;
        _translation = null;
        _verseRef = null;
        _interpretation = null;
        _simpleResponse = null;
      });

      // Schedule the scroll to happen after the UI has rebuilt without the response card.
      // This is more reliable and smoother than a fixed timer.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _showCustomSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: primaryColor, width: 1),
      ),
    ));
  }

  String _sanitizeGeminiOutput(String rawText) {
  return rawText
    // 1. Replace all Markdown symbols (#, *, _, `, ~) with a SPACE
    // This character class approach prevents typos like ' _'
    .replaceAll(RegExp(r'[#\*_`~]+'), ' ') 

    // 2. Remove bullet points at start of lines (Matches: *, -, +, 1.)
    .replaceAll(RegExp(r'^\s*([\*\-\+]|\d+\.)\s+', multiLine: true), ' ')
    
    // 3. Remove decorative quotation marks at start/end
    .replaceAll(RegExp(r'^["\u201C]|["\u201D]$'), '')
    
    // 4. Replace all newlines/tabs with a SPACE (prevents WordAWordB)
    .replaceAll(RegExp(r'[\n\r\t]+'), ' ')
    
    // 5. THE MAGIC STEP: Shrink all resulting multiple spaces into one single space
    .replaceAll(RegExp(r'\s{2,}'), ' ')
    
    // 6. Final trim for a perfect string
    .trim();
}

  Future<void> _getGitaWisdom() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    _focusNode.unfocus();

    if (query.length < 2 || !RegExp(r'[a-zA-Z]').hasMatch(query)) {
      _showCustomSnackBar("Please express your thought in words.");
      return;
    }

    setState(() {
      _shlok = null;
      _translation = null;
      _verseRef = null;
      _interpretation = null;
      _simpleResponse = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
    );

    String? resultText;
    dynamic capturedException;

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) throw Exception("API Key missing");

      // Sequential fallback through your models
      final List<String> modelPriority = [
        'gemini-3-flash-preview',
        'gemini-2.5-flash',
        'gemini-2.5-flash-lite',
      ];
      final safetySettings = [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.low),
      ];

      final now = DateTime.now();
      final days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
      final months = ['January','February','March','April','May','June',
                      'July','August','September','October','November','December'];
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));
      final hour = now.hour;
      final amPm = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final offset = now.timeZoneOffset;
      final offsetHours = offset.inHours;
      final offsetStr = offsetHours >= 0 ? 'UTC+$offsetHours' : 'UTC$offsetHours';
      final timezoneName = now.timeZoneName;

      final currentDateTime = '''
      Current Date & Time Information (use this if user asks anything about date, day, time, or related):
      - Today: ${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}
      - Current Time: ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}
      - Yesterday: ${days[yesterday.weekday - 1]}, ${months[yesterday.month - 1]} ${yesterday.day}, ${yesterday.year}
      - Tomorrow: ${days[tomorrow.weekday - 1]}, ${months[tomorrow.month - 1]} ${tomorrow.day}, ${tomorrow.year}
      - Current Month: ${months[now.month - 1]}
      - Current Year: ${now.year}
      - Current Week Day Number: ${now.weekday}/7
      - Current Time (12hr): $hour12:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')} $amPm
      - Current Time (24hr): ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}
      - Timezone: $timezoneName ($offsetStr)
      ''';

      for (String modelName in modelPriority) {
        try {
          final model = GenerativeModel(
            model: modelName,
            apiKey: apiKey,
            safetySettings: safetySettings,
        );

          final prompt = """
            $currentDateTime
            You are a dual-mode AI assistant. You respond in exactly one of two modes:
            MODE A — Neutral, concise factual historian (plain text only, zero spirituality)
            MODE B — Wise, compassionate Vedic guide rooted in the Bhagavad Gita (strict verse format)

            The user says: "$query"

            ════════════════════════════════════════════════════════════════
            STEP 1 — INTERNAL CLASSIFICATION
            (THIS ENTIRE STEP IS SILENT. NEVER PRINT IT. NEVER MENTION IT.)
            ════════════════════════════════════════════════════════════════

            Read the user's input and apply the rules below IN STRICT ORDER.
            Stop at the FIRST rule that matches. Do not evaluate further rules once a match is found.

            ────────────────────────────────────────
            RULE 1 — SINGLE WORD OR INCOMPLETE FRAGMENT
            ────────────────────────────────────────
            If the input is:
            - A single word of ANY kind without exception
              (e.g., "great", "fire", "sad", "Karma", "Dharma", "Krishna", "help")
            - Two words or fewer with no clear complete thought
              (e.g., "I am", "fool on", "ok so", "but then", "never mind")
            - A fragment that cannot be understood as a complete sentence
              with a clear subject, intent, question, or emotional statement

            → ACTION: Respond warmly in plain text only. Do NOT provide a shloka.
            Tell the user you'd love to help and gently ask them to share their
            full thought, question, or situation.
            → EXIT: Do not apply any further rules. Do not use any tags.

            NO EXCEPTIONS. Even spiritual words like "Karma", "Dharma", "Krishna",
            "Yoga", "Atman" trigger this rule if they appear alone without context.
            A single word tells you nothing about what the user actually needs.
            A complete question or statement is always required for a meaningful response.

            ────────────────────────────────────────
            RULE 2 — EMPTY / GIBBERISH / PUNCTUATION ONLY
            ────────────────────────────────────────
            If the input is:
            - Empty or only whitespace
            - Random keystrokes (e.g., "asdf", "jjkk", "sdhsh")
            - Only punctuation with no meaning (e.g., "???", "...", "!!!!")

            → ACTION: Respond warmly in plain text. Gently ask the user to share what is on their mind.
            → EXIT: Do not apply any further rules. Do not use any tags.

            ────────────────────────────────────────
            RULE 3 — HARMFUL, ILLEGAL, OR EXPLICIT CONTENT
            ────────────────────────────────────────
            If the input involves:
            - Sexual or explicit content
            - Instructions for weapons, harm, crime, or illegal activity
            - Glorification of violence
            - Intent to harm a specific person

            → ACTION: Do NOT comply. Do NOT provide a verse in the standard format.
            Respond in calm, plain prose. Firmly but compassionately redirect the person toward inner reflection,
            self-control, and accountability in the spirit of the Bhagavad Gita.
            Maintain dignity. Do not mirror aggression or vulgarity.
            → EXIT: Do not apply any further rules. Do not use any tags.

            NOTE: Expressions of rage, despair, or dark emotion (e.g., "I want to kill my brother" said in frustration,
            "I feel like destroying everything") are NOT literal harmful intent — they are emotional distress.
            Treat these under Rule 5 (SPIRITUAL), not Rule 3.

            ────────────────────────────────────────
            RULE 4 — FACTUAL / DRY DATA (STRICT CRITERIA)
            ────────────────────────────────────────
            Classify as FACTUAL only if ALL FIVE conditions below are true simultaneously:

            Condition A: The question asks for a name, number, list, date, title, or neutral identification.
            Condition B: The question contains NO emotional language whatsoever.
            Condition C: The question does NOT ask "Why" about a motive, feeling, or moral event.
            Condition D: The question does NOT ask how a person felt, chose, or experienced something.
            Condition E: The question does NOT ask for a definition of a spiritual or philosophical concept.

            Valid FACTUAL examples:
            - "How many verses are in the Bhagavad Gita?"
            - "Who is the father of Arjuna?"
            - "List the names of the 18 chapters."
            - "Who wrote the Mahabharata?"
            - "Who is Napoleon?"
            - "How many brothers did the Pandavas have?"
            - "What is Arjuna's chariot called?"

            FACTUAL BOUNDARY CASES — these are NOT factual, they are SPIRITUAL:
            - "Why did Arjuna drop his bow?" → asks about motive → SPIRITUAL
            - "How did Arjuna feel on the battlefield?" → asks about feeling → SPIRITUAL
            - "What is Dharma?" → philosophical concept definition → SPIRITUAL
            - "Who is Krishna to Arjuna?" → asks about relationship with emotional weight → SPIRITUAL
            - "Why are there 18 chapters?" → if asking symbolic meaning → SPIRITUAL
              (Exception: "Why are there 18 chapters?" asked as a pure numerical/structural fact = FACTUAL)
            - "Tell me about the Kurukshetra war" → broad topic with inherent spiritual weight → SPIRITUAL

            If even ONE of the five conditions above fails → Do NOT classify as FACTUAL. Move to Rule 5.

            → ACTION for confirmed FACTUAL: Respond in plain, neutral text. Be concise and informative.
            STRICTLY FORBIDDEN in FACTUAL mode: [REFERENCE], [SHLOK], [TRANSLATION], [PRACTICAL], any Sanskrit verse,
            any spiritual interpretation. Violation of this is not permitted under any circumstance.
            → EXIT Rule 4 here.

            ────────────────────────────────────────
            RULE 5 — SPIRITUAL / MORAL / DHARMIC (THE MASTER CATEGORY)
            ────────────────────────────────────────
            Classify as SPIRITUAL if ANY ONE of the following is true:

            Trigger A: The query asks "Why" about a person's motive, a life event, or a scriptural story.
            Trigger B: The query contains emotional language: anger, grief, fear, guilt, jealousy, loneliness,
                      confusion, regret, heartbreak, hopelessness, shame, frustration, despair, resentment.
            Trigger C: The query describes or implies a life dilemma: career, purpose, relationships, duty,
                      right vs. wrong, moral choice, identity, self-worth, failure, success, loss.
            Trigger D: The query asks for the meaning, lesson, teaching, or significance of anything.
            Trigger E: The query asks for the definition or explanation of any spiritual or philosophical concept:
                      Dharma, Karma, Yoga, Atman, Moksha, Maya, Bhakti, Ahimsa, Samsara, Guna, Prakriti,
                      Purusha, Sattva, Rajas, Tamas, Brahman, or any equivalent concept.
            Trigger F: The query asks about a character's motive, feeling, choice, or inner state
                      — even if phrased in a neutral or factual tone.
            Trigger G: The query is a statement (not a question) that expresses an emotional or existential situation.
                      Example: "I lost my job today." / "My father passed away." / "I feel completely lost."
            Trigger H: The compound rule — if the query contains both a factual and a spiritual element,
                      answer the factual part briefly in plain text FIRST, then provide the full SPIRITUAL format
                      for the spiritual part.

            FINAL FALLBACK — RULE 5F:
            If no previous rule has clearly matched and there is ANY ambiguity between FACTUAL and SPIRITUAL,
            you MUST classify as SPIRITUAL. This is absolute and cannot be overridden by any other reasoning.
            It is always better to provide a verse for a simple question than plain text for a deep one.

            → ACTION for SPIRITUAL: Proceed to Step 2B below.

            ════════════════════════════════════════════════════════════════
            STEP 2A — OUTPUT FOR FACTUAL CLASSIFICATION
            ════════════════════════════════════════════════════════════════

            Respond as a neutral, concise historian.
            Use plain prose only.
            Do not include any of the following: [REFERENCE], [SHLOK], [TRANSLATION], [PRACTICAL],
            Sanskrit verses, spiritual guidance, or philosophical interpretation.
            Keep the answer brief, accurate, and informative.

            ════════════════════════════════════════════════════════════════
            STEP 2B — OUTPUT FOR SPIRITUAL CLASSIFICATION
            ════════════════════════════════════════════════════════════════

            Before writing a single word of your response, complete this MANDATORY INTERNAL VERSE SELECTION PROCESS.
            This process is completely silent. Never print it. Never reference it.

            --- INTERNAL VERSE SELECTION PROCESS (SILENT) ---

            Stage 1 — Generate 3 candidate verses:
            Internally identify 3 different verses from the Bhagavad Gita that could relate to this question.
            For each candidate, note the chapter number and verse number.

            Stage 2 — Verify each candidate:
            For each of the 3 candidates, answer these three questions internally:
              Question X: Do I know the exact chapter number with certainty? (Yes / No)
              Question Y: Do I know the exact verse number with certainty? (Yes / No)
              Question Z: Does this verse directly and specifically address what the user asked? (Yes / No)
            A candidate PASSES only if all three answers are Yes.
            If a candidate fails any single question, discard it immediately.

            Stage 3 — Select the best passing candidate:
            From the candidates that passed Stage 2, select the one most directly relevant to the user's question.
            If zero candidates passed, generate 3 new candidates and repeat Stage 2.
            You MUST NOT proceed to writing your response until you have one confirmed passing candidate.

            Stage 4 — Anti-repetition check:
            Do NOT default to Adhyaya 2 Shloka 47 or Adhyaya 18 Shloka 66 unless they are genuinely
            the most precise match for this specific question. These verses are overused.
            Always prefer the verse that speaks most directly to the user's exact situation.

            --- END OF INTERNAL VERSE SELECTION PROCESS ---

            Now write your response using EXACTLY the following format.
            All four tags are mandatory. No tag may be empty. No tag may be skipped. No extra tags may be added.

            [REFERENCE] Adhyaya [Chapter Number], Shloka [Verse Number]

            Rules for [REFERENCE]:
            - Use only Arabic numerals (1, 2, 3 — not "Two" or "II").
            - Do NOT write "Bhagavad Gita" or any scripture name inside this tag.
            - The format must be exactly: Adhyaya [number], Shloka [number]
            - Example of correct format: Adhyaya 6, Shloka 5
            - Example of incorrect format: Adhyaya Two, Shloka 47 of the Bhagavad Gita
            - This tag MUST contain two real numbers. If you cannot provide both numbers with certainty, you chose the wrong verse — go back and select a different one.

            [SHLOK] (The Sanskrit verse in Devanagari script or accurate IAST transliteration)

            [TRANSLATION] (An accurate, clear English translation of the verse)

            [PRACTICAL]
            Write the content of [PRACTICAL] as one continuous, flowing piece of prose with no labels,
            no headers, no part numbers, no section titles, and no structural markers of any kind.
            The output must read as natural, unbroken guidance — not a structured list.

            The prose MUST internally follow this invisible sequence without ever naming it:
            First, directly and specifically answer the user's exact question in 2 to 4 sentences.
            Name what they asked about. Address their specific concern. Do not open with a philosophical
            observation. Do not open with "In the Bhagavad Gita..." Show you understood exactly what they asked.
            Then, without any label or break, explain precisely why this specific verse applies to their
            specific situation. The connection must be direct, logical, and obvious.
            Then, without any label or break, provide 3 to 5 sentences of concrete, real-world guidance
            tied directly to the user's question and the verse. Make it actionable. Speak to the person,
            not to a general audience. Avoid abstract philosophy.

            The entire [PRACTICAL] section must read as one seamless paragraph of flowing wisdom.
            No labels. No numbers. No "Firstly", "Secondly", "Finally". No "Part", no "Section". Nothing.

            ════════════════════════════════════════════════════════════════
            ABSOLUTE RULES — APPLY TO ALL OUTPUTS AT ALL TIMES
            ════════════════════════════════════════════════════════════════

            NEVER print your internal classification (FACTUAL or SPIRITUAL) in your response.
            NEVER print the internal verse selection process or any part of it.
            NEVER leave [REFERENCE] with missing, blank, or placeholder numbers.
            NEVER write "Bhagavad Gita" inside the [REFERENCE] tag.
            NEVER use Markdown formatting anywhere (no **bold**, no *italic*, no # headers, no bullet dashes).
            NEVER mix FACTUAL and SPIRITUAL content in a single response
              (Exception: Rule 5 Trigger H — compound questions — where factual part is answered briefly first in plain text, followed immediately by the full SPIRITUAL format for the spiritual part).
            NEVER add extra tags beyond [REFERENCE], [SHLOK], [TRANSLATION], [PRACTICAL].
            NEVER open [PRACTICAL] with a philosophical generalization — always start with the direct answer.
            NEVER use the same verse twice in a conversation if a different verse fits better.
            ALWAYS maintain calm, dignified, compassionate tone regardless of how the user communicates.
            ALWAYS treat expressions of rage, grief, or dark emotion as emotional distress requiring compassion, not as harmful intent requiring refusal.
            NEVER print any structural labels, part numbers, section titles, or sequence markers inside [PRACTICAL] or anywhere in the response. The output must always be clean, flowing prose.
            NEVER add any sub-label, heading, or descriptor inside [REFERENCE]. The only content after [REFERENCE] must be: Adhyaya [number], Shloka [number]. Nothing else. No "Scripture:", no "Chapter:", no "Source:".
            NEVER add any sub-label, heading, or descriptor inside [SHLOK]. The only content after [SHLOK] must be the bare Sanskrit verse itself. No "Sanskrit Verse:", no "Original:", no "Verse:".
            NEVER add any sub-label, heading, or descriptor inside [TRANSLATION]. The only content after [TRANSLATION] must be the bare English translation itself. No "English Translation:", no "Meaning:", no "Translation:". Do not wrap the translation in quotation marks.
            """;

          final content = [Content.text(prompt)];
          final response = await model.generateContent(content).timeout(const Duration(seconds: 20));

          if (response.promptFeedback?.blockReason != null) {
            _showCustomSnackBar("Please seek wisdom with a pure intent.");
            return;
          }

          if (response.text != null && response.text!.isNotEmpty) {
            resultText = response.text;
            break;
          }
        } catch (e) {
          capturedException = e; // Store the error to check later if all models fail
          debugPrint("Model $modelName failed: $e");
        }
      }

    } catch (e) {
      capturedException = e;
    } finally {
      // Logic for closing UI elements and updating state
      if (mounted) Navigator.of(context).pop();
      if (mounted) FocusScope.of(context).unfocus();
    }

    // FINAL STATE UPDATE & ERROR HANDLING (Centralized)
    if (resultText != null) {
      setState(() {
        if (resultText!.contains("[SHLOK]")) {
          _verseRef = _parseSection(resultText, "[REFERENCE]");
          _shlok = _parseSection(resultText, "[SHLOK]");
          _translation = _parseSection(resultText, "[TRANSLATION]");
          _interpretation = _parseSection(resultText, "[PRACTICAL]");
          _simpleResponse = null;
        } else {
          _simpleResponse = _sanitizeGeminiOutput(resultText);
        }
      });
    } else if (capturedException != null) {
      final errorStr = capturedException.toString().toLowerCase();
      // Reliable check for quota/limit across various error string formats
      if (errorStr.contains('429') || 
          errorStr.contains('quota') || 
          errorStr.contains('exhausted') || 
          errorStr.contains('limit') ||
          errorStr.contains('rate')) {
        _showCustomSnackBar("Daily wisdom limit reached. Please return tomorrow.");
      } else {
        _showCustomSnackBar("Sacred connection interrupted. Please try again.");
      }
    }
  }

  String _parseSection(String text, String tag) {
    if (!text.contains(tag)) return "";
    var split = text.split(tag);
    final content = split[1].split('[').first.trim();
    // Apply the full-proof sanitizer here
    return _sanitizeGeminiOutput(content);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double sw = size.width;
    final double sh = size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: sh * 0.02),
              const SamskaraLogo(), 
              SizedBox(height: sh * 0.04),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
                child: Container(
                  padding: EdgeInsets.all(sw * 0.04),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sw * 0.05),
                    border: Border.all(color: primaryColor.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLines: 3,
                        cursorColor: primaryColor,
                        style: TextStyle(color: primaryColor, fontSize: sw * 0.045, fontFamily: 'Serif'),
                        decoration: InputDecoration(
                          hintText: "What troubles your heart today?",
                          hintStyle: TextStyle(color: primaryColor.withValues(alpha: 0.4)),
                          border: InputBorder.none,
                        ),
                        onChanged: _onTextChanged,
                      ),
                      SizedBox(height: sh * 0.02),
                      SizedBox(
                        width: double.infinity,
                        child: (_simpleResponse != null || _shlok != null)
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  disabledBackgroundColor: primaryColor,
                                  foregroundColor: backgroundColor,
                                  disabledForegroundColor: backgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(sw * 0.03)),
                                  padding: EdgeInsets.symmetric(vertical: sh * 0.015),
                                  elevation: 0,
                                ),
                                onPressed: _resetScreen,
                                child: Text("Reset",
                                    style: TextStyle(
                                        fontSize: sw * 0.045, fontWeight: FontWeight.bold)),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  disabledBackgroundColor: primaryColor,
                                  foregroundColor: backgroundColor,
                                  disabledForegroundColor: backgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(sw * 0.03)),
                                  padding: EdgeInsets.symmetric(vertical: sh * 0.015),
                                  elevation: 0,
                                ),
                                onPressed: _getGitaWisdom,
                                child: Text("Get Gita Wisdom",
                                    style: TextStyle(
                                        fontSize: sw * 0.045, fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_simpleResponse != null || _shlok != null) ...[
                SizedBox(height: sh * 0.04),
                _buildResponseCard(sw, sh),
                SizedBox(height: sh * 0.04),
              ],
              SizedBox(height: sh * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponseCard(double sw, double sh) {
    // Scaling factors for uniformity
    final double cardPadding = sw * 0.05;
    final double internalSpacing = sh * 0.015;

    List<Widget> contentWidgets = [];
    String outerTitle = "GITA'S WISDOM";

    if (_simpleResponse != null) {
      outerTitle = "GUIDE'S REPLY";
      contentWidgets.add(_buildInternalBlock("", _simpleResponse!, sw, sh, isJustified: true));
    } else if (_shlok != null) {
      if (_verseRef != null) {
        contentWidgets.add(_buildInternalBlock("Gita Adhyaya & Shloka", _verseRef!, sw, sh));
      }
      contentWidgets.add(_buildInternalBlock("Sacred Shloka", _shlok!, sw, sh, isSanskrit: true, isItalic: true));
      contentWidgets.add(_buildInternalBlock("Translation", _translation!, sw, sh));
      contentWidgets.add(_buildInternalBlock("Practical Guidance", _interpretation!, sw, sh, isJustified: true));
    }

    if (contentWidgets.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: sw * 0.06),
      padding: EdgeInsets.symmetric(vertical: cardPadding, horizontal: sw * 0.04),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03), // Soft glow background
          borderRadius: BorderRadius.circular(sw * 0.05),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // MAIN TITLE
          Center(
            child: Text(
              outerTitle,
              style: TextStyle(
                color: primaryColor,
                fontSize: sw * 0.030,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          
          SizedBox(height: internalSpacing),

          ...contentWidgets,
        ],
      ),
    );
  }

  // --- REUSABLE INTERNAL BLOCK (The "Separated Card" look) ---
  Widget _buildInternalBlock(String title, String content, double sw, double sh, 
      {bool isSanskrit = false, bool isItalic = false, bool isJustified = false}) {
    
    return Padding(
      padding: EdgeInsets.only(bottom: sh * 0.012), // Reduced spacing for compactness
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(sw * 0.035), // Uniform internal padding
        decoration: BoxDecoration(
          color: backgroundColor, 
          borderRadius: BorderRadius.circular(sw * 0.05),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Column(
          children: [
            if (title.isNotEmpty) ...[
              Text(title.toUpperCase(), 
                style: TextStyle(
                  color: primaryColor, 
                  fontWeight: FontWeight.bold, 
                  fontSize: sw * 0.030, // Smaller, uniform title
                  letterSpacing: 1.0
                )),
              SizedBox(height: sh * 0.006),
            ],
            SelectableText(
              content,
              textAlign: isJustified ? TextAlign.justify : TextAlign.center,
              style: TextStyle(
                color: primaryColor, // Everything must be primaryColor
                fontSize: sw * 0.036, // Uniform sizing to prevent "too large" issue
                fontFamily: 'Serif',
                fontStyle: isItalic || isSanskrit ? FontStyle.italic : FontStyle.normal,
                fontWeight: FontWeight.normal,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}