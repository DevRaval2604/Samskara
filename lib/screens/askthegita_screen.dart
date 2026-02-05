import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class AskTheGitaScreen extends StatelessWidget {
  const AskTheGitaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: Text(
        "Ask the Gita",
        style: TextStyle(fontSize: size.width * 0.05, color: primaryColor.withValues(alpha: 0.6)),
      ),
    );
  }
}