import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/store.dart';
import '../models/store_type.dart';
import '../data/stores_data.dart';
import '../theme/app_theme.dart';
import 'store_detail_screen.dart';

class StoresListScreen extends StatefulWidget {
  final StoreType storeType;
  final AppState appState;

  const StoresListScreen({
    super.key,
    required this.storeType,
    required this.appState,
  });

  @override
  State<StoresListScreen> createState() => _StoresListScreenState();
}

class _StoresListScreenState extends State<StoresListScreen> {
  late List<Store> _stores;
  late StoreTypeInfo _storeTypeInfo;
  String _selectedFoodType = 'Tous';

  @override
  void initState() {
    super.initState();
    _stores = StoresData.getStoresByType(widget.storeType);
    _storeTypeInfo = StoreTypeInfo.get(widget.storeType);
  }

  List<String> get _foodTypes {
    if (widget.storeType != StoreType.restaurant) return ['Tous'];
    final types = _stores.map((s) => s.category).toSet().toList();
    types.sort();
    return ['Tous', ...types];
  }

  List<Store> get _filteredStores {
    if (_selectedFoodType == 'Tous') return _stores;
    return _stores.where((s) => s.category == _selectedFoodType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildSearchBar()),
          if (_foodTypes.length > 1)
            SliverToBoxAdapter(child: _buildFoodTypeFilter()),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildStoreCard(_filteredStores[index]);
              }, childCount: _filteredStores.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTypeFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _foodTypes.length,
        itemBuilder: (context, index) {
          final type = _foodTypes[index];
          final isSelected = type == _selectedFoodType;
          return GestureDetector(
            onTap: () => setState(() => _selectedFoodType = type),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? _storeTypeInfo.color
                    : _storeTypeInfo.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? _storeTypeInfo.color
                      : _storeTypeInfo.color.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : _storeTypeInfo.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 120,
      backgroundColor: _storeTypeInfo.color,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
        title: Row(
          children: [
            Icon(_storeTypeInfo.icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              _storeTypeInfo.namePlural,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        decoration: InputDecoration(
          hintText:
              'Rechercher dans ${_storeTypeInfo.namePlural.toLowerCase()}...',
          prefixIcon: Icon(Icons.search, color: _storeTypeInfo.color),
          filled: true,
          fillColor: Theme.of(context).cardTheme.color,
        ),
      ),
    );
  }

  Widget _buildStoreCard(Store store) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StoreDetailScreen(store: store, appState: widget.appState),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    store.image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: _storeTypeInfo.color.withValues(alpha: 0.2),
                        child: Icon(
                          _storeTypeInfo.icon,
                          size: 60,
                          color: _storeTypeInfo.color,
                        ),
                      );
                    },
                  ),
                ),
                if (store.isVIP)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.vipGold,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.vipGold.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'VIP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${store.deliveryTime} min',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!store.isOpen)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'FERMÉ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    store.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.vipGold, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        store.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.delivery_dining,
                        color: _storeTypeInfo.color,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        store.deliveryFee == 0
                            ? 'Livraison gratuite'
                            : '${store.deliveryFee.toStringAsFixed(0)} MAD',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: store.deliveryFee == 0
                              ? _storeTypeInfo.color
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
