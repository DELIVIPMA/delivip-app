class CartItem {
  final String productId;
  final String name;
  double price;
  int quantity;
  final String? note;
  final String groupKey;
  final Map<String, List<String>> selectedOptions;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.note,
    required this.groupKey,
    this.selectedOptions = const {},
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'note': note,
    'groupKey': groupKey,
    'selectedOptions': selectedOptions.map((k, v) => MapEntry(k, v)),
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] as int? ?? 1,
    note: json['note'] as String?,
    groupKey: json['groupKey'] as String? ?? '',
    selectedOptions: json['selectedOptions'] != null
        ? (json['selectedOptions'] as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, List<String>.from(v as List)),
          )
        : const {},
  );
}
