import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';
import '../utils/get_initials.dart';
import 'saved_stories_screen.dart';
import 'saved_shlokas_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // --- THEMED LOGOUT CONFIRMATION DIALOG ---
  Future<void> _showLogoutConfirmation(double sw) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.05)),
        title: Text(
          "Depart for now?",
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.055,
          ),
        ),
        content: Text(
          "Are you sure you wish to sign out and pause your journey of wisdom?",
          style: TextStyle(
            color: primaryColor.withValues(alpha: 0.8),
            fontSize: sw * 0.04,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Stay",
              style: TextStyle(color: Colors.grey, fontSize: sw * 0.04, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.02)),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _signOut(); // Execute sign out
            },
            child: Text(
              "Depart",
              style: TextStyle(color: backgroundColor, fontSize: sw * 0.04, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Responsive Edit Name Dialog
  Future<void> _editName(String currentName, double sw) async {
    TextEditingController nameController = TextEditingController(text: currentName);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.04)),
        title: Text("Edit Name", style: TextStyle(color: primaryColor, fontFamily: 'Serif', fontSize: sw * 0.05)),
        content: TextField(
          controller: nameController,
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: "Enter your name",
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          ),
          style: TextStyle(color: primaryColor, fontSize: sw * 0.045),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: sw * 0.04))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () async {
              final dialogNavigator = Navigator.of(context);
              await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.uid).update({'Name': nameController.text.trim()});
              if (!context.mounted) return;
              dialogNavigator.pop();
            },
            child: Text("Save", style: TextStyle(color: backgroundColor, fontSize: sw * 0.04)),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
  final navigator = Navigator.of(context);
  try {
    // 1. Sign out 
    await _auth.signOut();
    await _googleSignIn.signOut();
    
    if (!mounted) return;

    // 2. Use a 0ms transition or a very fast 100ms fade
    // This prevents the 'double animation' glitch
    navigator.pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: Duration.zero, // Instant swap
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    debugPrint('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text("Not logged in.")));

    final size = MediaQuery.sizeOf(context);
    final double sw = size.width;
    final double sh = size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: primaryColor, fontSize: sw * 0.06, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Keeps it transparent at rest
        elevation: 0, 
        scrolledUnderElevation: 0, // <--- THIS prevents the color change on scroll
        centerTitle: true,
        surfaceTintColor: Colors.transparent, // <--- THIS ensures no tint is applied
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)));
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final String name = userData['Name'] ?? user.displayName ?? 'No Name';
          final String email = userData['Email'] ?? user.email ?? 'No Email';
          final String initials = getInitials(name);

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: sh * 0.02),
                const SamskaraLogo(),
                SizedBox(height: sh * 0.04),

                CircleAvatar(
                  radius: sw * 0.14,
                  backgroundColor: primaryColor,
                  child: Text(initials, style: TextStyle(fontSize: sw * 0.09, fontWeight: FontWeight.bold, color: backgroundColor)),
                ),
                SizedBox(height: sh * 0.02),
                
                GestureDetector(
                  onTap: () => _editName(name, sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name, style: TextStyle(color: primaryColor, fontSize: sw * 0.065, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                      SizedBox(width: sw * 0.02),
                      Icon(Icons.edit_outlined, color: primaryColor, size: sw * 0.05),
                    ],
                  ),
                ),
                Text(email, style: TextStyle(color: primaryColor.withValues(alpha: 0.7), fontSize: sw * 0.04, fontFamily: 'Serif')),
                
                SizedBox(height: sh * 0.05),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
                  child: Row(
                    children: [
                      _buildGridItem(
                        Icons.auto_stories_outlined, 
                        "Saved Stories", 
                        sw, 
                        sh, 
                        () {
                          // Navigating to SavedStoriesScreen with your 200ms EaseOut animation
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 200),
                              reverseTransitionDuration: const Duration(milliseconds: 200),
                              pageBuilder: (context, animation, secondaryAnimation) => const SavedStoriesScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                // The 'easeOut' curve makes the 200ms feel snappy and premium
                                final curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,         
                                  reverseCurve: Curves.easeIn,   
                                );

                                return FadeTransition(
                                  opacity: curvedAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(width: sw * 0.04),
                      _buildGridItem(Icons.history_edu_outlined, "Saved Shlokas", sw, sh, () {
                        // Navigating to SavedStoriesScreen with your 200ms EaseOut animation
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 200),
                              reverseTransitionDuration: const Duration(milliseconds: 200),
                              pageBuilder: (context, animation, secondaryAnimation) => const SavedShlokasScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                // The 'easeOut' curve makes the 200ms feel snappy and premium
                                final curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,         
                                  reverseCurve: Curves.easeIn,   
                                );

                                return FadeTransition(
                                  opacity: curvedAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),

                SizedBox(height: sh * 0.06),

                // Updated Logout Button to trigger Confirmation
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
                  child: InkWell(
                    onTap: () => _showLogoutConfirmation(sw),
                    borderRadius: BorderRadius.circular(sw * 0.04),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(sw * 0.04),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: backgroundColor, size: sw * 0.06),
                          SizedBox(width: sw * 0.03),
                          Text("Log Out", style: TextStyle(color: backgroundColor, fontSize: sw * 0.045, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.04),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, double sw, double sh, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: sh * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sw * 0.05),
            border: Border.all(color: primaryColor, width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, size: sw * 0.1, color: primaryColor),
              SizedBox(height: sh * 0.01),
              Text(label, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: sw * 0.038)),
            ],
          ),
        ),
      ),
    );
  }
}