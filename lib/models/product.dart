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

  // API ke JSON data ko Product model me map karne ke liye factory
  factory Product.fromJson(Map<String, dynamic> json) {
    // FakeStore API ki rating ek nested object me hoti hai ({rate: 3.9, count: 120})
    var ratingData = json['rating'] ?? {};
    double rate = (ratingData['rate'] ?? 4.0).toDouble();
    int count = (ratingData['count'] ?? 100).toInt();

    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? '',
      category: json['category'] ?? 'General',
      price: (json['price'] ?? 0.0).toDouble() * 80, // Dollars ko Rupees me approximate convert karne ke liye (Optional)
      originalPrice: ((json['price'] ?? 0.0) * 1.25) * 80,
      description: json['description'] ?? '',
      rating: rate,
      reviewCount: count,
      imageUrl: json['image'] ?? '',
      discountPercent: 20,
    );
  }
}