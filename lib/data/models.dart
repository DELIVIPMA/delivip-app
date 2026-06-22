import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════
//  MODELS — DeliVip Core Data Layer
// ═══════════════════════════════════════════════════════

/// An optional add‑on / extra item (e.g. "Frites +15 DH")
class AddonOption {
  final String id;
  final String name;
  final String emoji;
  final double price;

  const AddonOption({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String emoji;
  final String category;
  final String imageUrl;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    this.category = 'Plats',
    this.imageUrl = '',
  });

  /// Default add‑ons offered for this type of item.
  List<AddonOption> get defaultAddons => [
    AddonOption(id: '${id}_frites', name: 'Frites', emoji: '🍟', price: 15.00),
    AddonOption(
      id: '${id}_boisson',
      name: 'Boisson',
      emoji: '🥤',
      price: 10.00,
    ),
    AddonOption(
      id: '${id}_fromage',
      name: 'Extra Fromage',
      emoji: '🧀',
      price: 5.00,
    ),
    AddonOption(
      id: '${id}_sauce',
      name: 'Sauce Supplémentaire',
      emoji: '🥫',
      price: 3.00,
    ),
  ];
}

class Restaurant {
  final String id;
  final String name;
  final double rating;
  final String time;
  final String fee;
  final String emoji;
  final String imageUrl;
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
    this.imageUrl = '',
    this.category = 'Restaurants',
    this.reviewCount = 0,
    this.menu = const [],
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  List<AddonOption> selectedAddons;

  CartItem({
    required this.item,
    this.quantity = 1,
    List<AddonOption>? selectedAddons,
  }) : selectedAddons = selectedAddons ?? [];

  /// Prix de l'item × quantité + tous les add‑ons sélectionnés
  double get totalPrice {
    final addonsTotal = selectedAddons.fold(0.0, (sum, a) => sum + a.price);
    return (item.price + addonsTotal) * quantity;
  }

  /// Description textuelle des add‑ons sélectionnés
  String get addonsDescription => selectedAddons.isEmpty
      ? ''
      : selectedAddons.map((a) => a.name).join(', ');

  Map<String, dynamic> toJson() => {
    'name': item.name,
    'price': item.price,
    'quantity': quantity,
    'addons': selectedAddons.map((a) => a.name).join(', '),
  };
}

class Order {
  final String id;
  final String restaurantName;
  final String restaurantId;
  final List<CartItem> items;
  final double total;
  final String deliveryAddress;
  final String customerPhone;
  String
  status; // pending, confirmed, preparing, ready, delivering, delivered, cancelled
  final DateTime date;

  Order({
    required this.id,
    required this.restaurantName,
    required this.restaurantId,
    required this.items,
    required this.total,
    this.deliveryAddress = '',
    this.customerPhone = '',
    this.status = 'pending',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  String get statusText {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmée';
      case 'preparing':
        return 'En préparation';
      case 'ready':
        return 'Prête';
      case 'delivering':
        return 'En livraison';
      case 'delivered':
        return 'Livrée';
      case 'cancelled':
        return 'Annulée';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFA000);
      case 'confirmed':
        return const Color(0xFF2196F3);
      case 'preparing':
        return const Color(0xFFFF9800);
      case 'ready':
        return const Color(0xFF00BFA5);
      case 'delivering':
        return const Color(0xFF3F51B5);
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get formattedDate {
    final d = date;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

// ═══ SAMPLE DATA ═════════════════════════════════

final List<Restaurant> sampleRestaurants = [
  Restaurant(
    id: 'r1',
    name: 'Pizza Marrakech',
    rating: 4.5,
    time: '20-30 min',
    fee: '5.00 DH',
    emoji: '🍕',
    imageUrl:
        'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600&q=80',
    reviewCount: 1240,

    menu: [
      MenuItem(
        id: 'm1',
        name: 'Margherita',
        description: 'Sauce tomate, mozzarella, basilic',
        price: 45.00,
        emoji: '🍕',
      ),
      MenuItem(
        id: 'm2',
        name: 'Pepperoni',
        description: 'Sauce tomate, mozzarella, pepperoni',
        price: 55.00,
        emoji: '🍕',
      ),
      MenuItem(
        id: 'm3',
        name: 'Quatre Fromages',
        description: 'Mozzarella, chèvre, gorgonzola, parmesan',
        price: 65.00,
        emoji: '🧀',
      ),
      MenuItem(
        id: 'm4',
        name: 'Pizza Végétarienne',
        description: 'Légumes frais, sauce tomate, mozzarella',
        price: 50.00,
        emoji: '🥬',
      ),
    ],
  ),
  Restaurant(
    id: 'r2',
    name: 'Burger House',
    rating: 4.8,
    time: '25-35 min',
    fee: '4.50 DH',
    emoji: '🍔',
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
    reviewCount: 2890,

    menu: [
      MenuItem(
        id: 'm5',
        name: 'Big Burger',
        description: 'Deux steaks, salade, fromage, sauce spéciale',
        price: 35.00,
        emoji: '🍔',
      ),
      MenuItem(
        id: 'm6',
        name: 'Chicken Burger',
        description: 'Poulet pané, salade, mayonnaise',
        price: 28.00,
        emoji: '🐔',
      ),
      MenuItem(
        id: 'm7',
        name: 'Frites Maison',
        description: 'Frites dorées et croustillantes',
        price: 15.00,
        emoji: '🍟',
      ),
      MenuItem(
        id: 'm8',
        name: 'Milkshake Oreo',
        description: 'Glace vanille, morceaux d\'Oreo',
        price: 22.00,
        emoji: '🍪',
      ),
    ],
  ),
  Restaurant(
    id: 'r3',
    name: 'Sushi Souss',
    rating: 4.7,
    time: '30-40 min',
    fee: '6.00 DH',
    emoji: '🍣',
    imageUrl:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600&q=80',
    reviewCount: 856,

    menu: [
      MenuItem(
        id: 'm9',
        name: 'California Roll',
        description: 'Crabe, avocat, concombre',
        price: 55.00,
        emoji: '🍣',
      ),
      MenuItem(
        id: 'm10',
        name: 'Salmon Sashimi',
        description: 'Saumon frais tranché finement',
        price: 70.00,
        emoji: '🐟',
      ),
      MenuItem(
        id: 'm11',
        name: 'Dragon Roll',
        description: 'Tempura crevettes, avocat, sauce spicy',
        price: 65.00,
        emoji: '🐉',
      ),
      MenuItem(
        id: 'm12',
        name: 'Edamame',
        description: 'Fèves de soja à la vapeur, sel marin',
        price: 25.00,
        emoji: '🫘',
      ),
    ],
  ),
  Restaurant(
    id: 'r4',
    name: 'KFC',
    rating: 4.3,
    time: '20-30 min',
    fee: '4.00 DH',
    emoji: '🍗',
    imageUrl:
        'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&q=80',
    reviewCount: 2150,

    menu: [
      MenuItem(
        id: 'm13',
        name: 'Bucket 6 Pièces',
        description: '6 morceaux de poulet frit, frites, boisson',
        price: 69.00,
        emoji: '🍗',
      ),
      MenuItem(
        id: 'm14',
        name: 'Twister Box',
        description: 'Twister, frites, boisson, nuggets 4pc',
        price: 55.00,
        emoji: '🌯',
      ),
      MenuItem(
        id: 'm15',
        name: 'Wings 8 Pièces',
        description: '8 ailes de poulet croustillantes',
        price: 45.00,
        emoji: '🍗',
      ),
      MenuItem(
        id: 'm16',
        name: 'Nuggets 10 Pièces',
        description: 'Nuggets de poulet avec sauce BBQ',
        price: 39.00,
        emoji: '🐔',
      ),
    ],
  ),
];
