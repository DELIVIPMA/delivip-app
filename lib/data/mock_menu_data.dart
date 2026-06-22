import 'package:flutter/material.dart';

class MenuCategory {
  final String name;
  final IconData icon;
  final List<MenuItem> items;

  const MenuCategory({
    required this.name,
    required this.icon,
    required this.items,
  });
}

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isPopular;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isPopular = false,
  });
}

class RestaurantInfo {
  final String name;
  final double rating;
  final int ratingCount;
  final String deliveryTime;
  final double deliveryFee;
  final String imageUrl;
  final List<MenuCategory> categories;

  const RestaurantInfo({
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.imageUrl,
    required this.categories,
  });
}

final mockRestaurant = RestaurantInfo(
  name: 'Burger House',
  rating: 4.7,
  ratingCount: 1250,
  deliveryTime: '15-25 min',
  deliveryFee: 3.99,
  imageUrl: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=600',
  categories: [
    MenuCategory(
      name: 'Popular',
      icon: Icons.trending_up_rounded,
      items: [
        MenuItem(
          name: 'Classic Cheeseburger',
          description:
              'Double beef patty, cheddar, lettuce, tomato, special sauce',
          price: 12.99,
          imageUrl:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
          isPopular: true,
        ),
        MenuItem(
          name: 'Bacon Deluxe',
          description:
              'Crispy bacon, smoked gouda, caramelized onions, bbq sauce',
          price: 15.49,
          imageUrl:
              'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=200',
          isPopular: true,
        ),
        MenuItem(
          name: 'Truffle Fries',
          description: 'Hand-cut fries, truffle oil, parmesan, fresh herbs',
          price: 8.99,
          imageUrl:
              'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=200',
          isPopular: true,
        ),
      ],
    ),
    MenuCategory(
      name: 'Burgers',
      icon: Icons.lunch_dining_rounded,
      items: [
        MenuItem(
          name: 'Classic Cheeseburger',
          description:
              'Double beef patty, cheddar, lettuce, tomato, special sauce',
          price: 12.99,
          imageUrl:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
        ),
        MenuItem(
          name: 'Bacon Deluxe',
          description:
              'Crispy bacon, smoked gouda, caramelized onions, bbq sauce',
          price: 15.49,
          imageUrl:
              'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=200',
        ),
        MenuItem(
          name: 'Veggie Burger',
          description: 'Black bean patty, avocado, sprouts, vegan aioli',
          price: 11.99,
          imageUrl:
              'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=200',
        ),
        MenuItem(
          name: 'Mushroom Swiss',
          description: 'Portobello mushrooms, swiss cheese, garlic aioli',
          price: 13.49,
          imageUrl:
              'https://images.unsplash.com/photo-1586816001966-79b736744398?w=200',
        ),
      ],
    ),
    MenuCategory(
      name: 'Tacos',
      icon: Icons.takeout_dining_rounded,
      items: [
        MenuItem(
          name: 'Street Tacos (3)',
          description: 'Carne asada, fresh salsa, cilantro, lime',
          price: 10.99,
          imageUrl:
              'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=200',
        ),
        MenuItem(
          name: 'Fish Tacos',
          description: 'Battered cod, cabbage slaw, chipotle crema',
          price: 12.49,
          imageUrl:
              'https://images.unsplash.com/photo-1534309579666-59e0e0d75b0e?w=200',
        ),
      ],
    ),
    MenuCategory(
      name: 'Drinks',
      icon: Icons.local_cafe_rounded,
      items: [
        MenuItem(
          name: 'Craft Lemonade',
          description: 'Fresh squeezed, choice of original or strawberry',
          price: 4.99,
          imageUrl:
              'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=200',
        ),
        MenuItem(
          name: 'Milkshake',
          description: 'Vanilla, chocolate, or strawberry with whipped cream',
          price: 6.99,
          imageUrl:
              'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=200',
        ),
        MenuItem(
          name: 'Iced Tea',
          description: 'Fresh brewed, sweetened or unsweetened',
          price: 3.49,
          imageUrl:
              'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=200',
        ),
      ],
    ),
  ],
);
