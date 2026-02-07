import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final String? postRegistrationMessage;

  const LoginScreen({super.key, this.postRegistrationMessage});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Keys to trigger shake animation
  final GlobalKey<ShakeWidgetState> _emailShakeKey =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _passwordShakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    super.initState();
    if (widget.postRegistrationMessage != null) {
      // Show snackbar after the frame has been rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInfo(widget.postRegistrationMessage!);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide previous if any
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

  void _showInfo(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide previous if any
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

  void _validateAndLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      _emailShakeKey.currentState?.shake();
      _showError("Please enter your email address.");
      return;
    }
    if (!RegExp(
      r"^[\w\.\+\-]+@([\w-]+\.)+[a-zA-Z]{2,}$")
      .hasMatch(email)) {
      _emailShakeKey.currentState?.shake();
      _showError("Please enter a valid email address.");
      return;
    }

    if (password.isEmpty) {
      _passwordShakeKey.currentState?.shake();
      _showError("Please enter your password.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        await user.reload();
        if (!mounted) return;

        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser != null) {
          // Check if they have Google linked
          bool isGoogleUser = refreshedUser.providerData.any((p) => p.providerId == 'google.com');

          // EDGE CASE FIX: Only block if NOT verified AND NOT a Google user
          if (!refreshedUser.emailVerified && !isGoogleUser) {
            _showError("Please verify your email to login.");
            await FirebaseAuth.instance.signOut();
            return;
          }
        }

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut, // Starts fast to feel responsive
                ),
                child: child,
              );
            },
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed. Please check your credentials.";
      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      _showError(errorMessage);
    } catch (e) {
      _showError("An unexpected error occurred: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null &&
          (userCredential.additionalUserInfo?.isNewUser ?? false)) {
        try {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .set({
            'Name': user.displayName ?? '',
            'Email': user.email ?? '',
          });
        } catch (e) {
          // If saving user details fails, sign them out to avoid an inconsistent state.
          await _googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
          _showError("Failed to save user details. Please try again.");
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      }

      // On success, navigate to home screen.
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut, // Starts fast to feel responsive
                ),
                child: child,
              );
            },
          ),
        );
      }
    } catch (e) {
      // This will catch errors from GoogleSignIn().signIn() or signInWithCredential()
      _showError("Google Sign-In failed. Please try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _emailExists(String email) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('Email', isEqualTo: email)
      .limit(1)
      .get();

  return snapshot.docs.isNotEmpty;
}
  void _passwordReset() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _emailShakeKey.currentState?.shake();
      _showError("Please enter your email address to reset password.");
      return;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _emailShakeKey.currentState?.shake();
      _showError("Please enter a valid email address.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool exists = await _emailExists(email);
      if (!exists) {
        _showError("No account found for this email.");
        return;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showInfo("Password reset link sent to your email.");
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to send password reset email.";
      errorMessage = e.message ?? errorMessage;
      _showError(errorMessage);
    } catch (e) {
      _showError("An unexpected error occurred: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Screen Height & Width
    final size = MediaQuery.sizeOf(context);
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            // 2. Scrollable to prevent overflow on tiny screens
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                // 3. ConstrainedBox ensures the app doesn't stretch ugly on Tablets/Web
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Dynamic Top Spacing
                      SizedBox(height: screenHeight * 0.05),

                      const SamskaraLogo(),

                      // Dynamic Spacing (3% of screen height)
                      SizedBox(height: screenHeight * 0.03),

                      ShakeWidget(
                          key: _emailShakeKey,
                          child: CustomTextField(
                              hintText: "Email Address",
                              controller: _emailController)),
                      SizedBox(height: screenHeight * 0.02),
                      ShakeWidget(
                          key: _passwordShakeKey,
                          child: CustomTextField(
                              hintText: "Password",
                              isPassword: true,
                              controller: _passwordController)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _passwordReset,
                          child: Text("Forgot password?",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: screenWidth * 0.035,
                                decoration: TextDecoration.underline,
                                decorationColor: primaryColor,
                              )),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      PrimaryButton(text: "Login", onPressed: _validateAndLogin),
                      SizedBox(height: screenHeight * 0.03),

                      Row(children: [
                        const Expanded(child: Divider(color: primaryColor)),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04),
                            child: Text("OR",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: screenWidth * 0.035))),
                        const Expanded(child: Divider(color: primaryColor)),
                      ]),

                      SizedBox(height: screenHeight * 0.03),

                      // Responsive Google Button
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.07,
                        child: OutlinedButton(
                          onPressed: _signInWithGoogle,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google_logo.png',
                                height: screenHeight * 0.03,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text("Continue with Google",
                                  style: TextStyle(
                                      color: primaryColor, fontSize: screenWidth * 0.04)),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New here? ",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: primaryColor)),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 200),
                                    // For a replacement switch, we don't need a reverse duration 
                                    // because the old screen is being destroyed immediately.
                                    pageBuilder: (context, animation, secondaryAnimation) => const RegisterScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        // Use easeOut for a 'quick start' feel on the new screen
                                        opacity: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOut,
                                        ),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text("Create an account",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.04,
                                    color: primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: primaryColor,
                                  )),
                            ),
                          ]),

                      // Bottom safety padding
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}