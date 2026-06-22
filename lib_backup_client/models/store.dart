import 'store_type.dart';
import 'product.dart';

class Store {
  final String id;
  final String name;
  final String description;
  final String image;
  final StoreType storeType;
  final String category;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final bool isVIP;
  final List<Product> products;
  final String address;
  final bool isOpen;
  final String openingHours;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.storeType,
    required this.category,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    this.isVIP = false,
    required this.products,
    required this.address,
    this.isOpen = true,
    this.openingHours = '9:00 - 22:00',
  });
}
