import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Ensure dotenv is initialized in main.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import '../widgets/common_widgets.dart';

class FestivalDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const FestivalDetailScreen({super.key, required this.data});

  @override
  State<FestivalDetailScreen> createState() => _FestivalDetailScreenState();
}

class _FestivalDetailScreenState extends State<FestivalDetailScreen> {
  String _geminiContent = "";
  bool _isAiLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGeminiInsight();
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

    Widget _buildAiBadge(double sw) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.02, vertical: sw * 0.01),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1), // Very light tint of your brand
          borderRadius: BorderRadius.circular(sw * 0.02),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: sw * 0.03, color: primaryColor), // Small sparkle
            SizedBox(width: sw * 0.01),
            Text(
              "AI INSIGHT",
              style: TextStyle(
                color: primaryColor,
                fontSize: sw * 0.025,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

  Future<void> _fetchGeminiInsight() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) throw Exception("API Key missing");

      // Sequential fallback through your models
      final List<String> modelPriority = [
        'gemini-3-flash-preview',
        'gemini-2.5-flash',
        'gemini-2.5-flash-lite',
      ];

      String? generatedText;

      for (String modelName in modelPriority) {
        try {
          final model = GenerativeModel(
            model: modelName,
            apiKey: apiKey,
          );

          final festivalName = widget.data['Name'] ?? 'this festival';
          final prompt = "In two concise sentences, explain why $festivalName matters in today's modern world and its relevance to contemporary society.";

          final content = [Content.text(prompt)];
          final response = await model.generateContent(content);
          
          if (response.text != null && response.text!.isNotEmpty) {
            // APPLY THE FOOLPROOF SANITIZER HERE
            generatedText = _sanitizeGeminiOutput(response.text!);
            break; // Success!
          }
        } catch (e) {
          debugPrint("Model $modelName failed: $e");
          continue; // Try the next model in the list
        }
      }

      if (mounted) {
        setState(() {
          _geminiContent = generatedText ?? "This tradition remains a vital pillar of our shared heritage.";
          _isAiLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _geminiContent = "Cultural contexts are evolving; this tradition continues to provide spiritual grounding.";
          _isAiLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    final sw = mq.width;
    final sh = mq.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.data['Name'] ?? 'Festival',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.06,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: sw * 0.055),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: sh * 0.02),
              const Center(child: SamskaraLogo()),
              SizedBox(height: sh * 0.04),

              Row(
                children: [
                  Icon(Icons.history_edu_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("History", sw),
                ],
              ),
              _buildSectionContent(widget.data['History'], sw, sh),

              SizedBox(height: sh * 0.04),

              Row(
                children: [
                  Icon(Icons.auto_awesome, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("Significance", sw),
                ],
              ),
              _buildSectionContent(widget.data['Significance'], sw, sh),

              SizedBox(height: sh * 0.04),

              Row(
                children: [
                  Icon(Icons.map_outlined, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("Regional Rituals", sw),
                ],
              ),
              SizedBox(height: sh * 0.01),
              _buildRitualsList(sw, sh),
              
              SizedBox(height: sh * 0.04),

              // GEMINI SECTION
              _buildGeminiSection(sw, sh),
              
              SizedBox(height: sh * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeminiSection(double sw, double sh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.balance_rounded, color: primaryColor, size: sw * 0.05),
            SizedBox(width: sw * 0.02),
            _buildSectionTitle("Modern Relevance", sw),
            // --- THE BADGE GOES HERE ---
            SizedBox(width: sw * 0.03), // Gap before badge
            _buildAiBadge(sw),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: sh * 0.01),
          child: _isAiLoading 
            ? LinearProgressIndicator(
                backgroundColor: primaryColor.withAlpha(25),
                color: primaryColor,
                minHeight: 2,
              )
            : Text(
                _geminiContent,
                style: TextStyle(
                  color: primaryColor.withAlpha(204), // 0.8 opacity
                  fontSize: sw * 0.04,
                  height: 1.6,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, double sw) {
    return Text(
      title,
      style: TextStyle(
        color: primaryColor,
        fontSize: sw * 0.05,
        fontWeight: FontWeight.bold,
        fontFamily: 'Serif',
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSectionContent(String? content, double sw, double sh) {
    return Padding(
      padding: EdgeInsets.only(top: sh * 0.01),
      child: Text(
        content ?? "Details coming soon...",
        style: TextStyle(
          color: primaryColor.withAlpha(204),
          fontSize: sw * 0.04,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildRitualsList(double sw, double sh) {
    final Map<String, dynamic> rituals = widget.data['RegionalRituals'] as Map<String, dynamic>? ?? {};
    
    if (rituals.isEmpty) {
      return _buildSectionContent("No specific regional rituals recorded.", sw, sh);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rituals.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: sh * 0.02),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: primaryColor.withAlpha(204), 
                fontSize: sw * 0.04, 
                height: 1.6
              ),
              children: [
                TextSpan(
                  text: "${entry.key}: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: primaryColor
                  ),
                ),
                TextSpan(text: entry.value.toString()),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}