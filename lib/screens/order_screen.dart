import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../app/app_colors.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final totalAmount = cartProvider.finalTotal;
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.mintGreen,
              child: Icon(Icons.check, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Order ID: $orderId',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank you for shopping with Cartify. Your demo order has been logged successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Paid (Demo)', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('₹${totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}