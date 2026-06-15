import 'models.dart';

class CartProvider {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  double get total => _items.fold(0.0, (sum, i) => sum + i.totalPrice);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  void add(MenuItem item) {
    final existing = _items.where((i) => i.item.id == item.id).firstOrNull;
    if (existing != null) {
      existing.quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
  }

  void remove(String itemId) {
    _items.removeWhere((i) => i.item.id == itemId);
  }

  void increment(String itemId) {
    final existing = _items.where((i) => i.item.id == itemId).firstOrNull;
    if (existing != null) existing.quantity++;
  }

  void decrement(String itemId) {
    final existing = _items.where((i) => i.item.id == itemId).firstOrNull;
    if (existing != null) {
      if (existing.quantity <= 1) {
        remove(itemId);
      } else {
        existing.quantity--;
      }
    }
  }

  void clear() => _items.clear();
}
