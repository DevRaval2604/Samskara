import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samskara/screens/festivaldetail_screen.dart';
import '../widgets/common_widgets.dart';

class FestiveListScreen extends StatefulWidget {
  const FestiveListScreen({super.key});

  @override
  State<FestiveListScreen> createState() => _FestiveListScreenState();
}

class _FestiveListScreenState extends State<FestiveListScreen> {
  String _selectedRegion = 'All';
  final List<String> _regions = ['All', 'North', 'South', 'East', 'West' , 'Central'];

  int _currentPage = 1;
  final int _itemsPerPage = 5;
  bool _isLoading = false;
  bool _hasNextPage = false; 
  
  List<DocumentSnapshot> _festivals = [];
  DocumentSnapshot? _lastDocument;
  final Map<int, DocumentSnapshot?> _pageHistory = {1: null}; 

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchFestivals(isInitial: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchFestivals({bool isNext = false, bool isInitial = false}) async {
    // PROTECTIVE GUARD: If already loading, ignore additional requests
    if (_isLoading) return;

    // Check mounted before the first setState
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      Query query = FirebaseFirestore.instance.collection('Festivals').orderBy('Name');

      if (_selectedRegion != 'All') {
        query = query.where('Regions', arrayContains: _selectedRegion);
      }

      if (_searchQuery.isNotEmpty) {
        // 1. Clean the input and make everything lowercase
        String input = _searchQuery.trim().toLowerCase();
        
        // 2. Capitalize ONLY the first letter (e.g., "janmashtami" -> "Janmashtami")
        String searchFormatted = input[0].toUpperCase() + input.substring(1);

        // 3. Run the existing logic with the formatted string
        query = query
            .where('Name', isGreaterThanOrEqualTo: searchFormatted)
            .where('Name', isLessThanOrEqualTo: '$searchFormatted\uf8ff');
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

      // The network call happens here
      final querySnapshot = await query.get();

      // IMPORTANT: If the user left the screen while query.get() was running,
      // the following setState will fail. This check prevents the crash.
      if (!mounted) return;

      setState(() {
        final allDocs = querySnapshot.docs;
        if (allDocs.length > _itemsPerPage) {
          _hasNextPage = true;
          _festivals = allDocs.sublist(0, _itemsPerPage);
        } else {
          _hasNextPage = false;
          _festivals = allDocs;
        }

        if (_festivals.isNotEmpty) {
          _lastDocument = _festivals.last;
          if (isNext) {
            _pageHistory[_currentPage] = _festivals.first;
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      // Also check mounted in the catch block
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint("Error: $e");
    }
}

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;
    final topPadding = mq.padding.top;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(height: topPadding + sh * 0.02),
          _buildSearchBar(sw, sh),
          _buildFilterBar(sw, sh),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isLoading 
                  ? FutureBuilder(
                      // Use a unique key for the FutureBuilder itself so it resets on every fetch
                      key: ValueKey('loading_page_$_currentPage'), 
                      future: Future.delayed(const Duration(milliseconds: 200)),
                      builder: (context, snapshot) {
                        // snapshot.connectionState == ConnectionState.done means 200ms passed
                        if (snapshot.connectionState == ConnectionState.done && _isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: primaryColor),
                          );
                        }
                        // Before 200ms, or if data arrived early, show nothing
                        return const SizedBox.shrink();
                      },
                    )
                  : _festivals.isEmpty 
                      ? _buildEmptyState(sw)
                      : ListView.builder(
                          // Keeps the list update smooth
                          key: ValueKey('list_page_$_currentPage'), 
                          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                          itemCount: _festivals.length,
                          itemBuilder: (context, index) {
                            final data = _festivals[index].data() as Map<String, dynamic>;
                            return _buildFestivalItem(data, sw, sh);
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
          hintText: "Search festivals...",
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
      _fetchFestivals(isInitial: true);
    });
  }

  Widget _buildFilterBar(double sw, double sh) {
    return Container(
      height: sh * 0.06,
      margin: EdgeInsets.symmetric(vertical: sh * 0.01),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
        itemCount: _regions.length,
        itemBuilder: (context, index) {
          final region = _regions[index];
          final isSelected = _selectedRegion == region;
          return Padding(
            padding: EdgeInsets.only(right: sw * 0.03),
            child: ChoiceChip(
              label: Text(region),
              selected: isSelected,
              onSelected: (val) {
                // Ignore taps if currently loading
                if (val && !_isLoading) {
                  setState(() {
                    _selectedRegion = region;
                    _currentPage = 1;
                    _lastDocument = null;
                    _pageHistory.clear();
                    _pageHistory[1] = null;
                  });
                  _fetchFestivals(isInitial: true);
                }
              },
              selectedColor: primaryColor,
              backgroundColor: Colors.transparent,
              labelStyle: TextStyle(
                color: isSelected ? backgroundColor : primaryColor,
                fontSize: sw * 0.035
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(sw * 0.02),
                side: BorderSide(color: primaryColor.withValues(alpha: 0.3))
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFestivalItem(Map<String, dynamic> data, double sw, double sh) {
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
          data['Name'] ?? 'Utsav',
          style: TextStyle(color: primaryColor, fontSize: sw * 0.045, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
        ),
        subtitle: Text(
          "Tap to explore the festival",
          style: TextStyle(color: primaryColor.withValues(alpha: 0.5), fontSize: sw * 0.03),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: primaryColor, size: sw * 0.04),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FestivalDetailScreen(data: data), // Passing your festival data here
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                // Using Curves.easeOut to make the 200ms feel snappy and light
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,       // Snappy entrance
                  reverseCurve: Curves.easeIn, // Smooth exit
                );

                return FadeTransition(
                  opacity: curvedAnimation,
                  child: child,
                );
              },
            ),
          );
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
            _fetchFestivals();
          } : null, sw),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.1),
            child: Text(
              "Page $_currentPage",
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: sw * 0.04),
            ),
          ),
          
          _navIcon(Icons.chevron_right, (_hasNextPage && !_isLoading) ? () {
            _pageHistory[_currentPage] = _festivals.first; 
            setState(() => _currentPage++);
            _fetchFestivals(isNext: true);
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

  Widget _buildEmptyState(double sw) {
    return Center(
      child: Text(
        "No festivals found.",
        style: TextStyle(color: primaryColor.withValues(alpha: 0.4), fontSize: sw * 0.04),
      ),
    );
  }
}