import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Settings",
        style: TextStyle(fontSize: 20, color: primaryColor.withValues(alpha: 0.6)),
      ),
    );
  }
}