// ═══════════════════════════════════════════════════════
//  ADMIN MODELS — DeliVip Dashboard Backoffice
// ═══════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'models.dart';

// ─── ADMIN PRODUCT ──────────────────────────────────
class AdminProduct {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  String category;
  bool isAvailable;

  AdminProduct({
    String? id,
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.imageUrl = '',
    this.category = 'Plats',
    this.isAvailable = true,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  MenuItem toMenuItem() => MenuItem(
        id: id,
        name: name,
        description: description,
        price: price,
        emoji: '🍽️',
        category: category,
      );
}

// ─── ADMIN STORE ────────────────────────────────────
class AdminStore {
  String id;
  String name;
  String description;
  String imageUrl;
  String emoji;
  double latitude;
  double longitude;
  String address;
  String openingHours;
  String closingHours;
  String phone;
  String category;
  bool isActive;
  bool isFeatured;
  List<AdminProduct> products;

  AdminStore({
    String? id,
    this.name = '',
    this.description = '',
    this.imageUrl = '',
    this.emoji = '🏪',
    this.latitude = 33.5731,
    this.longitude = -7.5898,
    this.address = '',
    this.openingHours = '09:00',
    this.closingHours = '22:00',
    this.phone = '',
    this.category = 'Restaurants',
    this.isActive = true,
    this.isFeatured = false,
    List<AdminProduct>? products,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       products = products ?? [];

  double get rating => 4.5;
  int get reviewCount => 120;
  String get time => '$openingHours - $closingHours';
  String get fee => '5.00 DH';

  Restaurant toRestaurant() => Restaurant(
        id: id,
        name: name,
        rating: rating,
        time: time,
        fee: fee,
        emoji: emoji,
        imageUrl: imageUrl,
        category: category,
        reviewCount: reviewCount,
        menu: products.map((p) => p.toMenuItem()).toList(),
      );
}

// ─── ADMIN ORDER ────────────────────────────────────
class AdminOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String storeName;
  final String storeId;
  final List<AdminOrderItem> items;
  final double total;
  String status; // pending, confirmed, preparing, ready, delivering, delivered, cancelled
  final DateTime orderDate;
  final String deliveryAddress;
  String? estimatedTime;
  
  // ── Delivery tracking timestamps ──
  DateTime? receivedAt;      // الوقت اللي وصل فيه الطلب من الزبون
  DateTime? confirmedAt;     // الوقت اللي تأكد فيه الطلب
  DateTime? completedAt;     // الوقت اللي اكتمل فيه التوصيل
  double? distanceKm;        // المسافة بالكيلومتر (km)
  String? deliveryDuration;  // المدة المستغرقة (ex: "25 دقيقة")

  AdminOrder({
    String? id,
    this.customerName = '',
    this.customerPhone = '',
    this.storeName = '',
    this.storeId = '',
    this.items = const [],
    this.total = 0.0,
    this.status = 'pending',
    DateTime? orderDate,
    this.deliveryAddress = '',
    this.estimatedTime,
    this.receivedAt,
    this.confirmedAt,
    this.completedAt,
    this.distanceKm,
    this.deliveryDuration,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       orderDate = orderDate ?? DateTime.now();

  String get statusText {
    switch (status) {
      case 'pending': return 'En attente';
      case 'confirmed': return 'Confirmée';
      case 'preparing': return 'En préparation';
      case 'ready': return 'Prête';
      case 'delivering': return 'En livraison';
      case 'delivered': return 'Livrée';
      case 'cancelled': return 'Annulée';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending': return const Color(0xFFFFA000);
      case 'confirmed': return const Color(0xFF2196F3);
      case 'preparing': return const Color(0xFFFF9800);
      case 'ready': return const Color(0xFF00BFA5);
      case 'delivering': return const Color(0xFF3F51B5);
      case 'delivered': return const Color(0xFF4CAF50);
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
  
  /// Returns formatted received time (e.g. "14:30")
  String get receivedTimeFormatted {
    if (receivedAt == null) return '-';
    final h = receivedAt!.hour.toString().padLeft(2, '0');
    final m = receivedAt!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
  
  /// Returns formatted confirmed time
  String get confirmedTimeFormatted {
    if (confirmedAt == null) return '-';
    final h = confirmedAt!.hour.toString().padLeft(2, '0');
    final m = confirmedAt!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
  
  /// Returns formatted completed time
  String get completedTimeFormatted {
    if (completedAt == null) return '-';
    final h = completedAt!.hour.toString().padLeft(2, '0');
    final m = completedAt!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class AdminOrderItem {
  final String name;
  final int quantity;
  final double price;

  const AdminOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// ─── ADMIN CATEGORY ─────────────────────────────────
class AdminCategory {
  String id;
  String name;
  String emoji;
  bool isActive;
  int displayOrder;

  AdminCategory({
    String? id,
    this.name = '',
    this.emoji = '📁',
    this.isActive = true,
    this.displayOrder = 0,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

// ─── APP SETTINGS ──────────────────────────────────
class AppSettings {
  String appName;
  String supportPhone;
  String supportEmail;
  double deliveryFee;
  double minOrderAmount;
  double freeDeliveryThreshold;
  String currency;
  bool enablePickup;
  bool enableDineIn;
  bool enableGrocery;
  bool enablePromotions;
  String primaryColor;
  String themeMode;

  AppSettings({
    this.appName = 'DELIVIP',
    this.supportPhone = '+212 5XX XX XX XX',
    this.supportEmail = 'support@delivip.ma',
    this.deliveryFee = 5.0,
    this.minOrderAmount = 20.0,
    this.freeDeliveryThreshold = 100.0,
    this.currency = 'DH',
    this.enablePickup = true,
    this.enableDineIn = true,
    this.enableGrocery = true,
    this.enablePromotions = true,
    this.primaryColor = '#00BFA5',
    this.themeMode = 'light',
  });
}

// ─── SAMPLE ADMIN DATA ─────────────────────────────
List<AdminStore> getSampleStores() {
  return [
    AdminStore(
      id: 'r1',
      name: 'Pizza Hut',
      description: 'La meilleure pizza de la ville. Pâtes fraîches, ingrédients de qualité.',
      emoji: '🍕',
      latitude: 33.5898,
      longitude: -7.6038,
      address: 'Angle Bd Zerktouni & Bd Mohammed V, Casablanca',
      phone: '+212 5XX XX XX XX',
      openingHours: '10:00',
      closingHours: '23:00',
      category: 'Restaurants',
      isActive: true,
      isFeatured: true,
      products: [
        AdminProduct(id: 'm1', name: 'Margherita', description: 'Sauce tomate, mozzarella, basilic', price: 45.00, category: 'Pizzas'),
        AdminProduct(id: 'm2', name: 'Pepperoni', description: 'Sauce tomate, mozzarella, pepperoni', price: 55.00, category: 'Pizzas'),
        AdminProduct(id: 'm3', name: 'Quatre Fromages', description: 'Mozzarella, chèvre, gorgonzola, parmesan', price: 65.00, category: 'Pizzas'),
        AdminProduct(id: 'm4', name: 'Pizza Végétarienne', description: 'Légumes frais, sauce tomate, mozzarella', price: 50.00, category: 'Pizzas'),
      ],
    ),
    AdminStore(
      id: 'r2',
      name: "McDonald's",
      description: 'Fast-food américain iconique. Burgers, frites, McFlurry.',
      emoji: '🍔',
      latitude: 33.5731,
      longitude: -7.5898,
      address: 'Complexe Marina, Casablanca',
      phone: '+212 5XX XX XX XX',
      openingHours: '08:00',
      closingHours: '01:00',
      category: 'Restaurants',
      isActive: true,
      products: [
        AdminProduct(id: 'm5', name: 'Big Mac', description: 'Deux steacks, salade, fromage, sauce spéciale', price: 35.00, category: 'Burgers'),
        AdminProduct(id: 'm6', name: 'McChicken', description: 'Poulet pané, salade, mayonnaise', price: 28.00, category: 'Burgers'),
        AdminProduct(id: 'm7', name: 'Frites Moyennes', description: 'Frites dorées et croustillantes', price: 15.00, category: 'Frites'),
        AdminProduct(id: 'm8', name: 'McFlurry Oreo', description: 'Glace vanille, morceaux d\'Oreo', price: 22.00, category: 'Desserts'),
      ],
    ),
    AdminStore(
      id: 'r3',
      name: 'Sushi Shop',
      description: 'Sushis frais préparés chaque jour.',
      emoji: '🍣',
      latitude: 33.5968,
      longitude: -7.6180,
      address: 'Rue Tantan, Quartier Gauthier, Casablanca',
      phone: '+212 5XX XX XX XX',
      openingHours: '11:00',
      closingHours: '22:30',
      category: 'Restaurants',
      isActive: true,
      products: [
        AdminProduct(id: 'm9', name: 'California Roll', description: 'Crabe, avocat, concombre', price: 55.00, category: 'Sushis'),
        AdminProduct(id: 'm10', name: 'Salmon Sashimi', description: 'Saumon frais tranché finement', price: 70.00, category: 'Sashimis'),
        AdminProduct(id: 'm11', name: 'Dragon Roll', description: 'Tempura crevettes, avocat, sauce spicy', price: 65.00, category: 'Sushis'),
        AdminProduct(id: 'm12', name: 'Edamame', description: 'Fèves de soja à la vapeur, sel marin', price: 25.00, category: 'Entrées'),
      ],
    ),
    AdminStore(
      id: 'r4',
      name: 'Taco Bell',
      description: 'Mexican fast food. Tacos, burritos, quesadillas.',
      emoji: '🌮',
      latitude: 33.5800,
      longitude: -7.6100,
      address: 'Morocco Mall, Casablanca',
      phone: '+212 5XX XX XX XX',
      openingHours: '10:00',
      closingHours: '22:00',
      category: 'Restaurants',
      isActive: true,
      products: [
        AdminProduct(id: 'm13', name: 'Crunchy Taco', description: 'Taco croustillant au boeuf', price: 25.00, category: 'Tacos'),
        AdminProduct(id: 'm14', name: 'Burrito Supreme', description: 'Burrito garni boeuf, riz, haricots', price: 38.00, category: 'Burritos'),
        AdminProduct(id: 'm15', name: 'Quesadilla Chicken', description: 'Quesadilla au poulet et fromage', price: 32.00, category: 'Quesadillas'),
      ],
    ),
    AdminStore(
      id: 'r5',
      name: 'Carrefour Market',
      description: 'Supermarché avec tout le nécessaire du quotidien.',
      emoji: '🏪',
      latitude: 33.5650,
      longitude: -7.5950,
      address: 'Avenue Hassan II, Casablanca',
      phone: '+212 5XX XX XX XX',
      openingHours: '08:00',
      closingHours: '22:00',
      category: 'Épicerie',
      isActive: true,
      products: [
        AdminProduct(id: 'm16', name: 'Coca-Cola 1.5L', description: 'Boisson gazeuse', price: 12.00, category: 'Boissons'),
        AdminProduct(id: 'm17', name: 'Lait Demi-écrémé', description: 'Lait frais 1L', price: 6.75, category: 'Produits laitiers'),
        AdminProduct(id: 'm18', name: 'Pain complet', description: 'Pain de mie complet 500g', price: 8.50, category: 'Boulangerie'),
      ],
    ),
  ];
}

List<AdminOrder> getSampleOrders() {
  final now = DateTime.now();
  return [
    AdminOrder(
      id: '#1245',
      customerName: 'Ahmed B.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Pizza Hut',
      storeId: 'r1',
      items: [AdminOrderItem(name: 'Margherita', quantity: 2, price: 45.00), AdminOrderItem(name: 'Coca-Cola', quantity: 1, price: 12.00)],
      total: 102.00,
      status: 'preparing',
      deliveryAddress: '12 Rue des Far, Casablanca',
      receivedAt: now.subtract(const Duration(minutes: 35)),
      confirmedAt: now.subtract(const Duration(minutes: 28)),
      distanceKm: 3.2,
      deliveryDuration: '25-35 دقيقة',
    ),
    AdminOrder(
      id: '#1244',
      customerName: 'Sara M.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: "McDonald's",
      storeId: 'r2',
      items: [AdminOrderItem(name: 'Big Mac', quantity: 1, price: 35.00), AdminOrderItem(name: 'Frites', quantity: 1, price: 15.00)],
      total: 50.00,
      status: 'ready',
      deliveryAddress: '45 Bd Zerktouni, Casablanca',
      receivedAt: now.subtract(const Duration(minutes: 50)),
      confirmedAt: now.subtract(const Duration(minutes: 42)),
      distanceKm: 1.8,
      deliveryDuration: '15-20 دقيقة',
    ),
    AdminOrder(
      id: '#1243',
      customerName: 'Omar K.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Sushi Shop',
      storeId: 'r3',
      items: [AdminOrderItem(name: 'California Roll', quantity: 2, price: 55.00), AdminOrderItem(name: 'Edamame', quantity: 1, price: 25.00)],
      total: 135.00,
      status: 'delivered',
      deliveryAddress: '8 Rue Tantan, Casablanca',
      receivedAt: now.subtract(const Duration(hours: 2, minutes: 15)),
      confirmedAt: now.subtract(const Duration(hours: 2, minutes: 10)),
      completedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
      distanceKm: 4.5,
      deliveryDuration: '40 دقيقة',
    ),
    AdminOrder(
      id: '#1242',
      customerName: 'Imane R.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Taco Bell',
      storeId: 'r4',
      items: [AdminOrderItem(name: 'Burrito Supreme', quantity: 1, price: 38.00)],
      total: 38.00,
      status: 'delivering',
      deliveryAddress: '3 Av. des FAR, Casablanca',
      receivedAt: now.subtract(const Duration(minutes: 20)),
      confirmedAt: now.subtract(const Duration(minutes: 14)),
      distanceKm: 2.1,
      deliveryDuration: '10-15 دقيقة',
    ),
    AdminOrder(
      id: '#1241',
      customerName: 'Youssef A.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Pizza Hut',
      storeId: 'r1',
      items: [AdminOrderItem(name: 'Pepperoni', quantity: 1, price: 55.00)],
      total: 55.00,
      status: 'cancelled',
      deliveryAddress: '22 Rue Mohammed V, Casablanca',
      receivedAt: now.subtract(const Duration(hours: 3)),
      confirmedAt: now.subtract(const Duration(hours: 2, minutes: 55)),
      distanceKm: 1.5,
    ),
    AdminOrder(
      id: '#1240',
      customerName: 'Fatima Z.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Carrefour Market',
      storeId: 'r5',
      items: [AdminOrderItem(name: 'Coca-Cola', quantity: 3, price: 12.00), AdminOrderItem(name: 'Lait', quantity: 2, price: 6.75)],
      total: 49.50,
      status: 'pending',
      deliveryAddress: '15 Bd Hassan II, Casablanca',
      receivedAt: now.subtract(const Duration(minutes: 5)),
      distanceKm: 1.2,
    ),
  ];
}

List<AdminCategory> getSampleCategories() {
  return [
    AdminCategory(id: 'c1', name: 'Restaurants', emoji: '🍽️', displayOrder: 0),
    AdminCategory(id: 'c2', name: 'Épicerie', emoji: '🏪', displayOrder: 1),
    AdminCategory(id: 'c3', name: 'Convenience', emoji: '🛒', displayOrder: 2),
    AdminCategory(id: 'c4', name: 'Promotions', emoji: '🏷️', displayOrder: 3),
    AdminCategory(id: 'c5', name: 'Nouveautés', emoji: '✨', displayOrder: 4),
  ];
}
