import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddMenu2Screen extends StatefulWidget {
  final String name;
  final int categoryId;
  final String description;
  final String price;
  final bool isAvailable;

  const AddMenu2Screen({
    Key? key,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.isAvailable,
  }) : super(key: key);

  @override
  State<AddMenu2Screen> createState() => _AddMenu2ScreenState();
}

class _AddMenu2ScreenState extends State<AddMenu2Screen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleAddItem() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a photo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final businessId = prefs.getString('business_id');
      if (token == null || businessId == null) {
        throw Exception('Authentication or business ID not found');
      }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://dev.frequenters.com/api/business/create-menu'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add all fields to request
      final fields = {
        'name': widget.name,
        'description': widget.description,
        'price': widget.price,
        'availability_status': widget.isAvailable ? '1' : '0',
        'business_id': businessId,
        'category_id': widget.categoryId.toString(),
        // Try alternative field names that backend might expect
        'category': widget.categoryId.toString(),
        'menu_category_id': widget.categoryId.toString(),
      };

      print('Request fields:');
      fields.forEach((key, value) {
        print('$key: $value');
        request.fields[key] = value;
      });

      print('Request fields after adding:');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });

      if (_imageFile != null) {
        final photo =
            await http.MultipartFile.fromPath('photo', _imageFile!.path);
        print('Adding photo: ${photo.filename}');
        request.files.add(photo);
      }

      print('Sending request to: ${request.url}');
      print('Headers: ${request.headers}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Menu item added successfully'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        final errorMsg = response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add menu: $errorMsg'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
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
          'Add Item',
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
              'Upload Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload Business Logo',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleAddItem,
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
}
