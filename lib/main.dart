import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/festivalscript.dart'; // Import the script to populate the database
import 'utils/storiesscript.dart'; // Import the script to populate the database
import 'widgets/common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found. Ensure it is in root and added to pubspec.yaml assets.");
  }
  await Firebase.initializeApp();
  // Run the script once
  await populateEncylopeadicFestivals();
  await uploadStories();
  // 1. Fetch data before the app starts
  final wisdomService = WisdomService();
  final initialWisdom = await wisdomService.getDailyWisdom();

  // 2. Pass it to MyApp
  runApp(MyApp(initialWisdom: initialWisdom));
}

// Define your colors here so they are accessible
const Color primaryColor = Color(0xFF6B3C3A);
const Color backgroundColor = Color(0xFFFDF5E6); // Replace with your exact cream color

class MyApp extends StatelessWidget {
  final Map<String, dynamic> initialWisdom;
  const MyApp({super.key, required this.initialWisdom});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samskara UI',
      theme: ThemeData(
        fontFamily: 'Sans-Serif',
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor, // <--- SET THIS
        canvasColor: backgroundColor,             // <--- SET THIS
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          surface: backgroundColor,               // <--- SET THIS
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          precacheImage(const AssetImage('assets/Splash.PNG'), context);
          // While checking auth state, don't show a white screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: backgroundColor, // Ensure this is themed
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SamskaraLogo(),
                    SizedBox(height: 20),
                    CircularProgressIndicator(color: primaryColor),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            // PASS THE DATA HERE
            return HomeScreen(initialWisdom: initialWisdom);
          }
          return const LoginScreen();
        },
      ),
    );
  }
}