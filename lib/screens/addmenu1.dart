import 'package:flutter/material.dart';
import 'package:business_app/screens/addmenu2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  final int id;
  final String name;
  final int? parentId;
  final List<Category> children;
  final List<Category> grandChildren;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    this.children = const [],
    this.grandChildren = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Category> parseChildren(List? childrenJson) {
      if (childrenJson == null) return [];
      return childrenJson.map((child) => Category.fromJson(child)).toList();
    }

    List<Category> children = [];
    if (json['children'] != null) {
      children = parseChildren(json['children'] as List);
    }

    List<Category> grandChildren = [];
    if (json['get_children_recursive'] != null) {
      grandChildren = parseChildren(json['get_children_recursive'] as List);
    }

    return Category(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] as String,
      parentId: json['parent_id'],
      children: children,
      grandChildren: grandChildren,
    );
  }
}

class AddMenu1Screen extends StatefulWidget {
  const AddMenu1Screen({Key? key}) : super(key: key);

  @override
  State<AddMenu1Screen> createState() => _AddMenu1ScreenState();
}

class _AddMenu1ScreenState extends State<AddMenu1Screen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Category? _selectedCategory;
  bool _isAvailable = true;
  bool _isLoading = true;
  String? _error;
  List<Category> _categories = [];
  List<Category> _flattenedCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  List<Category> _flattenCategories(List<Category> categories) {
    List<Category> flattened = [];
    for (var category in categories) {
      flattened.add(category);
      flattened.addAll(category.children);
      flattened.addAll(category.grandChildren);
    }
    return flattened;
  }

  Future<void> _fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('https://dev.frequenters.com/api/categories-list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Categories response: ${response.statusCode}');
      print('Categories body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.map((item) => Category.fromJson(item)).toList();
          _flattenedCategories = _flattenCategories(_categories);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load categories';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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
          'Add Item',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name of the item',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Matcha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) => _buildCategoryPicker(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCategory?.name ?? 'Select Category',
                                style: TextStyle(
                                  color: _selectedCategory == null
                                      ? Colors.grey[600]
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Write a Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Fixed or Ranges',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Availability Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: _isAvailable,
                            onChanged: (value) {
                              setState(() {
                                _isAvailable = value;
                              });
                            },
                            activeColor: const Color(0xFF2F6D88),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter item name'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (_selectedCategory == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a category'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (_priceController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter price'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            print('Selected category:');
                            print('ID: ${_selectedCategory!.id}');
                            print('Name: ${_selectedCategory!.name}');
                            print('Parent ID: ${_selectedCategory!.parentId}');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMenu2Screen(
                                  name: _nameController.text,
                                  categoryId: _selectedCategory!.id,
                                  description: _descriptionController.text,
                                  price: _priceController.text,
                                  isAvailable: _isAvailable,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2F6D88),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCategoryPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _flattenedCategories.map((category) {
          // Add indentation based on parent_id
          double leftPadding = category.parentId != null ? 32.0 : 16.0;
          if (category.parentId != null) {
            var parent = _flattenedCategories.firstWhere(
              (p) => p.id == category.parentId,
              orElse: () => category,
            );
            if (parent.parentId != null) {
              leftPadding = 48.0; // More indent for grandchildren
            }
          }

          return RadioListTile<Category>(
            title: Padding(
              padding: EdgeInsets.only(left: leftPadding),
              child: Text(
                category.name,
                style: TextStyle(
                  color: _selectedCategory?.id == category.id
                      ? Colors.black
                      : Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            value: category,
            groupValue: _selectedCategory,
            onChanged: (Category? value) {
              setState(() {
                _selectedCategory = value;
              });
              Navigator.pop(context);
            },
            activeColor: const Color(0xFF2F6D88),
            selected: _selectedCategory?.id == category.id,
            selectedTileColor: Colors.blue[50],
          );
        }).toList(),
      ),
    );
  }
}
