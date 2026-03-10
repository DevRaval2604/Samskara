import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/festivalscript.dart';
import 'utils/storiesscript.dart';
import 'widgets/common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: backgroundColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found. Ensure it is in root and added to pubspec.yaml assets.");
  }
  await Firebase.initializeApp();
  await populateEncylopeadicFestivals();
  await uploadStories();
  final wisdomService = WisdomService();
  final initialWisdom = await wisdomService.getDailyWisdom();
  Future.microtask(() => wisdomService.preGenerateTomorrowsWisdom());
  runApp(MyApp(initialWisdom: initialWisdom));
}

const Color primaryColor = Color(0xFF6B3C3A);
const Color backgroundColor = Color(0xFFF8F4E9);

class MyApp extends StatefulWidget {
  final Map<String, dynamic> initialWisdom;
  const MyApp({super.key, required this.initialWisdom});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      precacheImage(const AssetImage('assets/google_logo.png'), context);
      precacheImage(const AssetImage('assets/Splash.PNG'), context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark, 
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          surface: backgroundColor,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            precacheImage(const AssetImage('assets/Splash.PNG'), context);
            precacheImage(const AssetImage('assets/google_logo.png'), context);
            
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
              return HomeScreen(initialWisdom: widget.initialWisdom);
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}