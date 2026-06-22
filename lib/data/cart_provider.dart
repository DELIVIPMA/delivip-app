import 'package:flutter/material.dart';
import 'models.dart';

// ═══════════════════════════════════════════════════════
//  CART PROVIDER — Panier global avec ChangeNotifier
// ═══════════════════════════════════════════════════════

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String _restaurantId = '';
  String _restaurantName = '';

  // ─── Getters ─────────────────────────────────────────
  List<CartItem> get items => List.unmodifiable(_items);
  String get restaurantId => _restaurantId;
  String get restaurantName => _restaurantName;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => subtotal >= 100 ? 0.0 : 5.0;

  double get total => subtotal + deliveryFee;

  // ─── Méthodes ────────────────────────────────────────

  /// Ajoute un item au panier avec ses add‑ons optionnels.
  /// Si le restaurant change, vide le panier.
  void add(
    MenuItem item,
    String restId,
    String restName, {
    List<AddonOption> addons = const [],
    int quantity = 1,
  }) {
    if (_restaurantId.isNotEmpty && _restaurantId != restId) {
      _items.clear();
    }
    _restaurantId = restId;
    _restaurantName = restName;

    final existing = _items.where((c) => c.item.id == item.id).firstOrNull;
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(
        CartItem(item: item, quantity: quantity, selectedAddons: addons),
      );
    }
    notifyListeners();
  }

  /// Supprime une unité d'un item (ou retire l'item si quantité = 1).
  void remove(CartItem cartItem) {
    final idx = _items.indexOf(cartItem);
    if (idx == -1) return;
    if (_items[idx].quantity > 1) {
      _items[idx].quantity--;
    } else {
      _items.removeAt(idx);
    }
    if (_items.isEmpty) {
      _restaurantId = '';
      _restaurantName = '';
    }
    notifyListeners();
  }

  /// Incrémente la quantité d'un item via son ID.
  /// Utile pour le Quick Add / Quantity Selector des cartes menu.
  void incrementQuantity(String productId) {
    final existing = _items.where((c) => c.item.id == productId).firstOrNull;
    if (existing != null) {
      existing.quantity++;
    }
    notifyListeners();
  }

  /// Décrémente la quantité d'un item via son ID.
  /// Si la quantité atteint 0, retire l'item du panier.
  void decrementQuantity(String productId) {
    final existing = _items.where((c) => c.item.id == productId).firstOrNull;
    if (existing == null) return;
    if (existing.quantity > 1) {
      existing.quantity--;
    } else {
      _items.remove(existing);
    }
    if (_items.isEmpty) {
      _restaurantId = '';
      _restaurantName = '';
    }
    notifyListeners();
  }

  /// Retourne la quantité d'un item dans le panier (0 si absent).
  int itemQuantity(String productId) {
    return _items.where((c) => c.item.id == productId).firstOrNull?.quantity ??
        0;
  }

  /// Met à jour les add‑ons d'un item existant dans le panier.
  void updateAddons(String productId, List<AddonOption> addons) {
    final existing = _items.where((c) => c.item.id == productId).firstOrNull;
    if (existing != null) {
      existing.selectedAddons = List.from(addons);
      notifyListeners();
    }
  }

  /// Supprime complètement un item du panier.
  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    if (_items.isEmpty) {
      _restaurantId = '';
      _restaurantName = '';
    }
    notifyListeners();
  }

  /// Vide le panier.
  void clear() {
    _items.clear();
    _restaurantId = '';
    _restaurantName = '';
    notifyListeners();
  }

  /// Génère un résumé texte de la commande (pour PDF/WhatsApp).
  String get orderSummary {
    final buf = StringBuffer();
    buf.writeln('🛵 DELIVIP — Nouvelle Commande');
    buf.writeln('═' * 30);
    buf.writeln('Restaurant: $_restaurantName');
    buf.writeln('');
    for (final cartItem in _items) {
      buf.writeln(
        '${cartItem.quantity}x ${cartItem.item.name} — ${(cartItem.totalPrice).toStringAsFixed(2)} DH',
      );
    }
    buf.writeln('');
    buf.writeln('═' * 30);
    if (deliveryFee > 0) {
      buf.writeln('Sous-total:    ${subtotal.toStringAsFixed(2)} DH');
      buf.writeln('Livraison:     ${deliveryFee.toStringAsFixed(2)} DH');
    }
    buf.writeln('Total:         ${total.toStringAsFixed(2)} DH');
    return buf.toString();
  }
}
