import 'package:flutter/material.dart';
import '../data/sample_products.dart';
import '../models/product.dart';
import '../app/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class ExploreScreen extends StatefulWidget {
  final String? initialCategory;

  const ExploreScreen({super.key, this.initialCategory});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late TextEditingController _searchController;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'Popular';

  final List<String> _categories = ['All', 'Electronics', 'Fashion', 'Shoes', 'Accessories', 'Home & Living'];
  final List<String> _sortOptions = ['Popular', 'Price: Low to High', 'Price: High to Low'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.initialCategory != null && _categories.contains(widget.initialCategory)) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    List<Product> list = SampleProducts.list.where((product) {
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (_sortBy == 'Price: Low to High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search & Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore Catalogue',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search products by name...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories horizontal list
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: _categories[index],
                    isSelected: _selectedCategory == _categories[index],
                    onTap: () => setState(() => _selectedCategory = _categories[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Count & Sort Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${products.length} items found',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted),
                  ),
                  DropdownButton<String>(
                    value: _sortBy,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.sort, size: 18, color: AppColors.primary),
                    items: _sortOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _sortBy = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Product Grid
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'No products found',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try adjusting your search or filters.',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}