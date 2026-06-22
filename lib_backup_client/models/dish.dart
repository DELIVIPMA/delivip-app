class Dish {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final bool isPopular;
  final double rating;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.isPopular = false,
    this.rating = 4.5,
  });
}
