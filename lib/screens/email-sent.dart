// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EmailSent extends StatelessWidget {
  const EmailSent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 88),
                    // Image container with responsive sizing
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 244,
                          maxHeight: 204,
                        ),
                        child: Image.asset(
                          'assets/images/email-sent.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Text and form section with flexible height
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Email Sent!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(37, 56, 77, 1),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Positioned(
                          top: 493,
                          left: 68,
                          child: SizedBox(
                            width: 293,
                            height: 44,
                            child: Center(
                              child: Text(
                                'We’ve sent a password reset link to your email. Use this link to change your password.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 22 /
                                      14, // Line height calculated as a multiple of font size
                                  letterSpacing: 0,
                                  color: Color.fromRGBO(113, 128, 150, 1),
                                ),
                              ),
                            ),
                          ),
                        ),

                     
                        // Add bottom padding to ensure enough space at the bottom
                        const SizedBox(height: 16),
                      ],
                    ),
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                      
                     Center(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RichText(
        text: TextSpan(
          text: 'Didn’t get a link? ',
          style: TextStyle(color: const Color.fromRGBO(113, 114, 122, 1)),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: TextButton(
                onPressed: () {
                  // Navigate to SignUpScreen
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove default padding
                  minimumSize: Size(0, 0), // Prevent extra space
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink button
                ),
                child: Text(
                  'Resend Link',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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


                        const SizedBox(height: 40),

                        const SizedBox(height: 24),

                        // Add bottom padding to ensure enough space at the bottom
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
