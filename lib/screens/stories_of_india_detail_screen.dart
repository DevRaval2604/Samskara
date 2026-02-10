import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // New Import
import 'package:cloud_firestore/cloud_firestore.dart'; // New Import
import '../widgets/common_widgets.dart';

class StoryDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const StoryDetailScreen({super.key, required this.data});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  bool _isSaved = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
  }

  // 1. Check if the story is already in the user's saved subcollection
  Future<void> _checkSavedStatus() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('SavedStories')
        .doc(widget.data['Title'])
        .get();

    if (mounted) {
      setState(() => _isSaved = doc.exists);
    }
  }

  // 2. Toggle logic: Adds or Removes the document
  Future<void> _toggleSave() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('SavedStories')
        .doc(widget.data['Title']);

    // Optimistic Update: Change the UI immediately for a faster feel
    setState(() => _isSaved = !_isSaved);

    try {
      if (_isSaved) {
        // Save the whole data map plus a timestamp
        await docRef.set({
          ...widget.data,
          'savedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Delete from the subcollection
        await docRef.delete();
      }
    } catch (e) {
      // Revert if network fails
      setState(() => _isSaved = !_isSaved);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cloud sync failed. Check your connection.")),
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
          widget.data['Title'] ?? 'The Legend',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.05,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // THE SAVE BUTTON
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

              // THE SUMMARY SECTION
              Row(
                children: [
                  Icon(Icons.history_edu_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("The Summary", sw),
                ],
              ),
              _buildSummaryContent(widget.data['Summary'], sw, sh),

              SizedBox(height: sh * 0.04),

              // THE TALE SECTION
              Row(
                children: [
                  Icon(Icons.auto_stories_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("The Tale", sw),
                ],
              ),
              _buildSectionContent(widget.data['Description'], sw, sh),

              SizedBox(height: sh * 0.04),

              // THE MODERN EDGE SECTION
              Row(
                children: [
                  Icon(Icons.balance_rounded, color: primaryColor, size: sw * 0.05),
                  SizedBox(width: sw * 0.02),
                  _buildSectionTitle("The Modern Edge", sw),
                ],
              ),
              _buildModernEdgeContent(widget.data['Modern Edge'], sw, sh),

              SizedBox(height: sh * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // ... (Your buildSectionTitle, buildSectionContent, etc. helpers remain exactly the same)
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
      padding: EdgeInsets.only(top: sh * 0.015),
      child: Text(
        content ?? "The chronicles are being restored...",
        style: TextStyle(
          color: primaryColor.withValues(alpha: 0.8),
          fontSize: sw * 0.04,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildModernEdgeContent(String? content, double sw, double sh) {
    return Padding(
      padding: EdgeInsets.only(top: sh * 0.015),
      child: Text(
        content ?? "Values are eternal...",
        style: TextStyle(
          color: primaryColor.withValues(alpha: 0.8),
          fontSize: sw * 0.04,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildSummaryContent(String? summary, double sw, double sh) {
    return Padding(
      padding: EdgeInsets.only(top: sh * 0.015),
      child: Text(
        summary ?? "A glimpse into greatness...",
        style: TextStyle(
          color: primaryColor.withValues(alpha: 0.8),
          fontSize: sw * 0.04,
          height: 1.6,
        ),
      ),
    );
  }
}