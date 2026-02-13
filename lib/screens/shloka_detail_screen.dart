import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common_widgets.dart';

class ShlokaDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isInitiallySaved;

  const ShlokaDetailScreen({
    super.key,
    required this.data,
    required this.isInitiallySaved,
  });

  @override
  State<ShlokaDetailScreen> createState() => _ShlokaDetailScreenState();
}

class _ShlokaDetailScreenState extends State<ShlokaDetailScreen> {
  late bool _isSaved;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Instant state sync from previous screen to prevent UI flicker
    _isSaved = widget.isInitiallySaved;
  }

  Future<void> _toggleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('SavedShlokas')
        .doc(widget.data['Source']);

    setState(() => _isSaved = !_isSaved);

    try {
      if (_isSaved) {
        final Map<String, dynamic> dataToSave = Map<String, dynamic>.from(widget.data);
        // Ensure pool-specific data doesn't clutter the user collection
        dataToSave.remove('DeleteAt');
        dataToSave.remove('CreatedAt');
        
        await docRef.set({
          ...dataToSave,
          'SavedAt': FieldValue.serverTimestamp(), // [2026-02-11] Capitalized
        });
      } else {
        await docRef.delete();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaved = !_isSaved);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sync failed. Check your connection.")),
        );
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
          "Wisdom Revealed",
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.06,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: primaryColor,
              size: sw * 0.065,
            ),
            onPressed: _toggleSave,
          ),
          SizedBox(width: sw * 0.02),
        ],
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

              // 1. SCRIPTURE REFERENCE
              Row(
                children: [
                  Icon(Icons.history_edu_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("Scripture", sw),
                ],
              ),
              _buildSectionContent(widget.data['Source'], sw, sh),

              SizedBox(height: sh * 0.04),

              // 2. SACRED SHLOKA
              Row(
                children: [
                  Icon(Icons.auto_stories_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("Sacred Shlok", sw),
                ],
              ),
              _buildSectionContent(widget.data['Shloka'], sw, sh, isItalic: true),

              SizedBox(height: sh * 0.04),

              // 3. TRANSLATION
              Row(
                children: [
                  Icon(Icons.translate_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("Translation", sw),
                ],
              ),
              _buildSectionContent(widget.data['Meaning'], sw, sh),

              SizedBox(height: sh * 0.04),

              // 4. MODERN RELEVANCE
              Row(
                children: [
                  Icon(Icons.balance_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("Modern Relevance", sw),
                ],
              ),
              _buildSectionContent(widget.data['Explanation'], sw, sh),

              SizedBox(height: sh * 0.05),
            ],
          ),
        ),
      ),
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

  Widget _buildSectionContent(String? content, double sw, double sh, {bool isItalic = false}) {
    return Padding(
      padding: EdgeInsets.only(top: sh * 0.015),
      child: Text(
        content ?? "Wisdom is timeless...",
        style: TextStyle(
          color: primaryColor.withValues(alpha: 0.8),
          fontSize: sw * 0.04,
          height: 1.6,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }
}