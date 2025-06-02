import 'package:business_app/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessInfoScreen extends StatefulWidget {
  @override
  _BusinessInfoScreenState createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _socialMediaController = TextEditingController();

  // Controllers for location data
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  String _latitude = '';
  String _longitude = '';

  final String baseUrl = 'https://dev.frequenters.com';
  String? _token;
  String? _businessId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTokenAndBusinessId().then((_) {
      if (_token != null && _businessId != null) {
        _fetchBusinessDetails();
      }
    });
  }

  Future<void> _loadTokenAndBusinessId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token');
      _businessId = prefs.getString('business_id');
    });
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _socialMediaController.dispose();
    _address1Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _fetchBusinessDetails() async {
    if (_token == null || _businessId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/business-detail/$_businessId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Access nested "business" object
          final business = data['business'] ?? {};
          _businessNameController.text = business['name'] ?? '';
          _emailController.text = business['email'] ?? '';
          _phoneController.text = business['phone']?.toString() ?? '';
          _websiteController.text = business['website']?.toString() ?? '';
          _socialMediaController.text = business['social_links']?.toString() ?? '';

          // Access nested "business_address" list
          final addressList = data['business_address'] as List<dynamic>?;
          if (addressList != null && addressList.isNotEmpty) {
            final address = addressList[0];
            _address1Controller.text = address['address1']?.toString() ?? '';
            _cityController.text = address['city']?.toString() ?? '';
            _stateController.text = address['state']?.toString() ?? '';
            _countryController.text = address['country']?.toString() ?? '';
            _zipCodeController.text = address['zip_code']?.toString() ?? '';
            _latitude = address['latitude']?.toString() ?? '';
            _longitude = address['longitude']?.toString() ?? '';
          } else {
            // Default to empty if no address data
            _address1Controller.text = '';
            _cityController.text = '';
            _stateController.text = '';
            _countryController.text = '';
            _zipCodeController.text = '';
            _latitude = '';
            _longitude = '';
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch business details')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateBusinessProfile() async {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication token not found')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_businessNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter business name')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_emailController.text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/business/update-profile'),
      );

      request.headers['Authorization'] = 'Bearer $_token';
      // Remove incorrect Content-Type for MultipartRequest
      // request.headers['Content-Type'] = 'application/json';

      request.fields['name'] = _businessNameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['address1'] = _address1Controller.text;
      request.fields['city'] = _cityController.text;
      request.fields['state'] = _stateController.text;
      request.fields['country'] = _countryController.text;
      request.fields['zip_code'] = _zipCodeController.text;
      request.fields['latitude'] = _latitude;
      request.fields['longitude'] = _longitude;
      request.fields['website'] = _websiteController.text;
      request.fields['social_links'] = _socialMediaController.text;

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } else {
        print('Update failed: ${response.statusCode}, Body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/profile_bg.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -45,
                        left: 0,
                        right: 120,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: const Color.fromRGBO(11, 106, 136, 1),
                              child: Text(
                                _businessNameController.text.isNotEmpty
                                    ? _businessNameController.text[0].toUpperCase()
                                    : 'B',
                                style: TextStyle(fontSize: 40, color: Colors.white),
                              ),
                            ),
                            
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  // Upload image functionality
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 60 + 45)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Business Name',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        customTextField(
                          hintText: 'Business Name',
                          controller: _businessNameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter business name' : null,
                        ),
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email Address',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        customTextField(
                          hintText: 'Enter Email Address',
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter email address';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Phone Number',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        customTextField(
                          hintText: '+1 000 000 0000',
                          controller: _phoneController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter phone number' : null,
                        ),
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Location',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        // const SizedBox(height: 8),
                        // customTextField(
                        //   hintText: 'Address Line 1',
                        //   controller: _address1Controller,
                        // ),
                        // const SizedBox(height: 8),
                        // customTextField(
                        //   hintText: 'City',
                        //   controller: _cityController,
                        // ),
                        // const SizedBox(height: 8),
                        // customTextField(
                        //   hintText: 'State',
                        //   controller: _stateController,
                        // ),
                        // const SizedBox(height: 8),
                        // customTextField(
                        //   hintText: 'Country',
                        //   controller: _countryController,
                        // ),
                        // const SizedBox(height: 8),
                        // customTextField(
                        //   hintText: 'Zip Code',
                        //   controller: _zipCodeController,
                        // ),
                        // const SizedBox(height: 16),
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text('Website',
                        //       style: TextStyle(
                        //           fontSize: 14, fontWeight: FontWeight.bold)),
                        // ),
                        const SizedBox(height: 8),
                        customTextField(
                            hintText: 'www.abc.com', controller: _websiteController),
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Social Media Links',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _socialMediaController,
                          decoration: InputDecoration(
                            hintText: 'Paste link',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppConstants.fullWidthButton(
                          onPressed: _updateBusinessProfile,
                          text: 'Save',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}