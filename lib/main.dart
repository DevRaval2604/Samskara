import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/festivalscript.dart'; // Import the script to populate the database
import 'utils/storiesscript.dart'; // Import the script to populate the database
import 'widgets/common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Force Status Bar Icons to be visible
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Makes it seamless
    statusBarIconBrightness: Brightness.dark, // Dark icons (Clock/Battery) for light bg
    statusBarBrightness: Brightness.light, // For iOS support
    systemNavigationBarColor: backgroundColor, // Match your bottom bar
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
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
    // 1. Media Query check for system theme [2026-02-09]
    final isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samskara UI',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        fontFamily: 'Sans-Serif',
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        canvasColor: backgroundColor,
        useMaterial3: true,
        // This ensures the AppBar doesn't flip the icons back to white
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark, 
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          surface: backgroundColor,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      // 2. Wrap the Home logic in an AnnotatedRegion
      // This is the "Force Override" for the Status Bar
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light,    // iOS
        ),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            precacheImage(const AssetImage('assets/Splash.PNG'), context);
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: backgroundColor,
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
              return HomeScreen(initialWisdom: initialWisdom);
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}