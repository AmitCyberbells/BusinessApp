import 'package:business_app/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SelectBusinessTypeScreen extends StatefulWidget {
  @override
  _SelectBusinessTypeScreenState createState() =>
      _SelectBusinessTypeScreenState();
}

class _SelectBusinessTypeScreenState extends State<SelectBusinessTypeScreen> {
  List<String> businessTypes = [
    'Food and Beverage',
    'Retail and Shopping',
    'Health and wellness',
    'Entertainment and Leisure',
    'Hospitality and Travel',
    'Personal Services',
    'Education and Learning',
    'Events and Experience',
    'Automotive and Transportation',
  ];
  String? selectedBusinessType;
  bool isDropdownOpen = false;

  final int currentStep = 1;
  final int totalSteps = 4;

  @override
  void initState() {
    super.initState();
    // No API call, businessTypes is already populated with fallback values
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
              CustomDropdown(
                selectedItem: selectedBusinessType,
                hintText: 'Select your business type',
                isOpen: isDropdownOpen,
                onTap: () {
                  setState(() {
                    isDropdownOpen = !isDropdownOpen;
                  });
                },
              ),
              if (isDropdownOpen)
                CustomDropdownMenu(
                  items: businessTypes,
                  selectedItem: selectedBusinessType,
                  onSelect: (value) {
                    setState(() {
                      selectedBusinessType = value;
                      isDropdownOpen = false;
                    });
                  },
                ),

              Spacer(),

              // Help button
              buildHelpButton(
                onPressed: () {
                  // Help functionality
                },
              ),

              SizedBox(height: 16),

              // Next button
              AppConstants.fullWidthButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/business-detail');
                },
                text: 'Next', // Editable text
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
