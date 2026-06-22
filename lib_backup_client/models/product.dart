class ProductVariant {
  final String id;
  final String name;
  final double priceModifier;

  ProductVariant({
    required this.id,
    required this.name,
    required this.priceModifier,
  });
}

class ProductOption {
  final String id;
  final String name;
  final List<ProductVariant> variants;
  final bool isRequired;
  final int maxSelection;

  ProductOption({
    required this.id,
    required this.name,
    required this.variants,
    this.isRequired = false,
    this.maxSelection = 1,
  });
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final bool isPopular;
  final double rating;
  final List<ProductOption>? options;
  final bool inStock;
  final String? unit; // ex: "kg", "L", "pièce"
  final double? discount; // pourcentage de réduction

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.isPopular = false,
    this.rating = 4.5,
    this.options,
    this.inStock = true,
    this.unit,
    this.discount,
  });

  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price * (1 - discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;
}
