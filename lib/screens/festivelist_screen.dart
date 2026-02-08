import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class FestiveListScreen extends StatelessWidget {
  const FestiveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Festive List",
        style: TextStyle(fontSize: 20, color: primaryColor.withValues(alpha: 0.6)),
      ),
    );
  }
}