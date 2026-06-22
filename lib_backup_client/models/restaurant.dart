import 'dish.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String image;
  final String category;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final bool isVIP;
  final List<Dish> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    this.isVIP = false,
    required this.menu,
  });
}
