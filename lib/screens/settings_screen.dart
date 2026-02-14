import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common_widgets.dart'; 
import 'login_screen.dart';
import 'contactus_screen.dart'; 
import 'aboutus_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- HELPER: PASSWORD VALIDATION ---
  bool _isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }

  // --- HELPER: CUSTOM SNACKBAR ---
  void _showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: primaryColor)),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: primaryColor, width: 1),
      ),
    ));
  }

  // --- STEP 1: VERIFY IDENTITY (For Email Users) ---
  void _showPasswordVerification(BuildContext context, double sw, {required Function onVerified}) {
    final TextEditingController passwordController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;
    bool isObscured = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.05)),
            title: Text("Verify Identity", 
              style: TextStyle(color: primaryColor, fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: sw * 0.055)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Enter your current password to proceed.",
                  style: TextStyle(color: primaryColor.withValues(alpha: 0.7), fontSize: sw * 0.038)),
                TextField(
                  controller: passwordController,
                  obscureText: isObscured,
                  cursorColor: primaryColor,
                  style: TextStyle(color: primaryColor),
                  decoration: InputDecoration(
                    hintText: "Current Password",
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    suffixIcon: IconButton(
                      icon: Icon(isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                        color: primaryColor.withValues(alpha: 0.6), size: sw * 0.05),
                      onPressed: () => setState(() => isObscured = !isObscured),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () async {
                  try {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: auth.currentUser!.email!,
                      password: passwordController.text.trim(),
                    );
                    await auth.currentUser!.reauthenticateWithCredential(credential);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    onVerified(); 
                  } catch (e) {
                    if (!context.mounted) return;
                    Navigator.pop(context); 
                    _showCustomSnackBar(context, "Verification failed. Please check your password and try again.");
                  }
                },
                child: Text("Verify", style: TextStyle(color: backgroundColor)),
              ),
            ],
          );
        },
      ),
    );
  }

   void _showPasswordVerificationtodelete(BuildContext context, double sw, {required Function onVerified}) {
    final TextEditingController passwordController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;
    bool isObscured = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.05)),
            title: Text("Verify Identity", 
              style: TextStyle(color: primaryColor, fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: sw * 0.055)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Enter you password to proceed with account deletion.",
                  style: TextStyle(color: primaryColor.withValues(alpha: 0.7), fontSize: sw * 0.038)),
                TextField(
                  controller: passwordController,
                  obscureText: isObscured,
                  cursorColor: primaryColor,
                  style: TextStyle(color: primaryColor),
                  decoration: InputDecoration(
                    hintText: "Password",
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    suffixIcon: IconButton(
                      icon: Icon(isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                        color: primaryColor.withValues(alpha: 0.6), size: sw * 0.05),
                      onPressed: () => setState(() => isObscured = !isObscured),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () async {
                  try {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: auth.currentUser!.email!,
                      password: passwordController.text.trim(),
                    );
                    await auth.currentUser!.reauthenticateWithCredential(credential);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    onVerified(); 
                  } catch (e) {
                    if (!context.mounted) return;
                    Navigator.pop(context); 
                    _showCustomSnackBar(context, "Verification failed. Please check your password and try again.");
                  }
                },
                child: Text("Verify", style: TextStyle(color: backgroundColor)),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- STEP 2: SET/CHANGE PASSWORD DIALOG ---
  void _showSetNewPasswordDialog(BuildContext context, double sw, bool isSetting) {
    final TextEditingController newPassController = TextEditingController();
    bool isObscured = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.05)),
          title: Text(isSetting ? "Set Password" : "Change Password", 
            style: TextStyle(color: primaryColor, fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: sw * 0.055)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Your password must be at least 8 characters long and include uppercase, lowercase, a special character, and a number.",
                style: TextStyle(color: primaryColor.withValues(alpha: 0.7), fontSize: sw * 0.035)),
              TextField(
                controller: newPassController,
                obscureText: isObscured,
                cursorColor: primaryColor,
                style: TextStyle(color: primaryColor),
                decoration: InputDecoration(
                  hintText: "New Password",
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  suffixIcon: IconButton(
                    icon: Icon(isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                      color: primaryColor.withValues(alpha: 0.6), size: sw * 0.05),
                    onPressed: () => setState(() => isObscured = !isObscured),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () async {
                String pass = newPassController.text.trim();
                if (!_isPasswordValid(pass)) {
                  if (!context.mounted) return;
                  Navigator.pop(context); 
                  _showCustomSnackBar(context, "Password does not meet requirements.");
                  return;
                }
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;

                  if (isSetting) {
                    // LINK Google account with a Password Credential
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user.email!, 
                      password: pass,
                    );
                    await user.linkWithCredential(credential);
                  } else {
                    // UPDATE existing Email provider password
                    await user.updatePassword(pass);
                  }

                  // --- ADD THIS LINE HERE ---
                  await user.reload();

                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _showCustomSnackBar(context, "Password ${isSetting ? 'set' : 'changed'} successfully!");
                  this.setState(() {}); // Refresh build to update tile label
                } on FirebaseAuthException catch (e) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  // PERMANENT FIX: Specifically handle the 'Recent Login' security wall
                  if (e.code == 'requires-recent-login') {
                    _showCustomSnackBar(context, "Security Timeout: Please log out and back in to change password.");
                  } else if (e.code == 'provider-already-linked') {
                    _showCustomSnackBar(context, "This account already has a password set.");
                  } else {
                    _showCustomSnackBar(context, "Error: ${e.message}");
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  Navigator.pop(context); 
                  _showCustomSnackBar(context, "An unexpected error occurred. Please try again.");
                }
              },
              child: Text(isSetting ? "Set" : "Update", style: TextStyle(color: backgroundColor)),
            ),
          ],
        ),
      ),
    );
  }

  // --- DELETE CONFIRMATION ---
  void _showDeleteConfirmation(BuildContext context, double sw) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.05)),
        title: Text("Delete Account", style: TextStyle(color: primaryColor, fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: sw * 0.055)),
        content: Text("This action is permanent. Are you sure you wish to leave the path entirely?", 
          style: TextStyle(color: primaryColor.withValues(alpha: 0.8), fontSize: sw * 0.04)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                try {
                  // Attempt data and account deletion
                  await FirebaseFirestore.instance.collection('Users').doc(user.uid).delete();
                  await user.delete();
                  
                  if (!context.mounted) return;
                  _showCustomSnackBar(context, "Account successfully deleted.");
                  Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut, // Quick entrance for the reset
                          ),
                          child: child,
                        );
                      },
                    ),
                    (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  if (!context.mounted) return;
                  Navigator.pop(context); // Close the dialog so SnackBar is visible
                  
                  if (e.code == 'requires-recent-login') {
                    _showCustomSnackBar(context, "Security Timeout: Please log out and back in to delete your account.");
                  } else {
                    _showCustomSnackBar(context, "Error: ${e.message}");
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _showCustomSnackBar(context, "An unexpected error occurred.");
                }
              }
            },
            child: const Text("Delete", style: TextStyle(color: backgroundColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double sw = size.width;
    final double sh = size.height;

    // Check if user has a password provider (password auth) or just Google
    // Check fresh instance directly during every rebuild
    bool hasPassword = FirebaseAuth.instance.currentUser?.providerData.any((p) => p.providerId == 'password') ?? false;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: sh * 0.02),
            const SamskaraLogo(), 
            SizedBox(height: sh * 0.04),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.lock_outline_rounded,
                    label: hasPassword ? "Change Password" : "Set Password",
                    sw: sw,
                    onTap: () {
                      if (hasPassword) {
                        _showPasswordVerification(context, sw, onVerified: () => _showSetNewPasswordDialog(context, sw, false));
                      } else {
                        _showSetNewPasswordDialog(context, sw, true);
                      }
                    },
                  ),
                  SizedBox(height: sw * 0.02),
                  _buildSettingTile(
                    icon: Icons.delete_outline_rounded,
                    label: "Delete Account",
                    sw: sw,
                    onTap: () {
                      if (hasPassword) {
                        // If they have a password, they MUST verify it first
                        _showPasswordVerificationtodelete(context, sw, onVerified: () => _showDeleteConfirmation(context, sw));
                      } else {
                        // If they are a Google user (no password set), go straight to the "Are you sure?" box
                        _showDeleteConfirmation(context, sw);
                      }
                    },
                  ),
                  SizedBox(height: sw * 0.02),
                  _buildSettingTile(
                    icon: Icons.chat_bubble_outline_rounded, 
                    label: "Contact Us", 
                    sw: sw, 
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 200),
                          reverseTransitionDuration: const Duration(milliseconds: 200), 
                          pageBuilder: (context, animation, secondaryAnimation) => const ContactUsScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            // This Curve makes 200ms feel much faster and "lighter"
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,         // Fast start for opening
                              reverseCurve: Curves.easeIn,   // Fast end for closing
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
                  SizedBox(height: sw * 0.02),
                  _buildSettingTile(icon: Icons.info_outline_rounded, 
                  label: "About Us", sw: sw, 
                  onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 200),
                          reverseTransitionDuration: const Duration(milliseconds: 200), 
                          pageBuilder: (context, animation, secondaryAnimation) => const AboutUsScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            // This Curve makes 200ms feel much faster and "lighter"
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,         // Fast start for opening
                              reverseCurve: Curves.easeIn,   // Fast end for closing
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
                  SizedBox(height: sw * 0.02),
                ],
              ),
            ),
            SizedBox(height: sh * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String label, required double sw, required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: sw * 0.04),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(sw * 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: sw * 0.045, horizontal: sw * 0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sw * 0.04),
            border: Border.all(color: primaryColor, width: 1.2),
          ),
          child: Row(
            children: [
              Icon(icon, color: primaryColor, size: sw * 0.065),
              SizedBox(width: sw * 0.04),
              Expanded(child: Text(label, style: TextStyle(color: primaryColor, fontSize: sw * 0.045, fontWeight: FontWeight.w600))),
              Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: sw * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}