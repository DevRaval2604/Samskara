import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; 
import 'login_screen.dart';
import '../widgets/common_widgets.dart'; 
import 'festivelist_screen.dart';
import 'storiesofindia_screen.dart';
import 'askthegita_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'initials_avatar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Wisdom Service ---

class WisdomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDailyWisdom() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return {};

  final prefs = await SharedPreferences.getInstance();
  
  // --- NEW STEP 0: FETCH CLOUD TRUTH FIRST ---
  // We need the cloud data to verify if the phone date is fake/reset
  final userDoc = await _db.collection('Users').doc(user.uid).get();
  final userData = userDoc.data();
  
  // Get phone date
  String today = DateTime.now().toIso8601String().split('T')[0];
  
  // DATE RESET PROTECTION:
  // If phone says it's Feb 1st, but Cloud says user already saw Feb 19th...
  // We force 'today' to be Feb 19th. They can't go backwards.
  if (userData != null && userData['LastWisdomDate'] != null) {
    String lastCloudDate = userData['LastWisdomDate'];
    if (today.compareTo(lastCloudDate) < 0) {
      today = lastCloudDate; 
    }
  }

  // --- STEP 1: LOCAL CACHE CHECK ---
  // Now we check cache using our "verified" today string
  String? cachedShloka = prefs.getString('cached_wisdom_data_${user.uid}');
  String? cachedDate = prefs.getString('cached_wisdom_date_${user.uid}');
  
  if (cachedDate == today && cachedShloka != null) {
    return Map<String, dynamic>.from(jsonDecode(cachedShloka));
  }

  // --- STEP 2: CLOUD SYNC CHECK ---
  // (Logic remains same, but uses our verified 'today')
  if (userData?['LastWisdomDate'] == today && userData?['LastWisdomSource'] != null) {
    final String cloudSource = userData!['LastWisdomSource'];
    
    final poolMatch = await _db.collection('WisdomPool')
        .where('Source', isEqualTo: cloudSource)
        .limit(1)
        .get();

    if (poolMatch.docs.isNotEmpty) {
      final Map<String, dynamic> data = poolMatch.docs.first.data();
      final Map<String, dynamic> localData = Map<String, dynamic>.from(data);
      
      // Clean Timestamps for JSON
      if (localData['CreatedAt'] is Timestamp) {
        localData['CreatedAt'] = (localData['CreatedAt'] as Timestamp).toDate().toIso8601String();
      }
      if (localData['DeleteAt'] is Timestamp) {
        localData['DeleteAt'] = (localData['DeleteAt'] as Timestamp).toDate().toIso8601String();
      }

      await prefs.setString('cached_wisdom_data_${user.uid}', jsonEncode(localData));
      await prefs.setString('cached_wisdom_date_${user.uid}', today);
      
      return data; 
    }
  }

  _performBackgroundCleanup(today);

  // --- STEP 3: THE POOL CHECK ---
  List<dynamic> seenIds = userData?['SeenWisdom'] ?? [];

  if (seenIds.length >= 365) {
    await _db.collection('Users').doc(user.uid).update({'SeenWisdom': []});
    seenIds = [];
  }

  final poolSnapshot = await _db.collection('WisdomPool')
      .orderBy('CreatedAt', descending: true)
      .limit(150)
      .get();
  
  final unseenDocs = poolSnapshot.docs.where((doc) {
    final data = doc.data();
    final source = data['Source'];
    return !seenIds.contains(source);
  }).toList();

  if (unseenDocs.isNotEmpty) {
    unseenDocs.shuffle();
    final selectedDoc = unseenDocs.first;
    final data = selectedDoc.data();
    
    // Clean for cache
    final Map<String, dynamic> localData = Map<String, dynamic>.from(data);
    if (localData['CreatedAt'] is Timestamp) {
      localData['CreatedAt'] = (localData['CreatedAt'] as Timestamp).toDate().toIso8601String();
    }
    if (localData['DeleteAt'] is Timestamp) {
      localData['DeleteAt'] = (localData['DeleteAt'] as Timestamp).toDate().toIso8601String();
    }
    
    return await _finalizeAndCache(user.uid, data['Source'], localData, today, prefs);
  }

  // --- STEP 4: GENERATION ---
  return await _generateNewWisdom(user.uid, today, prefs, seenIds);
}

  void _performBackgroundCleanup(String verifiedToday) {
    // Convert our verified string back to a Timestamp for the query
    DateTime verifiedDate = DateTime.parse(verifiedToday);
    Timestamp verifiedTimestamp = Timestamp.fromDate(verifiedDate);
      _db.collection('WisdomPool')
      .where('DeleteAt', isLessThan: verifiedTimestamp)
      .limit(20) // Clean 20 at a time for high efficiency
      .get()
      .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final batch = _db.batch();
          for (var doc in snapshot.docs) {
            batch.delete(doc.reference);
          }
          // Commit all deletions in ONE single network request
          return batch.commit();
        }
      })
      .catchError((e) => debugPrint("Cleanup failed: $e"));
    }
  // Helper to update History and Local Cache simultaneously
  Future<Map<String, dynamic>> _finalizeAndCache(String uid, String source, Map<String, dynamic> localData, String today, SharedPreferences prefs) async {
    // Update the User document with the "Daily Choice" [2026-02-11] Capitalized
    await _db.collection('Users').doc(uid).update({
      'SeenWisdom': FieldValue.arrayUnion([source]),
      'LastWisdomSource': source,
      'LastWisdomDate': today,
    });

    // Save to Local Cache
    await prefs.setString('cached_wisdom_data_$uid', jsonEncode(localData));
    await prefs.setString('cached_wisdom_date_$uid', today);

    return localData;
  }

  Future<Map<String, dynamic>> _generateNewWisdom(String uid, String today, SharedPreferences prefs, List<dynamic> seenIds) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    
    // 1. Get last 50 entries to tell Gemini what to avoid
    final existingPool = await _db.collection('WisdomPool')
        .orderBy('CreatedAt', descending: true)
        .limit(50)
        .get();
    final List<String> exclusionList = existingPool.docs.map((d) => d['Source'] as String).toList();

    final List<String> modelPriority = ['gemini-3-flash-preview', 'gemini-2.5-flash', 'gemini-2.5-flash-lite'];

    for (int attempt = 0; attempt < 3; attempt++) {
      for (String modelName in modelPriority) {
      try {
        final model = GenerativeModel(model: modelName, apiKey: apiKey);
        
        // --- YOUR ORIGINAL PROMPT LOGIC ---
        final prompt = """
          You are a Master Vedic Sage with access to the entire corpus of Indian Knowledge: 
          1. The 4 Vedas: Rig, Sama, Yajur, and Atharva Veda.
          2. The Mukhya Upanishads (Isha, Kena, Katha, Mundaka, etc.).
          3. The Bhagavad Gita.
          4. The 18 Mahapuranas and all Upapuranas.
          5. Chanakya Neeti (The manual of social wisdom and ethics).
          6. The Arthashastra (The science of statecraft and economics).

          TASK:
          Generate one "Daily Wisdom" entry. You MUST rotate daily across these diverse sources so the user experiences spiritual, social, and leadership wisdom.

          STRICT AVOIDANCE: Do not generate any shloka from these sources:
          ${exclusionList.join(', ')}
          ${seenIds.take(20).join(', ')}

          STRICT FORMATTING RULES:
          1. [REFERENCE]: State the scripture name clearly first. 
             - For Chanakya Neeti: "Chanakya Neeti - Chapter X, Shloka Y"
             - For Arthashastra: "Arthashastra - Book X, Chapter Y"
             - For Puranas: "[Name] Purana - Canto X, Chapter Y"
             - For Vedas: "[Name] Veda - Mandala X, Sukta Y"
             - For Upanishads: "[Name] Upanishad - Adhyay X, Valli Y"
             - For Gita: "Bhagavad Gita - Adhyay X, Shloka Y"
          2. [SHLOK]: The Sanskrit Verse.
          3. [TRANSLATION]: The English Translation.
          4. [PRACTICAL]: Practical, simple modern-day guidance.

          STRICT RULE: Do not use Markdown (no asterisks, no bolding). Return plain text only.
          """;

        final response = await model.generateContent([Content.text(prompt)]);
        final text = response.text;

        if (text != null && text.contains('[SHLOK]')) {
          final source = _extractSection(text, '[REFERENCE]', '[SHLOK]');

          // 1. DUPLICATE CHECK: Ensure user hasn't seen this in the last year
          if (seenIds.contains(source)) {
            debugPrint("Duplicate generated ($source). Retrying...");
            continue;
          }

          // 2. POOL CHECK: Ensure we don't create duplicate entries in the global pool
          final existingDocs = await _db.collection('WisdomPool')
              .where('Source', isEqualTo: source)
              .limit(1)
              .get();

          if (existingDocs.docs.isNotEmpty) {
            // Use existing pool data
            final data = existingDocs.docs.first.data();
            
            // Clean for local cache
            final Map<String, dynamic> localData = Map<String, dynamic>.from(data);
            if (localData['CreatedAt'] is Timestamp) {
              localData['CreatedAt'] = (localData['CreatedAt'] as Timestamp).toDate().toIso8601String();
            }
            if (localData['DeleteAt'] is Timestamp) {
              localData['DeleteAt'] = (localData['DeleteAt'] as Timestamp).toDate().toIso8601String();
            }

            return await _finalizeAndCache(uid, source, localData, today, prefs);
          }

          final now = DateTime.now();
          final expiryDate = now.add(const Duration(days: 730));

          // 1. Data for Firestore (Keep FieldValue here)
          final Map<String, dynamic> poolData = {
            'Source': source,
            'Shloka': _extractSection(text, '[SHLOK]', '[TRANSLATION]'),
            'Meaning': _extractSection(text, '[TRANSLATION]', '[PRACTICAL]'),
            'Explanation': _extractSection(text, '[PRACTICAL]', null),
            'Date': today,
            'CreatedAt': FieldValue.serverTimestamp(),
            'DeleteAt': Timestamp.fromDate(expiryDate),
          };

          // 2. WATERPROOF SAVE: This ensures uniqueness in the database
          await _db.collection('WisdomPool').doc(source).set(poolData);

          // 3. CLEAN COPY for Local Cache (Replace FieldValue with String)
          final Map<String, dynamic> localData = {
            ...poolData,
            'CreatedAt': now.toIso8601String(), // Valid for JSON
            'DeleteAt': expiryDate.toIso8601String(), // Valid for JSON
          };

          return await _finalizeAndCache(uid, source, localData, today, prefs);
        }
      } catch (e) {
        debugPrint("Model $modelName failed: $e");
      }
      }
    }
    return {};
  }

  // --- YOUR ORIGINAL SURGICAL EXTRACTION METHODS (UNCHANGED) ---

  String _extractSection(String text, String startTag, String? endTag) {
    try {
      int start = text.indexOf(startTag);
      if (start == -1) return "";
      start += startTag.length;
      int end = (endTag != null) ? text.indexOf(endTag) : text.length;
      if (end == -1 || end < start) end = text.length;
      String content = text.substring(start, end).trim();
      if (content.startsWith(':')) {
        content = content.substring(1).trim();
      }
      return _sanitizeGeminiOutput(content);
    } catch (e) {
      return "";
    }
  }

  String _sanitizeGeminiOutput(String rawText) {
    return rawText
      .replaceAll(RegExp(r'[#\*_`~]+'), ' ') 
      .replaceAll(RegExp(r'^\s*([\*\-\+]|\d+\.)\s+', multiLine: true), ' ')
      .replaceAll(RegExp(r'^["\u201C]|["\u201D]$'), '')
      .replaceAll(RegExp(r'[\n\r\t]+'), ' ')
      .replaceAll(RegExp(r'\s{2,}'), ' ')
      .trim();
  }
}

// --- HOME SCREEN ---
class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> initialWisdom;
  const HomeScreen({super.key, required this.initialWisdom});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _userName;
  bool _isLoading = true;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  

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
      if (mounted) setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;

    final List<Widget> pages = [
      _HomeTab(isLoading: _isLoading),
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
        title: Text(titles[_selectedIndex], 
          style: TextStyle(color: primaryColor, fontSize: sw * 0.06, fontWeight: FontWeight.bold)),
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
            // SOFT REFRESH: Updates the UI (like InitialsAvatar) 
            // without destroying the whole widget tree.
            if (mounted) {
              setState(() {}); 
            }
            },
            child: Padding(
              padding: EdgeInsets.only(right: sw * 0.04),
              child: InitialsAvatar(
                radius: sw * 0.055, 
                fontSize: sw * 0.045, 
                name: _userName,
              ), 
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
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
        child: TooltipVisibility(
          visible: false,
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: backgroundColor,
            indicatorColor: primaryColor.withValues(alpha: 0.2),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.celebration_outlined), selectedIcon: Icon(Icons.celebration), label: 'Festivals'),
              NavigationDestination(icon: Icon(Icons.auto_stories_outlined), selectedIcon: Icon(Icons.auto_stories), label: 'Stories'),
              NavigationDestination(icon: Icon(Icons.psychology_outlined), selectedIcon: Icon(Icons.psychology), label: 'Gita'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HOME TAB ---
class _HomeTab extends StatefulWidget {
  final bool isLoading;

  const _HomeTab({required this.isLoading});

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> with AutomaticKeepAliveClientMixin{
  Map<String, dynamic>? _wisdomData;
  bool _isWisdomLoading = true;
  bool _isSaved = false;
  StreamSubscription<DocumentSnapshot>? _wisdomSaveSubscription;

  // 2. This keeps the state from being disposed
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchDailyWisdom();
  }

  @override
  void dispose() {
    _wisdomSaveSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchDailyWisdom() async {
    // 1. Get the daily wisdom content
    final data = await WisdomService().getDailyWisdom();
    if (!mounted) return;

    // Cancel any previous subscription.
    await _wisdomSaveSubscription?.cancel();

    bool isSaved = false;
    // 2. If wisdom was found, check its saved status and set up a listener
    if (data.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef = _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('SavedShlokas')
            .doc(data['Source']);

        // Get initial state
        final doc = await docRef.get();
        if (!mounted) return;
        isSaved = doc.exists;

        // Listen for future changes
        _wisdomSaveSubscription = docRef.snapshots().listen((snapshot) {
          if (mounted && _isSaved != snapshot.exists) {
            setState(() {
              _isSaved = snapshot.exists;
            });
          }
        });
      }
    }

    // 3. Update the UI in a single call to prevent flicker
    if (mounted) {
      setState(() {
        _wisdomData = data;
        _isSaved = isSaved;
        _isWisdomLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide previous if any
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: primaryColor)),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: primaryColor, width: 1),
      ),
    ));
  }

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> _toggleSave() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || _wisdomData == null) return;

  // Use 'Source' as the ID to prevent a user from saving the same verse twice
  final docRef = _firestore
      .collection('Users')
      .doc(user.uid)
      .collection('SavedShlokas')
      .doc(_wisdomData!['Source']);

  // Optimistic Update: UI flips immediately for better UX
  setState(() => _isSaved = !_isSaved);

  try {
    if (_isSaved) {
      // 1. Create a clean copy of the wisdom data
      final Map<String, dynamic> dataToSave = Map<String, dynamic>.from(_wisdomData!);

      // 2. Remove pool-specific fields so they don't clutter the user's collection
      dataToSave.remove('DeleteAt');
      dataToSave.remove('CreatedAt');
      dataToSave.remove('Date'); // Optional: keep if you want to know which day's wisdom this was

      // 3. Save with the new permanent timestamp
      await docRef.set({
        ...dataToSave,
        'SavedAt': FieldValue.serverTimestamp(), // [2026-02-11] Capitalized
      });
    } else {
      await docRef.delete();
    }
  } catch (e) {
    // Revert UI if the network fails
    if (mounted) {
      setState(() => _isSaved = !_isSaved);
      _showError("Cloud sync failed. Check your connection.");
    }
  }
}

  @override
  Widget build(BuildContext context) {
    // 3. MANDATORY: You must call super.build
    super.build(context);
    final sw = MediaQuery.sizeOf(context).width;
    final sh = MediaQuery.sizeOf(context).height;

    // Check if everything is loaded
    final bool totalLoading = widget.isLoading || _isWisdomLoading;

    if (totalLoading) {
      return FutureBuilder(
        key: const ValueKey('loading_home_tab'),
        future: Future.delayed(const Duration(milliseconds: 300)),
        builder: (context, snapshot) {
          // Only show the spinner if 200ms have passed AND we are still loading
          if (snapshot.connectionState == ConnectionState.done && totalLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          // Show nothing for the first 199ms to prevent flicker
          return const SizedBox.shrink();
        },
      );
    }

    // Logo and Namaste only show when data is ready
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
        child: Column(
          children: [
            SizedBox(height: sh * 0.02),
            const SamskaraLogo(),
            SizedBox(height: sh * 0.04),

            _buildWisdomCard(sw, sh),
            
            SizedBox(height: sh * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildWisdomCard(double sw, double sh) {
    // Scaling factors for uniformity
    final double cardPadding = sw * 0.05;
    final double internalSpacing = sh * 0.015;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: cardPadding, horizontal: sw * 0.04),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03), // Soft glow background
        borderRadius: BorderRadius.circular(sw * 0.05),
        border: Border.all(color: primaryColor, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // MAIN TITLE & ACTIONS
          Row(
            children: [
              // 1. GHOST WIDGET (Left side)
              // This perfectly balances the width of the icon button on the right
              // so the text stays in the exact middle.
              SizedBox(width: sw * 0.08), 

              // 2. CENTERED TEXT
              Expanded(
                child: Center(
                  child: Text(
                    "DAILY WISDOM",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: sw * 0.030,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // 3. ACTION BUTTONS (Right side)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, 
                  color: primaryColor, 
                  size: sw * 0.055
                ),
                onPressed: _toggleSave, // Using the new toggle save logic
              ),
            ],
          ),
          
          SizedBox(height: internalSpacing),

          // 1. SACRED REFERENCE (The Adhyay/Shlok part)
          _buildInternalBlock("Scripture", _wisdomData?['Source'] ?? '', sw, sh),
          
          // 2. THE SHLOK (Sanskrit)
          _buildInternalBlock("Sacred Shloka", _wisdomData?['Shloka'] ?? '', sw, sh, isSanskrit: true, isItalic: true),

          // 3. THE MEANING (English)
          _buildInternalBlock("Translation", _wisdomData?['Meaning'] ?? '', sw, sh),

          // 4. MODERN RELEVANCE (Practical)
          _buildInternalBlock("Modern Relevance", _wisdomData?['Explanation'] ?? '', sw, sh, isJustified: true),
        ],
      ),
    );
  }

  // --- REUSABLE INTERNAL BLOCK (The "Separated Card" look) ---
  Widget _buildInternalBlock(String title, String content, double sw, double sh, 
      {bool isSanskrit = false, bool isItalic = false, bool isJustified = false}) {
    
    return Padding(
      padding: EdgeInsets.only(bottom: sh * 0.012), // Reduced spacing for compactness
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(sw * 0.035), // Uniform internal padding
        decoration: BoxDecoration(
          color: backgroundColor, 
          borderRadius: BorderRadius.circular(sw * 0.05),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Column(
          children: [
            Text(title.toUpperCase(), 
              style: TextStyle(
                color: primaryColor, 
                fontWeight: FontWeight.bold, 
                fontSize: sw * 0.030, // Smaller, uniform title
                letterSpacing: 1.0
              )),
            SizedBox(height: sh * 0.006),
            Text(
              content,
              textAlign: isJustified ? TextAlign.justify : TextAlign.center,
              style: TextStyle(
                color: primaryColor, // Everything must be primaryColor
                fontSize: sw * 0.036, // Uniform sizing to prevent "too large" issue
                fontFamily: 'Serif',
                fontStyle: isItalic || isSanskrit ? FontStyle.italic : FontStyle.normal,
                fontWeight: FontWeight.normal,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}