import 'dart:io'; // For File class
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker

class BrandingScreen extends StatefulWidget {
  @override
  _BrandingScreenState createState() => _BrandingScreenState();
}

class _BrandingScreenState extends State<BrandingScreen> {
  bool agreeTerms = false;
  final int currentStep = 4;
  final int totalSteps = 4;
  File? _selectedImage; // Variable to store the selected image

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Use gallery as source

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Update the state with the selected image
      });
    }
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
                  Text(
                    'Branding (Optional)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.transparent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                          strokeWidth: 4,
                          strokeCap: StrokeCap.butt,
                        ),
                      ),
                      Transform.rotate(
                        angle: 3.14 * 2 * 0.0,
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            value: 0.1,
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 4,
                            strokeCap: StrokeCap.butt,
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: 3.14 * 2 * 0.02,
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1F5F6B)),
                            strokeWidth: 4,
                            strokeCap: StrokeCap.butt,
                          ),
                        ),
                      ),
                      Container(
                        width: 41,
                        height: 41,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '4 of 4',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Upload Business Logo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Upload container with image preview or upload prompt
              GestureDetector(
                onTap: _pickImage, // Call the image picker function
                child: Container(
                  height: 177,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade100,
                                ),
                                child: Icon(LucideIcons.upload,
                                    size: 24, color: Color(0xFF1F5F6B)),
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
                          )
                        : Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
              ),
              Spacer(),
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
                      activeColor: Color.fromRGBO(11, 106, 136, 1),
                      checkColor: Colors.white,
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
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 26,
                  child: ElevatedButton.icon(
                    icon: Icon(LucideIcons.helpCircle, color: Colors.white),
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: agreeTerms
                      ? () {
                          Navigator.pushNamed(context, '/submitted');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1F5F6B),
                    disabledBackgroundColor:
                        Color(0xFF1F5F6B).withOpacity(0.5),
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