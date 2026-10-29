class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String description;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final int? discountPercent;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.discountPercent,
  });
}