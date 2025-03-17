import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SelectBusinessTypeScreen extends StatefulWidget {
  @override
  _SelectBusinessTypeScreenState createState() => _SelectBusinessTypeScreenState();
}

class _SelectBusinessTypeScreenState extends State<SelectBusinessTypeScreen> {
  final List<String> businessTypes = [
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

  String? selectedBusinessType; // Removed default value to use placeholder
  bool isDropdownOpen = false;
  final int currentStep = 1;
  final int totalSteps = 4;

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
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: 0.25, // 25% progress (1 of 4)
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5F6B)),
                          strokeWidth: 4,
                        ),
                      ),
                      Text(
                        '$currentStep of $totalSteps',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1F5F6B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Container(
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
                  child: ListView.separated(
                    padding: const EdgeInsets.all(14.0),
                    shrinkWrap: true,
                    itemCount: businessTypes.length,
                    separatorBuilder: (context, index) => SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final type = businessTypes[index];
                      final isSelected = selectedBusinessType == type;
                      
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedBusinessType = type;
                            isDropdownOpen = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFEAF5F7) : Colors.transparent,
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
                                    color: isSelected ? Color(0xFF1F5F6B) : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  color: isSelected ? Color(0xFF1F5F6B) : Colors.transparent,
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
                                  color: isSelected ? Color(0xFF1F5F6B) : Colors.grey.shade700,
                                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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
              
              Spacer(),
              
              // Help button
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 36,
                  child: ElevatedButton.icon(
                    icon: Icon(LucideIcons.helpCircle, color: Colors.white, size: 18),
                    label: Text('Help', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1F5F6B),
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
                  onPressed: selectedBusinessType != null ? () {
                    Navigator.pushNamed(context, '/business-details');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1F5F6B),
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