import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String name;
  final int? parentId;
  final List<Category> children;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    this.children = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
        name: json['name'] as String,
        parentId: json['parent_id'] as int?,
        children: (json['children'] as List<dynamic>?)
                ?.map((c) => Category.fromJson(c as Map<String, dynamic>))
                .toList() ??
            <Category>[],
      );
}

class ServiceCategoryScreen extends StatefulWidget {
  const ServiceCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ServiceCategoryScreen> createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('https://dev.frequenters.com/api/categories-list'));
      if (res.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(res.body) as List<dynamic>;
        setState(() {
          _categories = decoded
              .map((c) => Category.fromJson(c as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Status ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load categories: $e';
        _isLoading = false;
      });
    }
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
          'Add Service',
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
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                        Navigator.pop(context, {
                          'id': category.id,
                          'name': category.name,
                        });
                      },
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
                            Radio<int>(
                              value: category.id,
                              groupValue: _selectedCategory?.id,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                Navigator.pop(context, {
                                  'id': category.id,
                                  'name': category.name,
                                });
                              },
                              activeColor: const Color(0xFF2F6D88),
                            ),
                            Text(
                              category.name,
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
