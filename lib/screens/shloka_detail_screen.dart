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
    final sw = MediaQuery.sizeOf(context).width;
    final sh = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Wisdom Revealed",
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.06,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
              color: primaryColor,
              size: sw * 0.065,
            ),
            onPressed: _toggleSave,
          ),
          SizedBox(width: sw * 0.02),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
          child: Column(
            children: [
              SizedBox(height: sh * 0.02),
              const SamskaraLogo(),
              SizedBox(height: sh * 0.05),

              // THE REPLICATED WISDOM CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: sw * 0.05, horizontal: sw * 0.04),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(sw * 0.05),
                  border: Border.all(color: primaryColor, width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInternalBlock("Reference", widget.data['Source'] ?? '', sw, sh),
                    _buildInternalBlock("Sacred Shlok", widget.data['Shloka'] ?? '', sw, sh, isSanskrit: true, isItalic: true),
                    _buildInternalBlock("Meaning", widget.data['Meaning'] ?? '', sw, sh),
                    _buildInternalBlock("Modern Relevance", widget.data['Explanation'] ?? '', sw, sh, isJustified: true),
                  ],
                ),
              ),
              SizedBox(height: sh * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // REPLICATED INTERNAL BLOCK FROM HOME TAB
  Widget _buildInternalBlock(String title, String content, double sw, double sh, 
      {bool isSanskrit = false, bool isItalic = false, bool isJustified = false}) {
    
    return Padding(
      padding: EdgeInsets.only(bottom: sh * 0.012),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(sw * 0.035),
        decoration: BoxDecoration(
          color: backgroundColor, 
          borderRadius: BorderRadius.circular(sw * 0.05),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Column(
          children: [
            Text(title.toUpperCase(), 
              style: TextStyle(
                color: primaryColor, 
                fontWeight: FontWeight.bold, 
                fontSize: sw * 0.030,
                letterSpacing: 1.0
              )),
            SizedBox(height: sh * 0.006),
            Text(
              content,
              textAlign: isJustified ? TextAlign.justify : TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: sw * 0.036,
                fontFamily: 'Serif',
                fontStyle: isItalic || isSanskrit ? FontStyle.italic : FontStyle.normal,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}