import 'package:flutter/material.dart';

class ServiceCategoryScreen extends StatelessWidget {
  const ServiceCategoryScreen({Key? key}) : super(key: key);

  final List<String> _categories = const [
    'Haircut',
    'Carwash',
    'Health and wellness',
    'Entertainment and Leisure',
    'Hospitality and Travel',
    'Personal Services',
    'Education and Learning',
    'Events and Experience',
    'Automotive and Transportation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.pop(context, _categories[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: _categories[index],
                    groupValue: '',
                    onChanged: (value) => Navigator.pop(context, value),
                    activeColor: const Color(0xFF2F6D88),
                  ),
                  Text(
                    _categories[index],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
