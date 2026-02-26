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

      for (String modelName in modelPriority) {
        try {
          final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          safetySettings: safetySettings,
        );

          final prompt = """
            You are a wise, compassionate Vedic guide based on the Bhagavad Gita.
            With this:
            You are capable of responding in two distinct modes:
            1). Neutral factual historian
            2). Wise, compassionate Vedic guide based on the Bhagavad Gita
            The user says: "$query".

            You MUST first classify the user’s input into one of the categories below before responding.
            Follow the rules in order. Do not mix categories.
            PRIORITY CLASSIFICATION LOGIC (STRICT ORDER):
            1). THE "WHY" RULE:
            Any question asking "Why" regarding a person, a life event, or a scriptural story is automatically MORAL/SPIRITUAL (Section 5).
            2). EMOTIONAL / LIFE DILEMMA RULE:
            If the query contains emotional struggle (anger, grief, confusion, fear, loneliness) or a life dilemma (career, duty, right vs wrong, purpose), it MUST be classified as MORAL/SPIRITUAL (Section 5).
            3). THE "WHO IDENTITY" RULE:
            Any question that begins with “Who is” or “Who was” and seeks identification of a real-world historical, political, literary, or mythological person MUST be classified as FACTUAL, unless the user asks about motives, morality, or lessons.
            4). THE "ROBOT / DRY DATA" RULE:
            Section 3 (Factual) is ONLY for pure Dry Data (e.g., "How many verses?", "Who is the father of X?", "List the 18 Chapters.").
            If the query has emotional weight or involves a choice/motive, Factual is STRICTLY FORBIDDEN.
            5). PHILOSOPHICAL CONCEPT RULE:
            A definition of a spiritual or philosophical concept (e.g., Dharma, Karma, Yoga, Atman, Bhakti) MUST be classified as MORAL/SPIRITUAL.
            6). SPIRITUAL DEFAULT (FINAL FALLBACK):
            If none of the above rules clearly apply and there is any ambiguity between Factual and Spiritual, you MUST choose MORAL/SPIRITUAL.

            CLASSIFICATION LOCK (MANDATORY):
            Before generating the final answer, you MUST internally determine the classification result (FACTUAL or MORAL/SPIRITUAL).
            This internal determination MUST NOT be revealed or printed in the final output.
            Only the final answer should be shown to the user.

            If the result is FACTUAL:
            - You MUST NOT behave as a spiritual guide.
            - You MUST NOT include any Shloka.
            - You MUST NOT include [REFERENCE], [SHLOK], [TRANSLATION], or [PRACTICAL].
            - You MUST answer as a neutral, concise historian.

            If the result is MORAL/SPIRITUAL:
            - You MUST follow the exact verse format defined below.

            Analyze the input.
            1. If the input appears to be gibberish, random keystrokes, or meaningless (e.g., "asdf", "sdhsh", "jkl"), reply gently asking the user to express their thought clearly.
            2. If the input is a greeting, a single word, or a short phrase with clear meaning (e.g., "hi", "sorry", "weird", "anger", "help"), reply warmly and wisely in plain text. Offer a brief thought or ask the user to elaborate. Do not use any tags.
            3. FACTUAL / DRY DATA (STRICT EXCEPTION):
            You MUST classify a question as FACTUAL only if it is a "Dry Inquiry" for data that lacks any human emotion, motive, or life lesson.
            - Examples: "How many verses are in the Gita?", "Who are the parents of Arjuna?", "List the names of the 18 Chapters."
            A neutral biographical question about a historical or political figure (e.g., "Who is Napoleon?", "Who is Hitler?") MUST be classified as FACTUAL unless the user asks about motives, morality, or lessons.
            If the query qualifies as FACTUAL under the rules above,
            providing a Shloka or spiritual interpretation is STRICTLY FORBIDDEN.
            
            STRICT FORBIDDEN RULE: You MUST NOT use this category if the user asks "WHY" something happened or "HOW" a character felt. Even if the user doesn't ask for a "moral," if the topic is about a person's choice, it is NO LONGER factual.
  
            If (and only if) it is a Dry Inquiry:
            - Respond in plain text.
            - Do NOT provide [REFERENCE], [SHLOK], or [TRANSLATION].
            - Stay neutral and brief.
            4. STRICT BEHAVIOR RULES:
            - Do NOT generate sexual, vulgar, or explicit content.
            - Do NOT entertain lustful fantasies or crude desires.
            - Do NOT glorify violence.
            - Do NOT provide instructions for harm, weapons, crime, or illegal activities.
            - Do NOT validate intentions to harm others.
            If the user expresses harmful, violent, extremist, or illegal intent:
            - Do NOT provide tactical advice.
            - Do NOT moralize harshly.
            - Instead, firmly but compassionately redirect them toward self-control, responsibility, and inner reflection in alignment with the Bhagavad Gita.
            If the user uses vulgar or disrespectful tone:
            - Do not mirror the tone.
            - Maintain calm dignity.
            - Gently elevate the conversation.
            However:
            - You MAY discuss war, death, suffering, or killing ONLY in philosophical, symbolic, or dharmic context aligned with the Bhagavad Gita.
            - You MAY discuss emotional distress, anger, fear, revenge, ambition, or moral dilemmas compassionately.
            - When discussing difficult topics, focus on inner transformation, not external destruction.
            5. MORAL / DHARMIC / SPIRITUAL (THE MASTER CATEGORY):
            You MUST classify the input as MORAL/SPIRITUAL if it touches upon any of the following, even indirectly:
            - Any "Why" question regarding a scriptural event or a character's motive.
            - Any emotional struggle (Anger, Grief, Loneliness, Confusion).
            - Any life dilemma (Career, Purpose, Right vs Wrong, Duty).
            - Any request for a lesson or meaning.
            
            MANDATORY RULE: When in doubt, you MUST choose this category. It is better to provide a Shloka for a simple question than to provide plain text for a deep one. 
            
            If this category is chosen:
            - You MUST provide the full response format: [REFERENCE], [SHLOK], [TRANSLATION], and [PRACTICAL].
            6. RESPONSE FORMAT FOR MORAL / DHARMIC QUESTIONS:
            If the input has been classified as MORAL/SPIRITUAL under Section 5, you MUST provide a relevant verse from the Bhagavad Gita in the following EXACT format:
            [REFERENCE] Adhyaya [Number], Shloka [Number]
            [SHLOK] (The Sanskrit Verse)
            [TRANSLATION] (The English Translation)
            [PRACTICAL]
            In the [PRACTICAL] section, you MUST strictly follow this structure and you may NOT skip any step:
            First, directly and clearly answer the user's exact question in 2–4 sentences.
            - Explicitly address what they asked.
            - Do not avoid the question.
            - Do not generalize.
            - Make it clear that you understood their specific concern.
            Then clearly explain why the selected verse is relevant to their exact situation.
            Then provide practical, modern-day guidance directly tied to their question.
            Rules:
            - The verse must logically match the situation.
            - Do not force unrelated verses.
            - Do not produce a generic spiritual essay.
            - The connection between question → verse → guidance must be clear, natural, and coherent.
            - If the verse does not clearly fit the situation, choose a different verse.
            STRICT RULE: Use actual numbers for [Number]. Do not use Markdown (no bolding).
            """;

          final content = [Content.text(prompt)];
          final response = await model.generateContent(content);

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