import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Apne project ke actual import paths ke hisaab se check kar lein:
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ExplorerScreen2 extends StatefulWidget {
  const ExplorerScreen2({super.key});

  @override
  State<ExplorerScreen2> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen2> {
  @override
  void initState() {
    super.initState();
    // Screen khulte hi background me API se products fetch karne ke liye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Yahan apne ProductProvider ka class name use karein
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Products'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          // Jab user pull karega, yeh function call hoga aur API se data refresh hoga
          await Provider.of<ProductProvider>(
            context,
            listen: false,
          ).fetchProducts();
        },
        child: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            // 1. Agar data load ho raha hai toh CircularProgressIndicator dikhayein
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Agar loading khatam ho gayi aur products list khali hai
            if (provider.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Try checking your internet connection or refresh.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchProducts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // 3. Agar products successfully aa gaye hain toh Grid view dikhayein
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ProductCard(product: product);
              },
            );
          },
        ),
      ),
    );
  }
}
