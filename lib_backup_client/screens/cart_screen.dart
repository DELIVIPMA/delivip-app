import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/cart_provider.dart';
import 'cart_empty_screen.dart';
import 'cart_order_screen.dart';

// ═══════════════════════════════════════════════════════
//  CART SCREEN — DeliVip panier
// ═══════════════════════════════════════════════════════

class CartScreen extends StatelessWidget {
  final CartProvider? cart;
  final void Function(Order)? onOrderPlaced;
  const CartScreen({super.key, this.cart, this.onOrderPlaced});

  @override
  Widget build(BuildContext context) {
    final cartItems = cart?.items ?? [];

    if (cartItems.isEmpty) {
      return const CartEmptyScreen();
    }

    return CartOrderScreen(cartItems: cartItems);
  }
}
