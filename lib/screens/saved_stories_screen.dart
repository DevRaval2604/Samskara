import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/common_widgets.dart'; 
import 'stories_of_india_detail_screen.dart';

class SavedStoriesScreen extends StatefulWidget {
  const SavedStoriesScreen({super.key});

  @override
  State<SavedStoriesScreen> createState() => _SavedStoriesScreenState();
}

class _SavedStoriesScreenState extends State<SavedStoriesScreen> {
  // Pagination Logic
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  bool _isLoading = false;
  bool _hasNextPage = false; 
  
  List<DocumentSnapshot> _savedStories = [];
  DocumentSnapshot? _lastDocument;
  final Map<int, DocumentSnapshot?> _pageHistory = {1: null}; 

  // Search Logic (Integrated)
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchSavedStories(isInitial: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSavedStories({bool isNext = false, bool isInitial = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _isLoading) return;
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      Query query = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('SavedStories')
          .orderBy('Title'); 

      if (_searchQuery.isNotEmpty) {
        String input = _searchQuery.trim().toLowerCase();
        String searchFormatted = input[0].toUpperCase() + input.substring(1);

        query = query
            .where('Title', isGreaterThanOrEqualTo: searchFormatted)
            .where('Title', isLessThanOrEqualTo: '$searchFormatted\uf8ff');
      }

      query = query.limit(_itemsPerPage + 1);

      if (isNext && _lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      } else if (!isNext && !isInitial) {
        final previousDoc = _pageHistory[_currentPage];
        if (previousDoc != null) {
          query = query.startAtDocument(previousDoc);
        }
      }

      final querySnapshot = await query.get();
      if (!mounted) return;

      setState(() {
        final allDocs = querySnapshot.docs;
        if (allDocs.length > _itemsPerPage) {
          _hasNextPage = true;
          _savedStories = allDocs.sublist(0, _itemsPerPage);
        } else {
          _hasNextPage = false;
          _savedStories = allDocs;
        }

        if (_savedStories.isNotEmpty) {
          _lastDocument = _savedStories.last;
          if (isNext) {
            _pageHistory[_currentPage] = _savedStories.first;
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint("Error: $e");
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = value;
        _currentPage = 1;
        _lastDocument = null;
        _pageHistory.clear();
        _pageHistory[1] = null;
      });
      _fetchSavedStories(isInitial: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    final sw = mq.width;
    final sh = mq.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "My Legacy Collection",
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(sw, sh),
          
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isLoading 
                  ? FutureBuilder(
                      key: ValueKey('loading_page_$_currentPage'), 
                      future: Future.delayed(const Duration(milliseconds: 200)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && _isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: primaryColor),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  : _savedStories.isEmpty 
                      ? _buildEmptyState(sw, sh)
                      : ListView.builder(
                          key: ValueKey('saved_page_$_currentPage'), 
                          padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.01),
                          itemCount: _savedStories.length,
                          itemBuilder: (context, index) {
                            final data = _savedStories[index].data() as Map<String, dynamic>;
                            return _buildSavedCard(context, data, sw, sh);
                          },
                        ),
            ),
          ),
          _buildPaginationFooter(sw, sh),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double sw, double sh) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.01),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: primaryColor, fontSize: sw * 0.04),
        decoration: InputDecoration(
          hintText: "Search your saved legends...",
          hintStyle: TextStyle(color: primaryColor.withValues(alpha: 0.4), fontSize: sw * 0.035),
          prefixIcon: Icon(Icons.search, color: primaryColor.withValues(alpha: 0.5), size: sw * 0.05),
          suffixIcon: _searchQuery.isNotEmpty 
            ? IconButton(
                icon: Icon(Icons.clear, color: primaryColor, size: sw * 0.045),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged("");
                },
              ) 
            : null,
          filled: true,
          fillColor: primaryColor.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sw * 0.08),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildSavedCard(BuildContext context, Map<String, dynamic> data, double sw, double sh) {
    return Container(
      margin: EdgeInsets.only(bottom: sh * 0.02),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03), 
        borderRadius: BorderRadius.circular(sw * 0.03),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.01),
        title: Text(
          data['Title'] ?? 'The Legacy',
          style: TextStyle(
            color: primaryColor, 
            fontSize: sw * 0.045, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'Serif'
          ),
        ),
        subtitle: Text(
          "Tap to explore this legend", 
          style: TextStyle(
            color: primaryColor.withValues(alpha: 0.5), 
            fontSize: sw * 0.03
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios, 
          color: primaryColor, 
          size: sw * 0.04
        ),
        onTap: () async {
          await Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  StoryDetailScreen(data: data, isInitiallySaved: true), 
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  child: child,
                );
              },
            ),
          );
          // Refresh list on return to remove items un-bookmarked in detail screen
          if (mounted) {
            // 1. Refresh the current page data
            await _fetchSavedStories(isInitial: false, isNext: false);

            // 2. SAFETY CHECK: If the page is now empty and we aren't on page 1, go back
            if (_savedStories.isEmpty && _currentPage > 1) {
              setState(() {
                _currentPage--;
              });
              _fetchSavedStories(); // Fetch the previous page automatically
            }
          }
        },
      ),
    );
  }

  Widget _buildPaginationFooter(double sw, double sh) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: sh * 0.02),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: primaryColor.withValues(alpha: 0.05)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navIcon(Icons.chevron_left, (_currentPage > 1 && !_isLoading) ? () {
            setState(() => _currentPage--);
            _fetchSavedStories();
          } : null, sw),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.1),
            child: Text("Page $_currentPage", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: sw * 0.04)),
          ),
          _navIcon(Icons.chevron_right, (_hasNextPage && !_isLoading) ? () {
            _pageHistory[_currentPage] = _savedStories.first; 
            setState(() => _currentPage++);
            _fetchSavedStories(isNext: true);
          } : null, sw),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, VoidCallback? onTap, double sw) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.2 : 1.0,
        child: Container(
          padding: EdgeInsets.all(sw * 0.02),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor)),
          child: Icon(icon, color: primaryColor, size: sw * 0.05),
        ),
      ),
    );
  }

  Widget _buildEmptyState(double sw, double sh) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories_outlined, size: sw * 0.2, color: primaryColor.withValues(alpha: 0.3)),
          SizedBox(height: sh * 0.02),
          Text(
            _searchQuery.isEmpty ? "Your legacy treasury is\ncurrently empty." : "No such gem found in\nyour legacy collection.",
            textAlign: TextAlign.center,
            style: TextStyle(color: primaryColor, fontSize: sw * 0.045, fontFamily: 'Serif'),
          ),
        ],
      ),
    );
  }
}