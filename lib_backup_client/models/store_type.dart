import 'package:flutter/material.dart';

enum StoreType {
  restaurant,
  grocery,
  pharmacy,
  shop,
}

class StoreTypeInfo {
  final StoreType type;
  final String name;
  final String namePlural;
  final IconData icon;
  final Color color;
  final String description;

  const StoreTypeInfo({
    required this.type,
    required this.name,
    required this.namePlural,
    required this.icon,
    required this.color,
    required this.description,
  });

  static const Map<StoreType, StoreTypeInfo> info = {
    StoreType.restaurant: StoreTypeInfo(
      type: StoreType.restaurant,
      name: 'Restaurant',
      namePlural: 'Restaurants',
      icon: Icons.restaurant,
      color: Color(0xFFFF6B6B),
      description: 'Commandez vos plats préférés',
    ),
    StoreType.grocery: StoreTypeInfo(
      type: StoreType.grocery,
      name: 'Épicerie',
      namePlural: 'Épiceries',
      icon: Icons.shopping_basket,
      color: Color(0xFF4ECDC4),
      description: 'Courses livrées en quelques minutes',
    ),
    StoreType.pharmacy: StoreTypeInfo(
      type: StoreType.pharmacy,
      name: 'Pharmacie',
      namePlural: 'Pharmacies',
      icon: Icons.local_pharmacy,
      color: Color(0xFF95E1D3),
      description: 'Médicaments et produits de santé',
    ),
    StoreType.shop: StoreTypeInfo(
      type: StoreType.shop,
      name: 'Boutique',
      namePlural: 'Boutiques',
      icon: Icons.store,
      color: Color(0xFFFFA07A),
      description: 'Tout ce dont vous avez besoin',
    ),
  };

  static StoreTypeInfo get(StoreType type) {
    return info[type]!;
  }
}
