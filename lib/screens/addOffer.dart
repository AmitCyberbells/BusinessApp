import 'dart:convert';

import 'package:business_app/screens/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AddOfferScreen extends StatefulWidget {
  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  // ──────────────────── STATE ────────────────────
  double _discount = 40;
  final List<String> _capOptions = ['No MAX CAP', r'$120', r'$100', r'$80', r'$60', r'$40'];
  String _selectedCap = r'$100';
  final List<String> _applicableOptions = ['New Users', 'Regular Users', 'Frequent Users'];
  String _selectedApplicable = 'Frequent Users';
  String _selectedSlot = 'All Day';
  String _selectedRunRange = 'Mon–Thu';
  DateTime? _startDate;
  DateTime? _endDate;
  String _startDateLabel = 'Start Date';
  String _endDateLabel = 'End Date';
  bool _agree = false;

  // Controllers for text fields
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // File for banner upload
  File? _bannerImage;

  // Token for authorization
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load token from SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token');
    });
    if (_token == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Pick image for banner
  Future<void> _pickBannerImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _bannerImage = File(pickedFile.path);
        });
        print('Image selected: ${pickedFile.path}');
      } else {
        print('No image selected');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Fetch business_id dynamically
  Future<String> _fetchBusinessId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = _token ?? prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    // Try multiple endpoints to fetch business_id
    final possibleEndpoints = [
      'https://dev.frequenters.com/api/me', // Likely to return user profile with business_id
      'https://dev.frequenters.com/api/business', // List of businesses
      'https://dev.frequenters.com/api/business/65', // Specific business details
    ];

    String? businessId;
    String? lastError;

    for (var endpoint in possibleEndpoints) {
      try {
        final response = await http.get(
          Uri.parse(endpoint),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        print('Fetch business_id from $endpoint - status: ${response.statusCode}');
        print('Fetch business_id response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          // Try different possible keys for business_id
          businessId = data['business_id']?.toString() ??
              data['id']?.toString() ??
              data['business']?['id']?.toString() ??
              data['business']?['business_id']?.toString() ??
              data['business_profile']?['business_id']?.toString() ??
              (data is List && data.isNotEmpty ? data[0]['business_id']?.toString() : null);
          if (businessId != null) {
            await prefs.setString('business_id', businessId);
            print('Business ID fetched and saved from $endpoint: $businessId');
            return businessId;
          } else {
            lastError = 'No business_id found in response';
          }
        } else {
          lastError = response.body;
        }
      } catch (e) {
        lastError = e.toString();
        print('Error fetching business_id from $endpoint: $e');
      }
    }

    // Fallback to stored business_id from login if all endpoints fail
    businessId = prefs.getString('business_id');
    if (businessId != null) {
      print('Falling back to stored business_id: $businessId');
      return businessId;
    }

    throw Exception('Failed to fetch business_id: $lastError');
  }

  // Get business_id with fallback to fetch
  Future<String> _getBusinessId() async {
    final prefs = await SharedPreferences.getInstance();
    String? businessId = prefs.getString('business_id');
    if (businessId == null) {
      print('Error: No business ID found in SharedPreferences');
      businessId = await _fetchBusinessId();
    } else {
      // Validate the business_id by fetching the latest
      try {
        final fetchedId = await _fetchBusinessId();
        if (fetchedId != businessId) {
          print('Warning: Stored business_id ($businessId) differs from fetched ($fetchedId)');
          businessId = fetchedId;
        }
      } catch (e) {
        print('Warning: Failed to validate business_id, using stored value: $e');
      }
    }

    if (businessId == null) {
      throw Exception('Business ID not available');
    }
    print('Fetched business_id: $businessId');
    return businessId;
  }

  // API POST request to submit the offer
  Future<void> _submitOffer() async {
    if (_token == null) {
      print('Error: No auth token found');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to continue')),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      print('Error: Start or end date missing');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }
    if (_bannerImage == null) {
      print('Error: No banner image selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a banner image')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://dev.frequenters.com/api/business/offers'),
    );

    request.headers['Authorization'] = 'Bearer $_token';
    print('Request headers: ${request.headers}');

    final formFields = {
      'business_id': await _getBusinessId(),
      'title': '${_discount.round()}% OFF up to ${_selectedCap == 'No MAX CAP' ? '\$80' : _selectedCap}',
      'discount_percentage': _discount.round().toString(),
      'discount_cap': _selectedCap == 'No MAX CAP' ? '120' : _selectedCap.replaceAll(r'$', ''),
      'applicable_users': _mapApplicableUsers(_selectedApplicable),
      'offer_time': _mapOfferTime(_selectedSlot),
      'campaign_start_date': DateFormat('yyyy-MM-dd').format(_startDate!),
      'campaign_start_time': '10:00:00',
      'campaign_end_date': DateFormat('yyyy-MM-dd').format(_endDate!),
      'campaign_end_time': '20:00:00',
      'applicable_days': _mapApplicableDays(_selectedRunRange),
      'min_order_value': '100',
      'terms_and_conditions': 'Offer applicable to all menu items.',
      'description': _descriptionController.text,
    };

    request.fields.addAll(formFields);
    print('Request fields: $formFields');

    try {
      request.files.add(await http.MultipartFile.fromPath('banner', _bannerImage!.path));
      print('Banner file added: ${_bannerImage!.path}');
    } catch (e) {
      print('Error adding banner file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding banner: $e')),
      );
      return;
    }

    try {
      print('Sending request to: ${request.url}');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Offer created successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create offer: ${response.statusCode} - $responseBody'),
          ),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Map display values to API values
  String _mapApplicableUsers(String displayValue) {
    switch (displayValue) {
      case 'New Users':
        return 'NEW';
      case 'Regular Users':
        return 'REGULAR';
      case 'Frequent Users':
        return 'FREQUENT';
      default:
        return displayValue.toUpperCase();
    }
  }

  String _mapApplicableDays(String displayValue) {
    switch (displayValue) {
      case 'Entire Week':
        return 'ALL';
      case 'Mon–Thu':
        return 'WEEKDAYS';
      case 'Fri–Sun':
        return 'WEEKENDS';
      default:
        return displayValue.toUpperCase().replaceAll('–', '_');
    }
  }

  String _mapOfferTime(String displayValue) {
    switch (displayValue) {
      case 'All Day':
        return 'all_day';
      case 'Morning Only':
        return 'morning';
      case 'Evening Only':
        return 'evening';
      default:
        return displayValue.toLowerCase().replaceAll(' ', '_');
    }
  }

  // ──────────────────── PICKERS ────────────────────
  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateLabel = DateFormat('d MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateLabel = DateFormat('d MMM yyyy').format(picked);
      });
    }
  }

  // ──────────────────── BUILD ────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/Back.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
        title: const Text(
          'Create New Offer',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Select Your Discount'),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${_discount.round()}% OFF',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: _selectedCap == 'No MAX CAP' ? '  (No Max Cap)' : '  up to $_selectedCap',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Slider(
              value: _discount,
              min: 0,
              max: 100,
              divisions: 5,
              label: '${_discount.round()}%',
              activeColor: Colors.teal,
              onChanged: (v) => setState(() => _discount = v),
            ),
            _chipRowCaps(
              items: _capOptions,
              selected: _selectedCap,
              onSelected: (v) => setState(() => _selectedCap = v),
            ),
            const SizedBox(height: 16),

            _sectionTitle('Discount Applicable'),
            _chipRowApplicable(
              items: _applicableOptions,
              selected: _selectedApplicable,
              onSelected: (v) => setState(() => _selectedApplicable = v),
            ),
            const SizedBox(height: 16),

            _sectionTitle('Select Time'),
            _chipRowTimeSlots(
              items: [
                {'label': 'All Day', 'subtext': '24 Hours'},
                {'label': 'Morning Only', 'subtext': '7–11 AM'},
                {'label': 'Evening Only', 'subtext': '12–3 PM'},
              ],
              selectedLabel: _selectedSlot,
              onSelected: (v) => setState(() => _selectedSlot = v),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _datePickerWithLabel(
                    label: 'Start Date',
                    date: _startDateLabel,
                    onTap: _pickStartDate,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _datePickerWithLabel(
                    label: 'End Date',
                    date: _endDateLabel,
                    onTap: _pickEndDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _sectionTitle('Run This Offer'),
            _chipSegment(
              items: ['Entire Week', 'Mon–Thu', 'Fri–Sun'],
              selected: _selectedRunRange,
              onSelected: (v) => setState(() => _selectedRunRange = v),
            ),
            const SizedBox(height: 16),

            _sectionTitle('Tagline'),
            customTextField(
              controller: _taglineController,
              hintText: 'Sip & Save! Limited-Time Offer!',
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter tagline' : null,
            ),
            const SizedBox(height: 16),

            _sectionTitle('Description'),
            customTextField(
              controller: _descriptionController,
              hintText: 'Write a Description',
              maxLines: 4,
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter description' : null,
            ),
            const SizedBox(height: 16),

            _sectionTitle('Upload Banner'),
            _bannerUploadArea(),
            const SizedBox(height: 16),

            _sectionTitle('Offer Details'),
            _offerDetail('• Offer Applicable for: All users in all menu items, excluding MRP items'),
            _offerDetail('• Minimum order value: \$90'),
            Row(
              children: [
                Checkbox(value: _agree, onChanged: (v) => setState(() => _agree = v!)),
                Flexible(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: "I've read and agree with the "),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' and the '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agree ? _submitOffer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF316A82),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Activate Offer', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────── WIDGET HELPERS ────────────────────
  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
        ),
      );

  Widget _chipRowCaps({
    required List<String> items,
    required String selected,
    required Function(String) onSelected,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = item == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => onSelected(item),
              selectedColor: Colors.teal.shade700,
              backgroundColor: const Color.fromRGBO(227, 239, 243, 1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
              side: const BorderSide(color: Color.fromRGBO(227, 239, 243, 1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _chipRowApplicable({
    required List<String> items,
    required String selected,
    required Function(String) onSelected,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = item == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => onSelected(item),
              selectedColor: Colors.teal.shade700,
              backgroundColor: const Color.fromRGBO(227, 239, 243, 1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
              visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
              side: const BorderSide(color: Color.fromRGBO(227, 239, 243, 1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _chipRowTimeSlots({
    required List<Map<String, String>> items,
    required String selectedLabel,
    required Function(String) onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(227, 239, 243, 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.map((item) {
            final isSelected = item['label'] == selectedLabel;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => onSelected(item['label']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          color: Color(0xFF115D77),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['subtext']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _bannerUploadArea() {
    return GestureDetector(
      onTap: _pickBannerImage,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: _bannerImage == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/upload.png', width: 40, height: 40),
                    const SizedBox(height: 8),
                    const Text('Upload Banner', style: TextStyle(color: Colors.grey)),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _bannerImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _offerDetail(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black)),
      );

  Widget _datePickerWithLabel({
    required String label,
    required String date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color.fromRGBO(197, 198, 204, 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: date.contains('Date')
                        ? const Color.fromRGBO(143, 144, 152, 1)
                        : Colors.black,
                    fontSize: 14,
                  ),
                ),
                Image.asset(
                  'assets/images/date.png',
                  width: 20,
                  height: 20,
                  color: const Color(0xFF8F9098),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chipSegment({
    required List<String> items,
    required String selected,
    required Function(String) onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EFF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isSelected = item == selected;
          return GestureDetector(
            onTap: () => onSelected(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A6B77),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget customTextField({
    TextEditingController? controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _taglineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}