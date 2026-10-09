import 'package:flutter/foundation.dart';
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

                //Categories Header
                SizedBox(height: 12),

                //Categories Row
              ],
            ),
          ),
        ),
      ),
    );
  }
}
