import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class FestiveCalendarScreen extends StatelessWidget {
  const FestiveCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Festive Calendar",
        style: TextStyle(fontSize: 20, color: primaryColor.withValues(alpha: 0.6)),
      ),
    );
  }
}