import 'cart_item.dart';

enum OrderStatus { received, preparing, delivering, delivered, cancelled }

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? deliveryAddress;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    this.deliveryAddress,
  });

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items
        .map(
          (item) => {
            'productId': item.productId,
            'name': item.name,
            'price': item.price,
            'quantity': item.quantity,
            'note': item.note,
            'groupKey': item.groupKey,
            'selectedOptions': item.selectedOptions,
          },
        )
        .toList(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'tax': tax,
    'total': total,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'deliveryAddress': deliveryAddress,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as String,
    items: (json['items'] as List<dynamic>).map((e) {
      final m = e as Map<String, dynamic>;
      return CartItem(
        productId: m['productId'] as String,
        name: m['name'] as String,
        price: (m['price'] as num).toDouble(),
        quantity: (m['quantity'] as num).toInt(),
        note: m['note'] as String?,
        groupKey: m['groupKey'] as String,
        selectedOptions: (m['selectedOptions'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as List<dynamic>).cast<String>()),
        ),
      );
    }).toList(),
    subtotal: (json['subtotal'] as num).toDouble(),
    deliveryFee: (json['deliveryFee'] as num).toDouble(),
    tax: (json['tax'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
    status: OrderStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => OrderStatus.received,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    deliveryAddress: json['deliveryAddress'] as String?,
  );
}
