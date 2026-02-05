import 'package:flutter/material.dart';
import 'dart:math';

const Color backgroundColor = Color(0xFFF8F4E9);
const Color primaryColor = Color(0xFF6B3C3A);
const Color inputFillColor = Color(0xFFFDFBF7);
const Color borderColor = Color(0xFFDCC8B0);

// --- 1. Responsive Logo ---
class SamskaraLogo extends StatelessWidget {
  const SamskaraLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.sizeOf(context);
    
    // Logic: On smaller screens, make logo smaller. 
    // We use a percentage of the screen height.
    final double logoHeight = size.height * 0.15; // 15% of screen height
    final double fontSize = size.width * 0.08; // Dynamic font size based on width

    return Column(
      children: [
        Image.asset(
          'assets/Splash.PNG',
          height: logoHeight, 
          errorBuilder: (context, error, stackTrace) => Icon(Icons.spa, size: logoHeight, color: primaryColor),
        ),
        SizedBox(height: size.height * 0.02), // 2% dynamic space
        Text(
          "Awaken the\nWisdom Within",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Serif', 
            fontSize: fontSize,
            height: 1.1,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// --- 4. Shake Animation Widget ---
class ShakeWidget extends StatefulWidget {
  final Widget child;
  const ShakeWidget({super.key, required this.child});

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Simple damped sine wave for shaking
        final double sine = 10 * sin(4 * pi * _controller.value);
        final double offset = sine * (1 - _controller.value);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

// --- 2. Custom Input Field ---
class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return TextField(
      controller: widget.controller,
      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
      cursorColor: primaryColor,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.brown[300], fontSize: size.width * 0.04),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.02),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}

// --- 3. Responsive Button ---
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Buttons should generally be around 48-60px height for touch targets
    final size = MediaQuery.sizeOf(context);
    final double buttonHeight = size.height * 0.07; 
    
    return SizedBox(
      width: double.infinity,
      // Dynamic height based on screen height
      height: buttonHeight, 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(text, style: TextStyle(color: backgroundColor, fontSize: size.width * 0.045)),
      ),
    );
  }
}