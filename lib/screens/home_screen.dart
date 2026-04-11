import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:crypto/crypto.dart';
import 'login_screen.dart';
import '../widgets/common_widgets.dart';
import 'festivelist_screen.dart';
import 'storiesofindia_screen.dart';
import 'askthegita_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import '../utils/initials_avatar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Wisdom Service ---
class WisdomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  String _shlokaFingerprint(String shloka) {
    final cleaned = shloka
        .toLowerCase()
        .replaceAll(RegExp(r'\p{M}', unicode: true), '')
        .replaceAll(RegExp(r'[|॥।\s]+'), '')
        .replaceAll(RegExp(r'[^\u0900-\u097Fa-z0-9]'), '');
    final bytes = utf8.encode(cleaned);  
    return sha256.convert(bytes).toString();
  }

  Future<bool> _isUniqueCandidate(String source, String fingerprint) async {
    // 1. Exact source match
    final sourceMatch = await _db
        .collection('WisdomPool')
        .where('Source', isEqualTo: source)
        .limit(1)
        .get();
    if (sourceMatch.docs.isNotEmpty) {
      debugPrint('[Dedup] Source already in pool: $source');
      return false;
    }

    // 2. Normalised source match (catches "Adhyaya" vs "Chapter" etc.)
    final allSources = await _db
        .collection('WisdomPool')
        .orderBy('CreatedAt', descending: true)
        .limit(500)           // large enough to cover 1+ year of daily entries
        .get();
    final normSource = _normalizeSource(source);
    final sourceCollision = allSources.docs.any(
        (doc) => _normalizeSource(doc['Source'] as String) == normSource);
    if (sourceCollision) {
      debugPrint('[Dedup] Normalised source collision: $source');
      return false;
    }

    // 3. Shloka content fingerprint match — catches same verse / wrong numbers
    if (fingerprint.isNotEmpty) {
      final fpMatch = await _db
          .collection('WisdomPool')
          .where('ShlokaHash', isEqualTo: fingerprint)
          .limit(1)
          .get();
      if (fpMatch.docs.isNotEmpty) {
        debugPrint('[Dedup] ShlokaHash collision — same verse, different ref: $source');
        return false;
      }
    }

    return true;
  }

  Future<Map<String, dynamic>> getDailyWisdom() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final prefs = await SharedPreferences.getInstance();

    // --- STEP 0A: FETCH CLOUD TRUTH FIRST ---
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

    // --- STEP 0B: PRE-GENERATED CACHE CHECK ---
    final preKey = 'cached_wisdom_pre_${user.uid}_$today';
    final preGenerated = prefs.getString(preKey);
    if (preGenerated != null) {
      final data = Map<String, dynamic>.from(jsonDecode(preGenerated));
      final source = data['Source'] as String;
      final fingerprint = _shlokaFingerprint(data['Shloka'] as String? ?? '');

      // Check if already in pool by exact source
      final existingDoc = await _db
          .collection('WisdomPool')
          .where('Source', isEqualTo: source)
          .limit(1)
          .get();

      if (existingDoc.docs.isEmpty) {
        // HARDENED: Also check ShlokaHash before promoting to pool.
        // Pre-cache was generated yesterday — by today the pool may already
        // contain the same verse under a different (hallucinated) reference.
        final fpMatch = await _db
            .collection('WisdomPool')
            .where('ShlokaHash', isEqualTo: fingerprint)
            .limit(1)
            .get();

        if (fpMatch.docs.isNotEmpty) {
          // Same shloka already in pool — discard pre-cache and fall through
          // to Steps 1-4 which will pick a genuinely fresh entry.
          debugPrint('[PreCache] ShlokaHash collision on promotion — discarding pre-cache.');
          await prefs.remove(preKey);
          // fall through — do NOT return here
        } else {
          // Safe to promote — write to pool with fingerprint
          final now = DateTime.now();
          final expiryDate = now.add(const Duration(days: 730));
          final Map<String, dynamic> poolData = {
            'Source': source,
            'Shloka': data['Shloka'],
            'ShlokaHash': fingerprint,   // ← content fingerprint stored
            'Meaning': data['Meaning'],
            'Explanation': data['Explanation'],
            'Date': today,
            'CreatedAt': FieldValue.serverTimestamp(),
            'DeleteAt': Timestamp.fromDate(expiryDate),
          };
          // FIX (Bug 4): Write FIRST, remove cache only after write succeeds.
          await _db.collection('WisdomPool').doc(source).set(poolData);
          await prefs.remove(preKey);

          data['CreatedAt'] = now.toIso8601String();
          data['DeleteAt'] = expiryDate.toIso8601String();
          return await _finalizeAndCache(user.uid, source, data, today, prefs);
        }
      } else {
        // Already in pool — use existing data
        await prefs.remove(preKey);
        final existingData = existingDoc.docs.first.data();
        if (existingData['CreatedAt'] is Timestamp) {
          data['CreatedAt'] =
              (existingData['CreatedAt'] as Timestamp).toDate().toIso8601String();
        }
        if (existingData['DeleteAt'] is Timestamp) {
          data['DeleteAt'] =
              (existingData['DeleteAt'] as Timestamp).toDate().toIso8601String();
        }
        return await _finalizeAndCache(user.uid, source, data, today, prefs);
      }
    }

    // --- STEP 1: LOCAL CACHE CHECK ---
    // Now we check cache using our "verified" today string
    String? cachedShloka = prefs.getString('cached_wisdom_data_${user.uid}');
    String? cachedDate = prefs.getString('cached_wisdom_date_${user.uid}');

    if (cachedDate == today && cachedShloka != null) {
      final data = Map<String, dynamic>.from(jsonDecode(cachedShloka));
      final savedCheck = await _db
          .collection('Users')
          .doc(user.uid)
          .collection('SavedShlokas')
          .doc(data['Source'])
          .get();
      return {
        ...data,
        'isInitiallySaved': savedCheck.exists,
      };
    }

    // --- STEP 2: CLOUD SYNC CHECK ---
    if (userData?['LastWisdomDate'] == today &&
        userData?['LastWisdomSource'] != null) {
      final String cloudSource = userData!['LastWisdomSource'];

      final poolMatch = await _db
          .collection('WisdomPool')
          .where('Source', isEqualTo: cloudSource)
          .limit(1)
          .get();

      if (poolMatch.docs.isNotEmpty) {
        final Map<String, dynamic> data = poolMatch.docs.first.data();
        final Map<String, dynamic> localData = Map<String, dynamic>.from(data);

        // Clean Timestamps for JSON
        if (localData['CreatedAt'] is Timestamp) {
          localData['CreatedAt'] =
              (localData['CreatedAt'] as Timestamp).toDate().toIso8601String();
        }
        if (localData['DeleteAt'] is Timestamp) {
          localData['DeleteAt'] =
              (localData['DeleteAt'] as Timestamp).toDate().toIso8601String();
        }

        await prefs.setString(
            'cached_wisdom_data_${user.uid}', jsonEncode(localData));
        await prefs.setString('cached_wisdom_date_${user.uid}', today);

        final savedCheck = await _db
            .collection('Users')
            .doc(user.uid)
            .collection('SavedShlokas')
            .doc(data['Source'])
            .get();
        return {
          ...data,
          'isInitiallySaved': savedCheck.exists,
        };
      }
    }

    // Background cleanup — runs without blocking shloka retrieval
    Future.microtask(() => _performBackgroundCleanup(today));

    // --- STEP 3: THE POOL CHECK ---
    List<dynamic> seenIds = userData?['SeenWisdom'] ?? [];

    if (seenIds.length >= 365) {
      await _db
          .collection('Users')
          .doc(user.uid)
          .update({'SeenWisdom': []});
      seenIds = [];
    }

    final poolSnapshot = await _db
        .collection('WisdomPool')
        .orderBy('CreatedAt', descending: true)
        .limit(500)  // covers full 1+ year of daily entries
        .get();

    final unseenDocs = poolSnapshot.docs.where((doc) {
      final data = doc.data();
      final source = data['Source'];
      final Timestamp? deleteAt = data['DeleteAt'] as Timestamp?;
      final bool isExpired =
          deleteAt != null && deleteAt.toDate().isBefore(DateTime.now());
      return !seenIds.contains(source) && !isExpired;
    }).toList();

    if (unseenDocs.isNotEmpty) {
      unseenDocs.shuffle();
      final selectedDoc = unseenDocs.first;
      final data = selectedDoc.data();

      final Map<String, dynamic> localData = Map<String, dynamic>.from(data);
      if (localData['CreatedAt'] is Timestamp) {
        localData['CreatedAt'] =
            (localData['CreatedAt'] as Timestamp).toDate().toIso8601String();
      }
      if (localData['DeleteAt'] is Timestamp) {
        localData['DeleteAt'] =
            (localData['DeleteAt'] as Timestamp).toDate().toIso8601String();
      }

      return await _finalizeAndCache(
          user.uid, data['Source'], localData, today, prefs);
    }

    // --- STEP 4: GENERATION ---
    return await _generateNewWisdom(user.uid, today, prefs, seenIds) ?? {};
  }

  Future<void> preGenerateTomorrowsWisdom() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final tomorrow = DateTime.now()
        .add(const Duration(days: 1))
        .toIso8601String()
        .split('T')[0];

    // Already pre-generated? Do nothing.
    final existingCache =
        prefs.getString('cached_wisdom_pre_${user.uid}_$tomorrow');
    if (existingCache != null) return;

    try {
      final userDoc = await _db.collection('Users').doc(user.uid).get();
      final userData = userDoc.data();
      List<dynamic> seenIds = userData?['SeenWisdom'] ?? [];
      if (seenIds.length >= 365) seenIds = [];

      // Check pool first — no AI needed if pool has unseen entries
      final poolSnapshot = await _db
          .collection('WisdomPool')
          .orderBy('CreatedAt', descending: true)
          .limit(500)  // covers full 1+ year of daily entries
          .get();

      final unseenDocs = poolSnapshot.docs.where((doc) {
        final data = doc.data();
        final Timestamp? deleteAt = data['DeleteAt'] as Timestamp?;
        final bool isExpired =
            deleteAt != null && deleteAt.toDate().isBefore(DateTime.now());
        return !seenIds.contains(data['Source']) && !isExpired;
      }).toList();

      Map<String, dynamic>? tomorrowData;

      if (unseenDocs.isNotEmpty) {
        unseenDocs.shuffle();
        final data = unseenDocs.first.data();
        final localData = Map<String, dynamic>.from(data);
        if (localData['CreatedAt'] is Timestamp) {
          localData['CreatedAt'] = (localData['CreatedAt'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        if (localData['DeleteAt'] is Timestamp) {
          localData['DeleteAt'] = (localData['DeleteAt'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        tomorrowData = localData;
      } else {
        // Pool exhausted for this user — generate fresh with AI.
        // Re-use the poolSnapshot already fetched above (no extra Firestore read).
        final List<String> exclusionList =
            poolSnapshot.docs.map((d) => d['Source'] as String).toList();
        tomorrowData = await _generateTomorrowLocally(
            user.uid, tomorrow, prefs, seenIds,
            exclusionList: exclusionList);
      }

      if (tomorrowData != null) {
        await prefs.setString(
          'cached_wisdom_pre_${user.uid}_$tomorrow',
          jsonEncode(tomorrowData),
        );
      }
    } catch (e) {
      debugPrint("Pre-generation failed silently: $e");
    }
  }

  // --- SHARED PROMPT BUILDER ---
  // Single source of truth for the prompt used in both generation functions.
  // exclusionList  — source reference strings already in the pool
  // shlokaHints    — human-readable verse hints derived from stored shlokas,
  //                  giving the AI a second layer of avoidance independent of
  //                  reference numbers (guards against hallucinated refs).
  String _buildWisdomPrompt(List<String> exclusionList,
      {List<String> shlokaHints = const []}) {
    final avoidanceBlock = shlokaHints.isEmpty
        ? ''
        : '''
          ADDITIONAL SHLOKA AVOIDANCE (these exact verses must NOT be repeated,
          regardless of how you number their reference):
          ${shlokaHints.join('\n          ')}
        ''';
    return """
          You are a Master Vedic Sage with access to the entire corpus of Indian Knowledge:
          1. The 4 Vedas: Rig, Sama, Yajur, and Atharva Veda.
          2. The 108 Upanishads (Including Mukhya Upanishads and all Mahaupanishads).
          3. The Bhagavad Gita.
          4. The 18 Mahapuranas and all Upapuranas.
          5. Chanakya Neeti (The manual of social wisdom and ethics).
          6. The Arthashastra (The science of statecraft and economics).

          STRICT AVOIDANCE:
          The following references have already been shown to the user. You MUST NOT repeat any of them under any circumstance:
          $exclusionList
          $avoidanceBlock

          TODAY'S SOURCE SELECTION (SILENT — NEVER PRINT THIS):
          Before selecting a verse, first silently choose which scripture to draw from today.
          You have access to this entire corpus:
          1. The 4 Vedas: Rig, Sama, Yajur, and Atharva Veda — including all Mandalas, Suktas, Kandas, Archikas, Prapathakas, Anuvakas, and every subdivision thereof.
          2. The Upanishads — including all 108 canonical, Mukhya, Mahaupanishads, and lesser-known Upanishads.
          3. The Bhagavad Gita — all 18 Adhyayas.
          4. The 18 Mahapuranas and all Upapuranas — including all major, minor, and rarely cited Puranic texts.
          5. Chanakya Neeti — all chapters.
          6. The Arthashastra — all books.

          ROTATION MANDATE: You MUST actively rotate across these categories to ensure the user receives diverse wisdom over time — spiritual, philosophical, ethical, social, and leadership wisdom in turns. Do NOT default to the Bhagavad Gita or any single popular scripture repeatedly. Treat the entire corpus as equally valid and equally important. Actively choose lesser-known scriptures and verses that carry profound wisdom but are rarely surfaced. The more diverse and unexpected the selection, the better the user's experience.

          SELECTION RULE: After silently choosing the scripture, proceed to the Internal Verse Selection Process below using that chosen scripture as the source for today.

          INTERNAL VERSE SELECTION PROCESS (SILENT — NEVER PRINT ANY PART OF THIS):
          Before writing a single word of your response, complete the following steps entirely in silence:

          Stage 1: Identify 3 candidate verses from today's chosen scripture that are complete, meaningful, and uplifting as standalone wisdom.
          Stage 2: For each candidate, answer these four questions internally:
            Question A: Do I know the exact reference numbers for this verse with full certainty? (Yes / No)
            Question B: Is this the complete verse with no missing lines — reproducible in full? (Yes / No)
            Question C: Is this reference absent from the exclusion list above? (Yes / No)
            Question D: Is this verse from the authenticated, traditionally recognised core text — not disputed, not misattributed, not of uncertain origin? (Yes / No)
          A candidate PASSES only if all four answers are Yes.
          Discard any candidate that fails even one question.
          Stage 3: From passing candidates, select the one with the most universally inspiring and practical wisdom.
          If zero candidates pass, choose a different scripture and repeat from Stage 1.
          You MUST NOT write your response until exactly one candidate has passed all four questions.

          Now write your response using EXACTLY the following format.
          All four tags are mandatory. No tag may be empty. No tag may be skipped. No extra tags may be added.

          [REFERENCE]

          Rules for [REFERENCE]:
          The only content after [REFERENCE] must be the reference itself — nothing else.
          No sub-labels. No "Scripture:". No "Source:". No "Chapter:". No descriptors of any kind.
          Use only Arabic numerals. Never use words or Roman numerals for numbers.
          If a subdivision does not exist in the traditional structure of the source, omit it entirely. Never guess. Never use placeholders.
          Use these exact formats and no others:
            Rig Veda — Mandala [number], Sukta [number], Mantra [number]
            Sama Veda — Purvarchika [number], Prapathaka [number], Verse [number] or Uttararchika [number], Prapathaka [number], Verse [number]
            Yajur Veda — [Adhyaya/Prapathaka] [number], Mantra [number]
            Atharva Veda — Kanda [number], Sukta [number], Mantra [number]
            [Name] Upanishad — [Division] [number], [Subdivision] [number], [Mantra/Shloka/Karika] [number]
            Bhagavad Gita — Adhyaya [number], Shloka [number]
            [Name] Purana — [Division] [number], [Subdivision] [number], Adhyaya [number], Shloka [number]
            Chanakya Neeti — Chapter [number], Shloka [number]
            Arthashastra — Book [number], Chapter [number], Verse [number]

          For every scripture, use only the exact traditional subdivision names specific to that text (e.g. Adhyaya, Valli, Khanda, Prapathaka, Skanda, Amsha, Bhaga). Apply the omit rule at every level — if a subdivision does not exist or you are uncertain, omit it entirely.

          [SHLOK]

          Rules for [SHLOK]:
          The only content after [SHLOK] must be the bare Sanskrit verse itself.
          No sub-labels. No "Sanskrit Verse:". No "Original:". No "Verse:". No descriptors of any kind.
          The verse must be complete and untruncated — every line, from beginning to end.
          Never cut a verse mid-line. Never summarize or shorten it.
          If a verse is too long to reproduce fully, it failed Question B in Stage 2 — discard it and select another.

          [TRANSLATION]

          Rules for [TRANSLATION]:
          The only content after [TRANSLATION] must be the bare English translation itself.
          No sub-labels. No "English Translation:". No "Meaning:". No "Translation:". No descriptors of any kind.
          Do not wrap the translation in quotation marks.
          The translation must be accurate, clear, and complete.

          [PRACTICAL]

          Rules for [PRACTICAL]:
          Write the content as one continuous, flowing paragraph of pure modern-day guidance inspired by the verse.
          No labels. No numbers. No headers. No "Firstly", "Secondly", "Finally". No structural markers of any kind.
          Speak directly and practically — as if a wise sage is telling a modern person exactly how to apply this ancient wisdom in today's world.
          Keep it grounded, simple, and actionable. No abstract philosophy. No vague spirituality.
          The entire section must read as seamless, flowing wisdom — not a list, not a structured breakdown.

          ABSOLUTE RULES — APPLY TO ALL OUTPUTS AT ALL TIMES:
          NEVER print any part of the internal verse selection process or the source selection process.
          NEVER print which scripture was chosen today.
          NEVER repeat a reference from the exclusion list.
          NEVER leave any tag empty, blank, or with placeholder text.
          NEVER use the literal text "[number]" or "[Number]" — always use actual digits.
          NEVER use Markdown anywhere — no asterisks, no bolding, no italics, no headers, no bullet dashes.
          NEVER add sub-labels, descriptors, or headings inside any tag.
          NEVER output a partial or truncated verse under any circumstance.
          NEVER wrap the translation in quotation marks.
          NEVER add extra tags beyond [REFERENCE], [SHLOK], [TRANSLATION], [PRACTICAL].
          NEVER default repeatedly to the Bhagavad Gita or any single popular scripture.
          NEVER select a verse whose authenticity or attribution is disputed, uncertain, or not found in the traditionally authenticated core text.
          ALWAYS prioritize diversity — rotate across the full corpus with every generation.
          ALWAYS maintain a tone that is wise, warm, and universally accessible.
          """;
      }

  Future<Map<String, dynamic>?> _generateTomorrowLocally(
      String uid,
      String tomorrow,
      SharedPreferences prefs,
      List<dynamic> seenIds,
      {List<String>? exclusionList}) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // Build exclusion list from pool if not provided
    final poolSnapshot = await _db
        .collection('WisdomPool')
        .orderBy('CreatedAt', descending: true)
        .limit(500)
        .get();

    final List<String> finalExclusionList = exclusionList ??
        poolSnapshot.docs.map((d) => d['Source'] as String).toList();

    // LAYER 2 — collect first-line shloka hints to pass to the AI.
    // Even if the AI ignores reference numbers, seeing the opening Sanskrit
    // words of already-used verses gives it a second signal to avoid them.
    final List<String> shlokaHints = poolSnapshot.docs
        .map((d) {
          final raw = (d.data()['Shloka'] as String? ?? '').trim();
          // Send only the first ~60 chars — enough to identify the verse
          return raw.length > 60 ? raw.substring(0, 60) : raw;
        })
        .where((s) => s.isNotEmpty)
        .toList();

    // Pre-fetch saved shlokas ONCE (Bug 2 fix)
    final savedSnapshot =
        await _db.collection('Users').doc(uid).collection('SavedShlokas').get();
    final Set<String> savedNormalized =
        savedSnapshot.docs.map((doc) => _normalizeSource(doc.id)).toSet();

    // Build all normalized sources & fingerprints already in pool for fast
    // in-memory checks — avoids repeated Firestore reads inside the loop.
    final Set<String> poolNormSources = poolSnapshot.docs
        .map((d) => _normalizeSource(d['Source'] as String))
        .toSet();
    final Set<String> poolFingerprints = poolSnapshot.docs
        .map((d) => (d.data()['ShlokaHash'] as String? ?? ''))
        .where((h) => h.isNotEmpty)
        .toSet();

    final List<String> modelPriority = [
      'gemini-3-flash-preview',
      'gemini-2.5-flash',
      'gemini-2.5-flash-lite',
    ];

    final String prompt = _buildWisdomPrompt(
      finalExclusionList,
      shlokaHints: shlokaHints,
    );

    for (int attempt = 0; attempt < 3; attempt++) {
      for (String modelName in modelPriority) {
        try {
          final model = GenerativeModel(model: modelName, apiKey: apiKey);
          final response = await model.generateContent([Content.text(prompt)]);
          final text = response.text;

          if (text == null || !text.contains('[SHLOK]')) continue;

          final source = _extractSection(text, '[REFERENCE]', '[SHLOK]');
          final shlokaText = _extractSection(text, '[SHLOK]', '[TRANSLATION]');
          final fingerprint = _shlokaFingerprint(shlokaText);

          // Gate 1: Must contain digits
          if (!RegExp(r'\d').hasMatch(source)) {
            debugPrint('[Gen-Tomorrow] No digits in reference. Retrying...');
            continue;
          }

          // Gate 2: In-memory exclusion list check (fast, no Firestore read)
          if (finalExclusionList
              .map(_normalizeSource)
              .contains(_normalizeSource(source))) {
            debugPrint('[Gen-Tomorrow] In exclusion list. Retrying...');
            continue;
          }

          // Gate 3: In-memory normalised source collision
          if (poolNormSources.contains(_normalizeSource(source))) {
            debugPrint('[Gen-Tomorrow] Normalised source collision. Retrying...');
            continue;
          }

          // Gate 4: In-memory fingerprint collision — same shloka / wrong ref
          if (fingerprint.isNotEmpty && poolFingerprints.contains(fingerprint)) {
            debugPrint('[Gen-Tomorrow] ShlokaHash collision in-memory. Retrying...');
            continue;
          }

          // Gate 5: Saved by user
          if (savedNormalized.contains(_normalizeSource(source))) {
            debugPrint('[Gen-Tomorrow] Already saved by user. Retrying...');
            continue;
          }

          // Gate 6: Already in SeenWisdom
          if (seenIds
              .map((id) => _normalizeSource(id.toString()))
              .contains(_normalizeSource(source))) {
            debugPrint('[Gen-Tomorrow] In SeenWisdom. Retrying...');
            continue;
          }

          // Gate 7: Authoritative Firestore double-check (source + fingerprint)
          final isUnique = await _isUniqueCandidate(source, fingerprint);
          if (!isUnique) {
            debugPrint('[Gen-Tomorrow] Firestore uniqueness check failed. Retrying...');
            continue;
          }

          // All gates passed — build local data (NOT written to pool yet;
          // that happens at promotion time in getDailyWisdom Step 0B).
          final now = DateTime.now();
          final expiryDate = now.add(const Duration(days: 730));

          return {
            'Source': source,
            'Shloka': shlokaText,
            'ShlokaHash': fingerprint,
            'Meaning': _extractSection(text, '[TRANSLATION]', '[PRACTICAL]'),
            'Explanation': _extractSection(text, '[PRACTICAL]', null),
            'Date': tomorrow,
            'CreatedAt': now.toIso8601String(),
            'DeleteAt': expiryDate.toIso8601String(),
          };
        } catch (e) {
          debugPrint('[Gen-Tomorrow] Model $modelName failed: $e');
        }
      }
    }
    return null;
  }

  void _performBackgroundCleanup(String verifiedToday) {
    final Timestamp actualNow = Timestamp.now();
    _db
        .collection('WisdomPool')
        .where('DeleteAt', isLessThan: actualNow)
        .limit(450)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final batch = _db.batch();
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        return batch.commit();
      }
    }).catchError((e) => debugPrint("Cleanup failed: $e"));
  }

  Future<Map<String, dynamic>> _finalizeAndCache(String uid, String source,
      Map<String, dynamic> localData, String today, SharedPreferences prefs) async {
    await _db.collection('Users').doc(uid).update({
      'SeenWisdom': FieldValue.arrayUnion([source]),
      'LastWisdomSource': source,
      'LastWisdomDate': today,
    });

    await prefs.setString('cached_wisdom_data_$uid', jsonEncode(localData));
    await prefs.setString('cached_wisdom_date_$uid', today);

    final savedCheck = await _db
        .collection('Users')
        .doc(uid)
        .collection('SavedShlokas')
        .doc(source)
        .get();
    return {
      ...localData,
      'isInitiallySaved': savedCheck.exists,
    };
  }

  String _normalizeSource(String source) {
    final scriptureKey = _extractScriptureKey(source);
    final numbers = RegExp(r'\d+')
        .allMatches(source)
        .map((m) => m.group(0)!)
        .join('_');
    return '${scriptureKey}_$numbers';
  }

  String _extractScriptureKey(String source) {
    final s = source
        .toLowerCase()
        .replaceAll(RegExp(r'[,\.\-—–:;]+'), ' ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();

    if (s.contains('rig veda') ||
        s.contains('rigveda') ||
        s.contains('ṛgveda')) {
      return 'rigveda';
    }
    if (s.contains('sama veda') ||
        s.contains('samaveda') ||
        s.contains('sāmaveda')) {
      return 'samaveda';
    }
    if (s.contains('yajur veda') ||
        s.contains('yajurveda') ||
        s.contains('yajur')) {
      return 'yajurveda';
    }
    if (s.contains('atharva veda') ||
        s.contains('atharvaveda') ||
        s.contains('atharva')) {
      return 'atharvaveda';
    }
    if (s.contains('bhagavad gita') ||
        s.contains('bhagavadgita') ||
        s.contains('bhagwad gita') ||
        s.contains('gita')) {
      return 'gita';
    }
    if (s.contains('chanakya') ||
        s.contains('chankya') ||
        s.contains('chanakyaniti')) {
      return 'chanakya';
    }
    if (s.contains('arthashastra') ||
        s.contains('artha shastra') ||
        s.contains('arthshastra') ||
        s.contains('arthasastra')) {
      return 'arthashastra';
    }

    if (s.contains('upanishad') ||
        s.contains('upanisad') ||
        s.contains('upnishad') ||
        s.contains('upanishat')) {
      final match =
          RegExp(r'(\w+)\s+upanisha?[dt]?', caseSensitive: false).firstMatch(s);
      String name = match?.group(1) ?? 'unknown';
      name = name
          .replaceAll(RegExp(r'sh'), 's')
          .replaceAll(RegExp(r'aa'), 'a')
          .replaceAll(RegExp(r'ii'), 'i')
          .replaceAll(RegExp(r'uu'), 'u')
          .replaceAll(RegExp(r'th'), 't')
          .replaceAll(RegExp(r'ph'), 'p')
          .replaceAll('v', 'w')
          .replaceAll('ā', 'a')
          .replaceAll('ī', 'i')
          .replaceAll('ū', 'u')
          .replaceAll('ṛ', 'r')
          .replaceAll('ṭ', 't')
          .replaceAll('ḍ', 'd')
          .replaceAll('ṇ', 'n')
          .replaceAll('ṅ', 'n')
          .replaceAll('ñ', 'n')
          .replaceAll('ś', 's')
          .replaceAll('ṣ', 's');
      return 'upanishad_$name';
    }

    if (s.contains('purana') ||
        s.contains('puranam') ||
        s.contains('puraan') ||
        s.contains('puran')) {
      final match =
          RegExp(r'(\w+)\s+purana?m?', caseSensitive: false).firstMatch(s);
      String name = match?.group(1) ?? 'unknown';
      name = name
          .replaceAll('ā', 'a')
          .replaceAll('ī', 'i')
          .replaceAll('ū', 'u')
          .replaceAll('ṛ', 'r')
          .replaceAll('ś', 's')
          .replaceAll('ṣ', 's')
          .replaceAll('ṇ', 'n');
      return 'purana_$name';
    }

    final words =
        s.split(' ').where((w) => w.length > 2).take(2).join('_');
    return words.isEmpty ? 'unknown' : words;
  }

  Future<Map<String, dynamic>?> _generateNewWisdom(
      String uid,
      String today,
      SharedPreferences prefs,
      List<dynamic> seenIds,
      {List<String>? exclusionList}) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // Fetch the full pool once — used for exclusion list, hints, and
    // in-memory collision sets (avoids repeated Firestore reads in the loop).
    final poolSnapshot = await _db
        .collection('WisdomPool')
        .orderBy('CreatedAt', descending: true)
        .limit(500)
        .get();

    final List<String> finalExclusionList = exclusionList ??
        poolSnapshot.docs.map((d) => d['Source'] as String).toList();

    // LAYER 2 — first-line shloka hints sent to AI
    final List<String> shlokaHints = poolSnapshot.docs
        .map((d) {
          final raw = (d.data()['Shloka'] as String? ?? '').trim();
          return raw.length > 60 ? raw.substring(0, 60) : raw;
        })
        .where((s) => s.isNotEmpty)
        .toList();

    // Pre-fetch saved shlokas ONCE (Bug 2 fix)
    final savedSnapshot =
        await _db.collection('Users').doc(uid).collection('SavedShlokas').get();
    final Set<String> savedNormalized =
        savedSnapshot.docs.map((doc) => _normalizeSource(doc.id)).toSet();

    // In-memory collision sets for fast loop checks
    final Set<String> poolNormSources = poolSnapshot.docs
        .map((d) => _normalizeSource(d['Source'] as String))
        .toSet();
    final Set<String> poolFingerprints = poolSnapshot.docs
        .map((d) => (d.data()['ShlokaHash'] as String? ?? ''))
        .where((h) => h.isNotEmpty)
        .toSet();

    final List<String> modelPriority = [
      'gemini-3-flash-preview',
      'gemini-2.5-flash',
      'gemini-2.5-flash-lite',
    ];

    final String prompt = _buildWisdomPrompt(
      finalExclusionList,
      shlokaHints: shlokaHints,
    );

    for (int attempt = 0; attempt < 3; attempt++) {
      for (String modelName in modelPriority) {
        try {
          final model = GenerativeModel(model: modelName, apiKey: apiKey);
          final response = await model.generateContent([Content.text(prompt)]);
          final text = response.text;

          if (text == null || !text.contains('[SHLOK]')) continue;

          final source = _extractSection(text, '[REFERENCE]', '[SHLOK]');
          final shlokaText = _extractSection(text, '[SHLOK]', '[TRANSLATION]');
          final fingerprint = _shlokaFingerprint(shlokaText);

          // Gate 1: Must contain digits
          if (!RegExp(r'\d').hasMatch(source)) {
            debugPrint('[Gen-New] No digits in reference. Retrying...');
            continue;
          }

          // Gate 2: Exclusion list
          if (finalExclusionList
              .map(_normalizeSource)
              .contains(_normalizeSource(source))) {
            debugPrint('[Gen-New] In exclusion list. Retrying...');
            continue;
          }

          // Gate 3: In-memory normalised source collision
          if (poolNormSources.contains(_normalizeSource(source))) {
            debugPrint('[Gen-New] Normalised source collision. Retrying...');
            continue;
          }

          // Gate 4: In-memory fingerprint collision
          if (fingerprint.isNotEmpty && poolFingerprints.contains(fingerprint)) {
            debugPrint('[Gen-New] ShlokaHash collision in-memory. Retrying...');
            continue;
          }

          // Gate 5: Saved by user
          if (savedNormalized.contains(_normalizeSource(source))) {
            debugPrint('[Gen-New] Already saved by user. Retrying...');
            continue;
          }

          // Gate 6: SeenWisdom
          if (seenIds
              .map((id) => _normalizeSource(id.toString()))
              .contains(_normalizeSource(source))) {
            debugPrint('[Gen-New] In SeenWisdom. Retrying...');
            continue;
          }

          // Gate 7: Authoritative Firestore uniqueness check
          final isUnique = await _isUniqueCandidate(source, fingerprint);
          if (!isUnique) {
            debugPrint('[Gen-New] Firestore uniqueness check failed. Retrying...');
            continue;
          }

          // All gates passed — write to pool and return
          final now = DateTime.now();
          final expiryDate = now.add(const Duration(days: 730));

          final Map<String, dynamic> poolData = {
            'Source': source,
            'Shloka': shlokaText,
            'ShlokaHash': fingerprint,
            'Meaning': _extractSection(text, '[TRANSLATION]', '[PRACTICAL]'),
            'Explanation': _extractSection(text, '[PRACTICAL]', null),
            'Date': today,
            'CreatedAt': FieldValue.serverTimestamp(),
            'DeleteAt': Timestamp.fromDate(expiryDate),
          };

          await _db.collection('WisdomPool').doc(source).set(poolData);

          final Map<String, dynamic> localData = {
            ...poolData,
            'CreatedAt': now.toIso8601String(),
            'DeleteAt': expiryDate.toIso8601String(),
          };

          return await _finalizeAndCache(uid, source, localData, today, prefs);
        } catch (e) {
          debugPrint('[Gen-New] Model $modelName failed: $e');
        }
      }
    }
    return null;
  }

  // --- EXTRACTION ENGINE ---
  // FIX (⚠️ endTag indexOf): Both start and end now use lastIndexOf to prevent
  // content truncation when Gemini outputs a tag more than once.
  String _extractSection(String text, String startTag, String? endTag) {
    try {
      int start = text.lastIndexOf(startTag);
      if (start == -1) return "";
      start += startTag.length;

      // FIX: Use lastIndexOf for endTag too, searching backwards from end
      // to match the last occurrence, preventing mid-content truncation.
      int end;
      if (endTag != null) {
        end = text.lastIndexOf(endTag);
        if (end == -1 || end < start) end = text.length;
      } else {
        end = text.length;
      }

      String content = text.substring(start, end).trim();
      if (content.startsWith(':')) content = content.substring(1).trim();

      return _sanitizeGeminiOutput(content);
    } catch (e) {
      return "";
    }
  }

  String _sanitizeGeminiOutput(String rawText) {
    return rawText
        .replaceAll(
            RegExp(
              r'Mandala X|Sukta Y|Mantra Z|'
              r'Purvarchika X|Uttararchika X|Prapathaka X|Prapathaka Y|Verse Z|'
              r'Archika X|'
              r'Adhyaya X|Mantra Y|Shloka Z|'
              r'Kanda X|'
              r'Valli Y|Division X|Subdivision X|'
              r'Canto X|Chapter Y|'
              r'Book X|'
              r'\[Adhyaya/Prapathaka\]|\[Mantra/Shloka/Karika\]|'
              r'\[Number\]|\[Name\]',
              caseSensitive: false,
            ),
            '')
        .replaceAll(RegExp(r'[#\*_`~]+'), ' ')
        .replaceAll(
            RegExp(r'^\s*([\*\-\+]|\d+\.)\s+', multiLine: true), ' ')
        // FIX (⚠️ quote sanitizer): Extended to strip smart quotes anywhere
        // in the string, not just at the very start and end.
        .replaceAll(RegExp(r'["\u201C\u201D]'), '')
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
      _HomeTab(isLoading: _isLoading, initialWisdom: widget.initialWisdom),
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
            style: TextStyle(
                color: primaryColor,
                fontSize: sw * 0.06,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 200),
                  reverseTransitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ProfileScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
              if (mounted) setState(() {});
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
            final color = states.contains(WidgetState.selected)
                ? primaryColor
                : primaryColor.withValues(alpha: 0.8);
            return TextStyle(color: color, fontWeight: FontWeight.w500);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.selected)
                ? primaryColor
                : primaryColor.withValues(alpha: 0.8);
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
              NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.celebration_outlined),
                  selectedIcon: Icon(Icons.celebration),
                  label: 'Festivals'),
              NavigationDestination(
                  icon: Icon(Icons.auto_stories_outlined),
                  selectedIcon: Icon(Icons.auto_stories),
                  label: 'Stories'),
              NavigationDestination(
                  icon: Icon(Icons.psychology_outlined),
                  selectedIcon: Icon(Icons.psychology),
                  label: 'Gita'),
              NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings'),
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
  final Map<String, dynamic> initialWisdom;

  const _HomeTab({required this.isLoading, required this.initialWisdom});

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic>? _wisdomData;
  late bool _isWisdomLoading;
  bool _isSaved = false;
  StreamSubscription<DocumentSnapshot>? _wisdomSaveSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.initialWisdom.isNotEmpty) {
      _wisdomData = widget.initialWisdom;
      _isSaved = widget.initialWisdom['isInitiallySaved'] ?? false;
      _isWisdomLoading = false;
      _fetchDailyWisdom();
    } else {
      _isWisdomLoading = true;
      _fetchDailyWisdom();
    }
  }

  @override
  void dispose() {
    _wisdomSaveSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchDailyWisdom() async {
    final data = await WisdomService().getDailyWisdom();
    if (!mounted) return;
    if (data.isEmpty) {
      // getDailyWisdom failed or returned nothing — stop the spinner so
      // the user is never permanently stuck on a loading screen.
      setState(() => _isWisdomLoading = false);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _wisdomSaveSubscription?.cancel();

    final docRef = _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('SavedShlokas')
        .doc(data['Source']);

    _wisdomSaveSubscription = docRef.snapshots().listen((snapshot) {
      if (mounted) {
        setState(() {
          _isSaved = snapshot.exists;
          // FIX (Bug 1): Always update _wisdomData from the latest getDailyWisdom()
          // result. Previously this was blocked when initialWisdom was pre-loaded,
          // causing stale data to remain on screen even if a fresher shloka was
          // available from cloud sync.
          _wisdomData = data;
          _isWisdomLoading = false;
        });
      }
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  Future<void> _toggleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _wisdomData == null) return;

    final docRef = _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('SavedShlokas')
        .doc(_wisdomData!['Source']);

    // Optimistic Update
    setState(() => _isSaved = !_isSaved);

    try {
      if (_isSaved) {
        final Map<String, dynamic> dataToSave =
            Map<String, dynamic>.from(_wisdomData!);
        dataToSave.remove('DeleteAt');
        dataToSave.remove('CreatedAt');
        dataToSave.remove('Date');
        dataToSave.remove('isInitiallySaved');

        await docRef.set({
          ...dataToSave,
          'SavedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.delete();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaved = !_isSaved);
        _showError("Cloud sync failed. Check your connection.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sw = MediaQuery.sizeOf(context).width;
    final sh = MediaQuery.sizeOf(context).height;

    final bool totalLoading = widget.isLoading || _isWisdomLoading;

    if (totalLoading) {
      return FutureBuilder(
        key: const ValueKey('loading_home_tab'),
        future: Future.delayed(const Duration(milliseconds: 300)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && totalLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return const SizedBox.shrink();
        },
      );
    }

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
    final double cardPadding = sw * 0.05;
    final double internalSpacing = sh * 0.015;

    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: cardPadding, horizontal: sw * 0.04),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(sw * 0.05),
        border: Border.all(color: primaryColor, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: sw * 0.1),
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
              SizedBox(
                width: sw * 0.1,
                height: sw * 0.05,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    color: primaryColor,
                    size: sw * 0.055,
                  ),
                  onPressed: _toggleSave,
                ),
              ),
            ],
          ),
          SizedBox(height: internalSpacing),
          _buildInternalBlock(
              "Scripture", _wisdomData?['Source'] ?? '', sw, sh),
          _buildInternalBlock("Sacred Shloka", _wisdomData?['Shloka'] ?? '',
              sw, sh,
              isSanskrit: true, isItalic: true),
          _buildInternalBlock(
              "Translation", _wisdomData?['Meaning'] ?? '', sw, sh),
          _buildInternalBlock(
              "Modern Relevance", _wisdomData?['Explanation'] ?? '', sw, sh,
              isJustified: true),
        ],
      ),
    );
  }

  Widget _buildInternalBlock(String title, String content, double sw, double sh,
      {bool isSanskrit = false,
      bool isItalic = false,
      bool isJustified = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: sh * 0.012),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(sw * 0.035),
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
                    fontSize: sw * 0.030,
                    letterSpacing: 1.0)),
            SizedBox(height: sh * 0.006),
            Text(
              content,
              textAlign:
                  isJustified ? TextAlign.justify : TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: sw * 0.036,
                fontFamily: 'Serif',
                fontStyle: isItalic || isSanskrit
                    ? FontStyle.italic
                    : FontStyle.normal,
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