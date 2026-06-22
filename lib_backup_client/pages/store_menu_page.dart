import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/store_model.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/cart_bar.dart';
import '../widgets/three_d_icon.dart';
import 'product_options_sheet.dart';

class StoreMenuPage extends StatefulWidget {
  final StoreModel store;

  const StoreMenuPage({super.key, required this.store});

  @override
  State<StoreMenuPage> createState() => _StoreMenuPageState();
}

class _StoreMenuPageState extends State<StoreMenuPage> {
  late List<ProductModel> _products;
  final List<CartItem> _cartItems = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _products = MockData.getProductsForStore(widget.store.id);
  }

  int get cartItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  String get groupKey =>
      '${widget.store.id}-${DateTime.now().millisecondsSinceEpoch}';

  void _addProduct(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductOptionsSheet(
        product: product,
        groupKey: groupKey,
        onAddToCart: (cartItem) {
          setState(() => _cartItems.add(cartItem));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ThreeDIcon(
              icon: AppIcons.forStore(widget.store.emoji),
              size: 32,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              iconColor: Colors.white,
              borderRadius: 8,
              showShadow: false,
            ),
            const SizedBox(width: 8),
            Text(
              widget.store.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStoreHeader(),
          _buildCategoryTabs(),
          Expanded(child: _buildMenuItems()),
        ],
      ),
      bottomNavigationBar: _buildCartBar(),
    );
  }

  Widget _buildStoreHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primary,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFFCD033)),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.store.rating}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.store.deliveryTime,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.store.deliveryFee,
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      'All',
      'Burgers',
      'Meals',
      'Sides',
      'Drinks',
      'Desserts',
    ];
    return Container(
      height: 44,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItems() {
    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThreeDIcon(
              icon: AppIcons.forStore(widget.store.emoji),
              size: 80,
              backgroundColor: widget.store.bgColor,
              iconColor: AppTheme.primary,
              borderRadius: 20,
            ),
            const SizedBox(height: 16),
            const Text(
              'Menu coming soon!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return MenuItemCard(
          product: _products[index],
          onAdd: () => _addProduct(_products[index]),
        );
      },
    );
  }

  Widget _buildCartBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: CartBar(
        itemCount: cartItemCount,
        totalPrice: cartTotal,
        onTap: () {},
      ),
    );
  }
}
