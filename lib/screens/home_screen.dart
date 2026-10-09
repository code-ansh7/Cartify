import 'package:flutter/material.dart';
import 'package:novamart/app/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded},
    {'name': 'Electronics', 'icon': Icons.headphones_rounded},
    {'name': 'Beauty', 'icon': Icons.face_retouching_natural},
    {'name': 'Watches', 'icon': Icons.watch_rounded},
    {'name': 'Bags', 'icon': Icons.shopping_bag_rounded},
    {'name': 'Jewellery', 'icon': Icons.diamond_rounded},
    {'name': 'Home', 'icon': Icons.chair_rounded},
    {'name': 'Fitness', 'icon': Icons.fitness_center_rounded},
    {'name': 'Backpacks', 'icon': Icons.backpack_rounded},
    {'name': 'Gifts', 'icon': Icons.card_giftcard_rounded},
  ];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Classic Denim Jacket',
      'category': 'Fashion',
      'price': 1799,
      'rating': 4.6,
      'icon': Icons.checkroom_rounded,
    },
    {
      'name': 'Wireless Headphones',
      'category': 'Electronics',
      'price': 1499,
      'rating': 4.8,
      'icon': Icons.headphones_rounded,
    },
    {
      'name': 'Daily Glow Face Serum',
      'category': 'Beauty',
      'price': 699,
      'rating': 4.5,
      'icon': Icons.face_retouching_natural,
    },
    {
      'name': 'Classic Wrist Watch',
      'category': 'Watches',
      'price': 1999,
      'rating': 4.7,
      'icon': Icons.watch_rounded,
    },
    {
      'name': 'Everyday Tote Bag',
      'category': 'Bags',
      'price': 899,
      'rating': 4.4,
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'name': 'Elegant Jewellery Set',
      'category': 'Jewellery',
      'price': 1299,
      'rating': 4.6,
      'icon': Icons.diamond_rounded,
    },
    {
      'name': 'Modern Table Lamp',
      'category': 'Home',
      'price': 1199,
      'rating': 4.3,
      'icon': Icons.chair_rounded,
    },
    {
      'name': 'Fitness Dumbbells',
      'category': 'Fitness',
      'price': 799,
      'rating': 4.5,
      'icon': Icons.fitness_center_rounded,
    },
    {
      'name': 'Travel Backpack',
      'category': 'Backpacks',
      'price': 999,
      'rating': 4.8,
      'icon': Icons.backpack_rounded,
    },
    {
      'name': 'Gift Hamper',
      'category': 'Gifts',
      'price': 1499,
      'rating': 4.7,
      'icon': Icons.card_giftcard_rounded,
    },
  ];

  final Set<String> favoriteProducts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Welcome Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cartify",
                            style: TextStyle(
                              fontSize: 26,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Discover Products",
                            style: TextStyle(
                              fontSize: 16,

                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.iconBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 26,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                //Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Search products, brands...",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                //Categories Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        debugPrint("View All Pressed!");
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: GridView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 76,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            debugPrint('${category['name']} Pressed!');
                            selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedCategoryIndex == index
                                ? AppColors.primary
                                : AppColors.softPeach,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                category['icon'] as IconData,
                                size: 24,
                                color: selectedCategoryIndex == index
                                    ? Colors.white
                                    : const Color(0xFF744936),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                category['name'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selectedCategoryIndex == index
                                      ? Colors.white
                                      : const Color(0xFF744936),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Featured Products Header
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Featured Products",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        debugPrint("See All Products Pressed!");
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    product['icon'] as IconData,
                                    size: 50,
                                    color: AppColors.primary,
                                  ),
                                ),

                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        final productName =
                                            product['name'] as String;

                                        if (favoriteProducts.contains(
                                          productName,
                                        )) {
                                          favoriteProducts.remove(productName);
                                        } else {
                                          favoriteProducts.add(productName);
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      favoriteProducts.contains(product['name'])
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color:
                                          favoriteProducts.contains(
                                            product['name'],
                                          )
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            product['category'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            product['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${product['price']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFB800),
                                    size: 16,
                                  ),
                                  Text(
                                    '${product['rating']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
