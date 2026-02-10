import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import '../widgets/common_widgets.dart';
import 'festivelist_screen.dart';
import 'storiesofindia_screen.dart';
import 'askthegita_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'initials_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _userName;
  bool _isLoading = true;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  // Key to force total reset of the pages
  Key _pageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _setupUserListener();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  void _setupUserListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _navigateToLogin();
      return;
    }

    _userSubscription = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;

      String? name;
      if (snapshot.exists) {
        final data = snapshot.data();
        name = data?['Name'];
      }

      name ??= user.displayName;

      setState(() {
        _userName = name;
        _isLoading = false;
      });
    }, onError: (e) {
      if (mounted) {
        setState(() {
          _userName = user.displayName;
          _isLoading = false;
        });
      }
    });
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final List<Widget> pages = [
      _HomeTab(isLoading: _isLoading, userName: _userName, screenWidth: screenWidth),
      const FestiveListScreen(),
      const StoriesOfIndiaScreen(),
      const AskTheGitaScreen(),
      const SettingsScreen(),
    ];

    final List<String> titles = [
      "Home",
      "Indian Festivals",
      "Stories of India",
      "Ask the Gita",
      "Settings",
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(titles[_selectedIndex], style: TextStyle(color: primaryColor, fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async { // Changed to async
              await Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 200),
                  reverseTransitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                      reverseCurve: Curves.easeIn,
                    );

                    return FadeTransition(
                      opacity: curvedAnimation,
                      child: child,
                    );
                  },
                ),
              );
              // Force total reset by changing the key upon return
              if (mounted) {
                setState(() {
                  _pageKey = UniqueKey();
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.04),
              child: InitialsAvatar(
                radius: screenWidth * 0.055, 
                fontSize: screenWidth * 0.045, 
                name: _userName,
              ), 
            ),
          ),
        ],
      ),
      // KeyedSubtree forces the entire child tree to reset when _pageKey changes
      body: KeyedSubtree(
        key: _pageKey,
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.selected) ? primaryColor : primaryColor.withValues(alpha: 0.8);
            return TextStyle(color: color, fontWeight: FontWeight.w500);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.selected) ? primaryColor : primaryColor.withValues(alpha: 0.8);
            return IconThemeData(color: color);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          backgroundColor: backgroundColor,
          indicatorColor: primaryColor.withValues(alpha: 0.2),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.festival_outlined), selectedIcon: Icon(Icons.festival), label: 'Festivals'),
            NavigationDestination(icon: Icon(Icons.auto_stories_outlined), selectedIcon: Icon(Icons.auto_stories), label: 'Stories'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Gita'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

// Converted _HomeTab to StatefulWidget as requested
class _HomeTab extends StatefulWidget {
  final bool isLoading;
  final String? userName;
  final double screenWidth;

  const _HomeTab({
    required this.isLoading, 
    required this.userName, 
    required this.screenWidth
  });

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  @override
  Widget build(BuildContext context) {
    // Re-calculating size inside build for proper media query updates
    final sw = MediaQuery.sizeOf(context).width;

    return Center(
        child: widget.isLoading
            ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor))
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SamskaraLogo(),
                    const SizedBox(height: 60),
                    Text(
                      'Welcome,',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: sw * 0.07, color: primaryColor.withAlpha(200)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.userName ?? 'Valued User',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: sw * 0.08, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ],
                ),
              ),
    );
  }
}