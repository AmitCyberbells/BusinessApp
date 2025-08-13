import 'package:business_app/screens/service_availability.dart';
import 'package:flutter/material.dart';
import 'service_category.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:business_app/screens/OpeningHoursScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Added for json.encode

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  String _selectedCategoryName = '';
  String _selectedCategoryId = '';
  File? _imageFile;
  List<Map<String, dynamic>>? _availabilityList; // Added for availability list

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
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
          'Add Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                hintText: 'example',
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
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceCategoryScreen(),
                  ),
                );
                if (result != null && result is Map) {
                  setState(() {
                    _selectedCategoryId = result['id'].toString();
                    _selectedCategoryName = result['name'];
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategoryName.isEmpty
                          ? 'Select Category'
                          : _selectedCategoryName,
                      style: TextStyle(
                        color: _selectedCategoryName.isEmpty
                            ? Colors.grey[600]
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
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
              'Duration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                hintText: 'e.g. 30 mins, 1 hour',
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
            _buildPhotoPicker(),
            const SizedBox(height: 24),
            TextField(
              controller: _availabilityController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'e.g., 10 AM - 8 PM',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OpeningHoursScreen(),
                  ),
                );
                if (result != null && result is List) {
                  // Changed to List
                  setState(() {
                    _availabilityList =
                        List<Map<String, dynamic>>.from(result); // Set the list
                    _availabilityController.text =
                        jsonEncode(_availabilityList); // Set the text field
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    await _handleAddService();
                  }
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

  bool _validateForm() {
    if (_nameController.text.isEmpty) {
      _showError('Please enter service name');
      return false;
    }
    if (_selectedCategoryId.isEmpty) {
      _showError('Please select a category');
      return false;
    }
    if (_durationController.text.isEmpty) {
      _showError('Please enter service duration');
      return false;
    }
    if (_priceController.text.isEmpty) {
      _showError('Please enter price');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 32, color: Colors.teal[700]),
                  SizedBox(height: 8),
                  Text('Upload The Photo',
                      style: TextStyle(color: Colors.grey)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!,
                    fit: BoxFit.cover, width: double.infinity),
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _handleAddService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final businessId = prefs.getString('business_id');
      if (token == null || businessId == null) {
        _showError('Authentication token or business ID not found');
        return;
      }
      final url = 'https://dev.frequenters.com/api/business/service-post';
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields['business_id'] = businessId;
      request.fields['name'] = _nameController.text;
      request.fields['category_id'] = _selectedCategoryId;
      request.fields['description'] = _descriptionController.text;
      request.fields['duration'] = _durationController.text;
      request.fields['price'] = _priceController.text;
      // Add photo if selected
      if (_imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', _imageFile!.path));
      }
      // Add availability (hours) if provided
      if (_availabilityList != null) {
        request.fields['availability'] = json.encode(_availabilityList);
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Service post response: ${response.statusCode}');
      print('Service post body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        _showError('Failed to save: ${response.body}');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }
}
