import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/get_initials.dart';
import '../widgets/common_widgets.dart';

class InitialsAvatar extends StatelessWidget {
  final double radius;
  final double fontSize;
  final String? name;

  const InitialsAvatar({super.key, this.radius = 20, this.fontSize = 18, this.name});

  @override
  Widget build(BuildContext context) {
    if (name != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: primaryColor.withValues(alpha: 0.8),
        child: Text(
          getInitials(name),
          style: TextStyle(color: backgroundColor, fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: primaryColor.withValues(alpha: 0.2),
        child: Icon(Icons.person, size: radius, color: primaryColor),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        String initials = getInitials(user.displayName);
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final name = data?['Name'] as String? ?? user.displayName;
          initials = getInitials(name);
        }

        return CircleAvatar(
          radius: radius,
          backgroundColor: primaryColor.withValues(alpha: 0.8),
          child: Text(
            initials,
            style: TextStyle(color: backgroundColor, fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}