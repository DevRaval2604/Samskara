import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class StoriesOfIndiaScreen extends StatelessWidget {
  const StoriesOfIndiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Stories of India",
        style: TextStyle(fontSize: 20, color: primaryColor.withValues(alpha: 0.6)),
      ),
    );
  }
}