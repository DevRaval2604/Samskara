import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<ShakeWidgetState> _nameShakeKey =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _emailShakeKey =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _passwordShakeKey =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _confirmPasswordShakeKey =
      GlobalKey<ShakeWidgetState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: primaryColor)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: primaryColor, width: 1),
        ),
      ),
    );
  }

  void _validateAndRegister() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      _nameShakeKey.currentState?.shake();
      _showError("Please enter your full name.");
      return;
    }

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
      _showError("Please enter a password.");
      return;
    }

    if (password.length < 8) {
      _passwordShakeKey.currentState?.shake();
      _showError("Password must be at least 8 characters long.");
      return;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      _passwordShakeKey.currentState?.shake();
      _showError("Password must contain at least one uppercase letter.");
      return;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      _passwordShakeKey.currentState?.shake();
      _showError("Password must contain at least one lowercase letter.");
      return;
    }

    if (!RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) {
      _passwordShakeKey.currentState?.shake();
      _showError("Password must contain at least one special character.");
      return;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      _passwordShakeKey.currentState?.shake();
      _showError("Password must contain at least one digit.");
      return;
    }

    if (password != confirmPassword) {
      _confirmPasswordShakeKey.currentState?.shake();
      _showError("Passwords do not match.");
      return;
    }

    if (!isChecked) {
      _showError("Please agree to the Terms & Privacy Policy to continue.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);

        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'Name': name,
          'Email': email,
        });
        await user.reload();
        await user.sendEmailVerification();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(
                postRegistrationMessage:
                    "Registration successful! Please check your email to verify your account.",
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut, // Fast entry for the success message
                  ),
                  child: child,
                );
              },
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showError('An account already exists for that email.');
      } else {
        _showError(e.message ?? "An error occurred. Please try again.");
      }
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
    final size = MediaQuery.sizeOf(context);
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      const SamskaraLogo(),
                      SizedBox(height: screenHeight * 0.03),
                      ShakeWidget(
                        key: _nameShakeKey,
                        child: CustomTextField(
                          hintText: "Full Name",
                          controller: _nameController,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ShakeWidget(
                        key: _emailShakeKey,
                        child: CustomTextField(
                          hintText: "Email Address",
                          controller: _emailController,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ShakeWidget(
                        key: _passwordShakeKey,
                        child: CustomTextField(
                          hintText: "Password",
                          isPassword: true,
                          controller: _passwordController,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ShakeWidget(
                        key: _confirmPasswordShakeKey,
                        child: CustomTextField(
                            hintText: "Confirm Password",
                            isPassword: true,
                            controller: _confirmPasswordController),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            height: screenWidth * 0.06,
                            width: screenWidth * 0.06,
                            child: Checkbox(
                              side: const BorderSide(
                                  color: primaryColor, width: 2.0),
                              value: isChecked,
                              checkColor: backgroundColor,
                              activeColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) =>
                                  setState(() => isChecked = val!),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Text(
                              "Agree to the Terms & Privacy Policy",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      PrimaryButton(
                        text: "Register",
                        onPressed: _validateAndRegister,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 200),
                                pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut, // Makes the 200ms feel snappier
                                    ),
                                    child: child,
                                  );
                                },
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                                color: primaryColor,
                                decoration:
                                    TextDecoration.underline,
                                decorationColor: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  valueColor:
                      AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
