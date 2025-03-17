import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BrandingScreen extends StatefulWidget {
  @override
  _BrandingScreenState createState() => _BrandingScreenState();
}

class _BrandingScreenState extends State<BrandingScreen> {
  bool agreeTerms = false;
  final int currentStep = 4;
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
                    'Branding (Optional)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  // Progress indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: 1, // 100% progress (3 of 4)
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5F6B)),
                          strokeWidth: 4,
                        ),
                      ),
                      Text(
                        '4 of 4',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1F5F6B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Upload Business Logo title
              Text(
                'Upload Business Logo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 10),
              
              // Upload container
              GestureDetector(
                onTap: () {
                  // Logic to handle file selection
                },
                child: Container(
                  height: 177,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                          ),
                          child: Icon(LucideIcons.upload, size: 24, color: Color(0xFF1F5F6B)),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Upload Business Logo',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Spacer(),
              
              // Terms and Conditions checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 50,
                    child: Checkbox(
                      value: agreeTerms,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(width: 1, color: Colors.grey.shade400),
                      onChanged: (value) {
                        setState(() {
                          agreeTerms = value ?? false;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I\'ve read and agree with the ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              color: Color(0xFF1F5F6B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ' and the '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF1F5F6B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Help button
              // Help button
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 26,
                  child: ElevatedButton.icon(
                     icon: Icon(LucideIcons.helpCircle ,color: Colors.white,),
                    // icon: Icon(Icons.help_outline, size: 16, color: Colors.white),
                    label: Text('Help', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1F5F6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
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
                height: 50,
                child: ElevatedButton(
                  onPressed: agreeTerms ? () {
                    // Navigator.pushNamed(context, '/dashboard');
                    Navigator.pushNamed(context, '/submitted');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1F5F6B),
                    disabledBackgroundColor: Color(0xFF1F5F6B).withOpacity(0.5),
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