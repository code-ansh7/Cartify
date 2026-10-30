import 'package:flutter/material.dart';

import '../app/app_colors.dart';

class GetDetails extends StatefulWidget {
  const new({super.key});

  @override
  State<GetDetails> createState() => _GetDetailsState();
}

class _GetDetailsState extends State<GetDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your Valid Details...',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
          
              Text(
                'Your entered details decides your order dilivery',
                style: TextStyle(color: AppColors.primaryVariant),
              ),
          
              SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: Text('Enter your Name'),
                  hintText: 'Enter your Name...',
                  prefixIcon: const Icon(
                    Icons.person_2,
                    color: AppColors.primary,
                  ),
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
          
              SizedBox(height: 20),
          
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  label: Text('Enter your Address'),
                  hintText: 'Enter your Address...',
                  prefixIcon: const Icon(
                    Icons.home_filled,
                    color: AppColors.primary,
                  ),
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
          
              SizedBox(height: 20),
          
              SizedBox(
                width: double.infinity,
                child: DropdownButton(
                  hint: Row(
                    children: [
                      SizedBox(width: 13),
                      Icon(Icons.payment_rounded, color: AppColors.primary),
                      SizedBox(width: 16),
          
                      Text('Select Payment Method'),
                    ],
                  ),
          
                  items: [
                    DropdownMenuItem(
                      value: 'Cash on Delivery',
                      child: Text('Cash on Delivery'),
                    ),
          
                    DropdownMenuItem(value: 'UPI', child: Text('UPI')),
          
                    DropdownMenuItem(value: 'Card', child: Text('Card')),
          
                    DropdownMenuItem(value: 'EMI', child: Text('EMI')),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
