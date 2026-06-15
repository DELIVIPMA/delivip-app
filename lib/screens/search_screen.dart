import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  SEARCH SCREEN — DeliVip Recherche
// ═══════════════════════════════════════════════════════════════════

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTab = 0; // 0 = Tous

  final List<String> _tabs = ['Tous', 'Restaurants', '\u00C9picerie', 'D\u00E9pannage', 'Alcool'];

  final List<String> _recentSearches = ['Caf\u00E9', 'Irlandais'];

  final List<String> _categories = [
    'Petit-d\u00E9jeuner et Brunch',
    'Caf\u00E9 et Th\u00E9',
    'Chinois',
    'Indien',
    'Derni\u00E8res Offres',
    'R\u00E9compenses Restaurants',
    'Meilleur rapport qualit\u00E9',
    'Livraison nationale',
    'Mexicain',
    'Fast Food',
    'Healthy',
    'Pizza',
    'Sandwich',
    'Asiatique',
    'Boulangerie',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar (sticky) ─────────────────────────────
            _buildSearchBar(context),
            // ── Filter Tabs (sticky) ────────────────────────────
            _buildFilterTabs(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent searches
                    if (_searchController.text.isEmpty) ...[
                      _buildSectionLabel('Recherches r\u00E9centes'),
                      ..._recentSearches.map((term) => _buildSearchRow(term)),
                    ],
                    // Categories
                    _buildSectionLabel('Meilleures cat\u00E9gories', topMargin: _searchController.text.isEmpty ? 20 : 16),
                    ..._categories.map((cat) => _buildSearchRow(cat)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // ── Bottom Nav Bar (supprimée — gérée par MainShell) ───
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ SEARCH BAR ════════════════════════════════
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () => Navigator.of(context).maybePop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Nourriture, shopping, boissons, etc',
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFAAAAAA)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ FILTER TABS ═══════════════════════════════
  Widget _buildFilterTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final isActive = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _tabs[index],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isActive)
                    Container(height: 2, width: 20, color: Colors.black),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════ SECTION LABEL ═════════════════════════════
  Widget _buildSectionLabel(String label, {double topMargin = 16}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topMargin, 16, 8),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF888888)),
      ),
    );
  }

  // ═══════════════════ SEARCH ROW ════════════════════════════════
  Widget _buildSearchRow(String text) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: text.length),
        );
        setState(() {});
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
        ],
      ),
    );
  }

}
