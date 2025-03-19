import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectBusinessTypeScreen extends StatefulWidget {
  @override
  _SelectBusinessTypeScreenState createState() =>
      _SelectBusinessTypeScreenState();
}

class _SelectBusinessTypeScreenState extends State<SelectBusinessTypeScreen> {
  List<String> businessTypes = [];
  String? selectedBusinessType;
  bool isDropdownOpen = false;
  bool isLoading = true; // Track loading state
  bool hasError = false;
  final int currentStep = 1;
  final int totalSteps = 4;

  @override
  void initState() {
    super.initState();
    fetchBusinessTypes();
  }

  Future<void> fetchBusinessTypes() async {
  setState(() {
    isLoading = true;
    hasError = false;
  });

  try {
    final response =
        await http.get(Uri.parse('http://192.168.29.42:5001/business-types'));
    print('API Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if data is a List and assign it directly
      if (data is List) {
        setState(() {
          businessTypes = List<String>.from(data);
          isLoading = false;
        });
        print('Loaded business types: $businessTypes');
      } else {
        print('API response is not a list');
        _loadFallbackBusinessTypes();
      }
    } else {
      print('API request failed with status: ${response.statusCode}');
      _loadFallbackBusinessTypes();
    }
  } catch (e) {
    print('Error fetching business types: $e');
    _loadFallbackBusinessTypes();
  }
}

  void _loadFallbackBusinessTypes() {
    setState(() {
      isLoading = false;
      hasError = true;
      businessTypes = [
        'Food and Beverage',
        'Retail and Shopping',
        'Health and wellness',
        'Entertainment and Leisure',
        'Hospitality and Travel',
        'Personal Services',
        'Education and Learning',
        'Events and Experience',
        'Automotive and Transportation'
      ];
      print('Loaded fallback business types: $businessTypes');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button, title and progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                    ),
                    child: IconButton(
                      icon: Icon(LucideIcons.arrowLeft),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  // Title
                  Text(
                    'Select Business Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Circular Progress indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // White background for the inner gap effect
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),

                      // Background grey circle (representing the incomplete portion - 75%)
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(
                          value: 1.0, // Full circle
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.shade300),
                          strokeWidth: 4,
                          strokeCap: StrokeCap.butt,
                        ),
                      ),

                      // White shadow at the starting point (1%)
                      Transform.rotate(
                        angle:
                            3.14 * 2 * 0.0, // Start at 0 degrees (top center)
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            value: 0.1, // 1% progress for starting white shadow
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 4,
                            strokeCap: StrokeCap.butt,
                          ),
                        ),
                      ),

                      // Main progress indicator with teal color (23%)
                      Transform.rotate(
                        angle: 3.14 * 2 * 0.02, // Start at 1% (clockwise)
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            value: 0.23, // 23% progress
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1F5F6B)), // Teal color
                            strokeWidth: 4,
                            strokeCap: StrokeCap.butt,
                          ),
                        ),
                      ),

                      // White shadow at the ending point (1%)
                      Transform.rotate(
                        angle: 3.14 *
                            2 *
                            0.24, // Rotate to the end of teal progress
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            value: 0.02, // 1% progress for ending white shadow
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 4,
                            strokeCap: StrokeCap.butt,
                          ),
                        ),
                      ),

                      // Small white circle overlay to create inner gap
                      Container(
                        width: 41,
                        height: 41,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),

                      // Pure white background for the text
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),

                      // Text centered inside the ring
                      Text(
                        '1 of 4',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: 40),

              // Business Type Selection
              const Text(
                'Select Business Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Dropdown toggle button
              InkWell(
                onTap: () {
                  setState(() {
                    isDropdownOpen = !isDropdownOpen;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedBusinessType ?? 'Select Business Type',
                        style: TextStyle(
                          color: selectedBusinessType != null
                              ? Colors.black
                              : Colors.grey.shade500,
                        ),
                      ),
                      Icon(LucideIcons.chevronDown),
                    ],
                  ),
                ),
              ),

              // Dropdown menu - only visible when isDropdownOpen is true
              if (isDropdownOpen)
                isLoading
                    ? Container(
                        height: 100,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 60,
                              offset: Offset(6, 6),
                            ),
                          ],
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(
                        height: 250, // Fixed height for the dropdown
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 60,
                              offset: Offset(6, 6),
                            ),
                          ],
                        ),
                        child: businessTypes.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      hasError
                                          ? LucideIcons.alertCircle
                                          : LucideIcons.info,
                                      color:
                                          hasError ? Colors.red : Colors.grey,
                                      size: 24,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      hasError
                                          ? 'Error loading business types'
                                          : 'No business types found',
                                      style: TextStyle(
                                        color: hasError
                                            ? Colors.red
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextButton(
                                      onPressed: fetchBusinessTypes,
                                      child: Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(14.0),
                                shrinkWrap: true,
                                itemCount: businessTypes.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 9),
                                itemBuilder: (context, index) {
                                  final type = businessTypes[index];
                                  final isSelected =
                                      selectedBusinessType == type;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedBusinessType = type;
                                        isDropdownOpen = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color(0xFFEAF5F7)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          // Custom radio button
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? Color(0xFF1F5F6B)
                                                    : Colors.grey.shade400,
                                                width: 2,
                                              ),
                                              color: isSelected
                                                  ? Color(0xFF1F5F6B)
                                                  : Colors.transparent,
                                            ),
                                            child: isSelected
                                                ? Center(
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            type,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Color(0xFF1F5F6B)
                                                  : Colors.grey.shade700,
                                              fontWeight: isSelected
                                                  ? FontWeight.w500
                                                  : FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),

              // Display a message if API fails and dropdown is not open
              if (hasError && !isDropdownOpen && !isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Note: Using default business types',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              Spacer(),

              // Help button
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 36,
                  child: ElevatedButton.icon(
                    icon: Icon(LucideIcons.helpCircle,
                        color: Colors.white, size: 18),
                    label: Text('Help', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(11, 106, 136, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      // Help functionality
                    },
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedBusinessType != null
                      ? () {
                          Navigator.pushNamed(context, '/business-details');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(11, 106, 136, 1),
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
