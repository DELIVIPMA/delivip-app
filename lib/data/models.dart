// ═══════════════════════════════════════════════════════
//  MODELS — DeliVip Data Layer (type UberEats)
// ═══════════════════════════════════════════════════════

class Restaurant {
  final String id;
  final String name;
  final double rating;
  final String time;
  final String fee;
  final String emoji;
  final String category;
  final int reviewCount;
  final List<MenuItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.time,
    required this.fee,
    required this.emoji,
    this.category = 'Restaurants',
    this.reviewCount = 0,
    this.menu = const [],
  });
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String emoji;
  final String category;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    this.category = 'Plats',
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});

  double get totalPrice => item.price * quantity;
}

class Order {
  final String id;
  final String restaurantName;
  final List<CartItem> items;
  final double total;
  final String status;
  final DateTime date;

  Order({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.total,
    this.status = 'En cours',
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

// ═══ SAMPLE DATA ═════════════════════════════════

final sampleRestaurants = [
  Restaurant(
    id: 'r1',
    name: 'Pizza Hut',
    rating: 4.5,
    time: '25-35 min',
    fee: '5.00 DH',
    emoji: '🍕',
    reviewCount: 1240,
    menu: [
      MenuItem(id: 'm1', name: 'Margherita', description: 'Sauce tomate, mozzarella, basilic', price: 45.00, emoji: '🍕'),
      MenuItem(id: 'm2', name: 'Pepperoni', description: 'Sauce tomate, mozzarella, pepperoni', price: 55.00, emoji: '🍕'),
      MenuItem(id: 'm3', name: 'Quatre Fromages', description: 'Mozzarella, chèvre, gorgonzola, parmesan', price: 65.00, emoji: '🧀'),
      MenuItem(id: 'm4', name: 'Pizza Végétarienne', description: 'Légumes frais, sauce tomate, mozzarella', price: 50.00, emoji: '🥬'),
    ],
  ),
  Restaurant(
    id: 'r2',
    name: "McDonald's",
    rating: 4.2,
    time: '15-25 min',
    fee: '4.50 DH',
    emoji: '🍔',
    reviewCount: 2890,
    menu: [
      MenuItem(id: 'm5', name: 'Big Mac', description: 'Deux steaks, salade, fromage, sauce spéciale', price: 35.00, emoji: '🍔'),
      MenuItem(id: 'm6', name: 'McChicken', description: 'Poulet pané, salade, mayonnaise', price: 28.00, emoji: '🐔'),
      MenuItem(id: 'm7', name: 'Frites Moyennes', description: 'Frites dorées et croustillantes', price: 15.00, emoji: '🍟'),
      MenuItem(id: 'm8', name: 'McFlurry Oreo', description: 'Glace vanille, morceaux d\'Oreo', price: 22.00, emoji: '🍪'),
    ],
  ),
  Restaurant(
    id: 'r3',
    name: 'Sushi Shop',
    rating: 4.7,
    time: '30-40 min',
    fee: '6.00 DH',
    emoji: '🍣',
    reviewCount: 856,
    menu: [
      MenuItem(id: 'm9', name: 'California Roll', description: 'Crabe, avocat, concombre', price: 55.00, emoji: '🍣'),
      MenuItem(id: 'm10', name: 'Salmon Sashimi', description: 'Saumon frais tranché finement', price: 70.00, emoji: '🐟'),
      MenuItem(id: 'm11', name: 'Dragon Roll', description: 'Tempura crevettes, avocat, sauce spicy', price: 65.00, emoji: '🐉'),
      MenuItem(id: 'm12', name: 'Edamame', description: 'Fèves de soja à la vapeur, sel marin', price: 25.00, emoji: '🫘'),
    ],
  ),
];
