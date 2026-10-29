import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../data/sample_products.dart';
import '../app/app_colors.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final wishlistProducts = SampleProducts.list
        .where((p) => cartProvider.isFavorite(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('WishListed Items')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Wishlist (${wishlistProducts.length})',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            wishlistProducts.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'No items in wishlist yet.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: wishlistProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: wishlistProducts[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
