import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../widgets/common_widgets.dart'; 

class AskTheGitaScreen extends StatefulWidget {
  const AskTheGitaScreen({super.key});

  @override
  State<AskTheGitaScreen> createState() => _AskTheGitaScreenState();
}

class _AskTheGitaScreenState extends State<AskTheGitaScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  String? _shlok;
  String? _translation;
  String? _verseRef;
  String? _interpretation;
  String? _simpleResponse;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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

  bool _isAppropriate(String query) {
    final forbidden = ['hate', 'violence', 'abuse', 'kill', 'suicide', 'illegal', 'sex'];
    return !forbidden.any((word) => query.toLowerCase().contains(word));
  }

  Future<void> _getGitaWisdom() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    _focusNode.unfocus();

    if (query.length < 2 || !RegExp(r'[a-zA-Z]').hasMatch(query)) {
      _showCustomSnackBar("Please express your thought in words.");
      return;
    }

    if (!_isAppropriate(query)) {
      _showCustomSnackBar("Please seek wisdom with a pure intent.");
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

      for (String modelName in modelPriority) {
        try {
          final model = GenerativeModel(
            model: modelName, 
            apiKey: apiKey,
          );

          final prompt = """
            You are a wise, compassionate Vedic guide based on the Bhagavad Gita. The user says: "$query".

            Analyze the input.
            1. If the input appears to be gibberish, random keystrokes, or meaningless (e.g., "asdf", "sdhsh", "jkl"), reply gently asking the user to express their thought clearly.
            2. If the input is a greeting, a single word, or a short phrase with clear meaning (e.g., "hi", "sorry", "weird", "anger", "help"), reply warmly and wisely in plain text. Offer a brief thought or ask the user to elaborate. Do not use any tags.
            3. ONLY if the input is a complete question, a specific dilemma, or a sentence describing a situation/feeling (e.g., "I feel very angry", "How do I find peace?", "I am confused about my path"), provide a relevant verse from the Bhagavad Gita in the following EXACT format:
            [REFERENCE] Adhyay X, Shlok Y
            [SHLOK] (The Sanskrit Verse)
            [TRANSLATION] (The English Translation)
            [PRACTICAL] (Practical, simple modern-day guidance)
            """;

          final content = [Content.text(prompt)];
          final response = await model.generateContent(content);
          
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
                      ),
                      SizedBox(height: sh * 0.02),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            disabledBackgroundColor: primaryColor,
                            foregroundColor: backgroundColor,
                            disabledForegroundColor: backgroundColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.03)),
                            padding: EdgeInsets.symmetric(vertical: sh * 0.015),
                            elevation: 0,
                          ),
                          onPressed: _getGitaWisdom,
                          child: Text("Get Gita Wisdom", style: TextStyle(fontSize: sw * 0.045, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_simpleResponse != null) ...[
                SizedBox(height: sh * 0.04),
                _buildWisdomCard("Guide's Reply", _simpleResponse!, sw, sh, isJustified: true),
                SizedBox(height: sh * 0.04),
              ],

              if (_shlok != null) ...[
                SizedBox(height: sh * 0.04),
                // New Card for the Verse Reference (Adhyay & Number)
              if (_verseRef != null) 
                _buildWisdomCard("Gita Adhyay & Shlok", _verseRef!, sw, sh),
                _buildWisdomCard("Sacred Shlok", _shlok!, sw, sh, isSanskrit: true),
                _buildWisdomCard("Translation", _translation!, sw, sh),
                _buildWisdomCard("Practical Guidance", _interpretation!, sw, sh, isJustified: true),
                SizedBox(height: sh * 0.04),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWisdomCard(String title, String content, double sw, double sh, {bool isSanskrit = false, bool isJustified = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.06, vertical: sh * 0.01),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(sw * 0.05),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sw * 0.05),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Column(
          children: [
            Text(title.toUpperCase(), style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: sw * 0.03, letterSpacing: 1.5)),
            SizedBox(height: sh * 0.015),
            SelectableText(
              content,
              textAlign: isJustified ? TextAlign.justify : TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: sw * 0.042,
                fontFamily: 'Serif',
                fontStyle: isSanskrit ? FontStyle.italic : FontStyle.normal,
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}