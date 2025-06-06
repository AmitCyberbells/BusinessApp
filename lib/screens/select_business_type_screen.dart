// SelectBusinessTypeScreen.dart

import 'dart:convert';
import 'package:business_app/screens/constants.dart';
import 'package:business_app/services/business_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../widgets/custom_back_button.dart';

/// Simple model to hold a category and its children
class Category {
  final int id;
  final String name;
  final int? parentId;
  final List<Category> children;

  Category({
    required this.id,
    required this.name,
    required this.parentId,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int,
        name: json['name'] as String,
        parentId: json['parent_id'] as int?,
        children: (json['children'] as List<dynamic>?)
                ?.map((c) => Category.fromJson(c as Map<String, dynamic>))
                .toList() ??
            <Category>[],
      );
}

class SelectBusinessTypeScreen extends StatefulWidget {
  @override
  _SelectBusinessTypeScreenState createState() =>
      _SelectBusinessTypeScreenState();
}

class _SelectBusinessTypeScreenState extends State<SelectBusinessTypeScreen> {
  // API endpoint
  static const String _endpoint =
      'https://dev.frequenters.com/api/categories-list';

  /// Data lists
  List<Category> _parentCategories = [];
  List<Category> _childCategories = [];

  /// Selected values
  Category? _selectedBusinessType;
  Category? _selectedCategory;

  /// Dropdown open states
  bool _isBusinessTypeOpen = false;
  bool _isCategoryOpen = false;

  /// Loading / error flags
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  /// Fetch categories from the backend and populate parent list
  Future<void> _fetchCategories() async {
    try {
      final res = await http.get(Uri.parse(_endpoint));
      if (res.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(res.body) as List<dynamic>;
        final cats =
            decoded.map((c) => Category.fromJson(c as Map<String, dynamic>));
        setState(() {
          _parentCategories = cats.where((c) => c.parentId == null).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Status ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
        _isLoading = false;
      });
    }
  }

  /// When a parent is selected, update child categories
  void _onSelectParent(Category parent) {
    setState(() {
      _selectedBusinessType = parent;
      _selectedCategory = null;
      _childCategories = parent.children;
      _isBusinessTypeOpen = false;
    });
  }

  /// When a child category is selected
  void _onSelectChild(Category child) {
    setState(() {
      _selectedCategory = child;
      _isCategoryOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 40),

                        /// Business‑Type dropdown
                        const Text('Select Business Type',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          selectedItem: _selectedBusinessType?.name,
                          hintText: 'Select your business type',
                          isOpen: _isBusinessTypeOpen,
                          onTap: () => setState(() {
                            _isBusinessTypeOpen = !_isBusinessTypeOpen;
                            _isCategoryOpen = false;
                          }),
                        ),
                        if (_isBusinessTypeOpen)
                          CustomDropdownMenu(
                            items:
                                _parentCategories.map((c) => c.name).toList(),
                            selectedItem: _selectedBusinessType?.name,
                            onSelect: (value) {
                              final parent = _parentCategories
                                  .firstWhere((c) => c.name == value);
                              _onSelectParent(parent);
                            },
                          ),
                        const SizedBox(height: 10),

                        /// Category dropdown (child)
                        const Text('Select Business Category',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        CustomDropdown(
                          selectedItem: _selectedCategory?.name,
                          hintText: 'e.g. Café',
                          isOpen: _isCategoryOpen,
                          onTap: () => setState(() {
                            // Don't open if no parent selected
                            if (_selectedBusinessType != null) {
                              _isCategoryOpen = !_isCategoryOpen;
                              _isBusinessTypeOpen = false;
                            }
                          }),
                        ),
                        if (_isCategoryOpen)
                          CustomDropdownMenu(
                            items: _childCategories.map((c) => c.name).toList(),
                            selectedItem: _selectedCategory?.name,
                            onSelect: (value) {
                              final child = _childCategories
                                  .firstWhere((c) => c.name == value);
                              _onSelectChild(child);
                            },
                          ),

                        const Spacer(),

                        /// Help button
                        buildHelpButton(onPressed: () {
                          // TODO: Help action
                        }),
                        const SizedBox(height: 16),

                        /// Next button
                        // inside _SelectBusinessTypeScreenState build() -> Next button
                        AppConstants.fullWidthButton(
                          onPressed: () {
                            if (_selectedBusinessType == null ||
                                _selectedCategory == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please choose type and category')),
                              );
                              return;
                            }
                            context
                                .read<BusinessRegistrationProvider>()
                                .setCategory(
                                  parentId: _selectedBusinessType!.id,
                                  childId: _selectedCategory!.id,
                                );
                            Navigator.pushNamed(context, '/business-details');
                          },
                          text: 'Next',
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
      ),
    );
  }

  /// Header row with back, title, progress ring
  Widget _buildHeader(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const CustomBackButton(),
          ),

          // Title
          const Text(
            'Select Business Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // Progress ring (static, 1 of 4)
          _buildProgressRing(),
        ],
      );

  /// Small progress indicator ring
  Widget _buildProgressRing() => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              value: 1,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
              strokeWidth: 4,
            ),
          ),
          Transform.rotate(
            angle: 3.14 * 2 * 0.02,
            child: const SizedBox(
              width: 45,
              height: 45,
              child: CircularProgressIndicator(
                value: 0.23,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5F6B)),
                strokeWidth: 4,
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const Text(
            '1 of 4',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
            ),
          ),
        ],
      );
}
