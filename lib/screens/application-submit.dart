// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';


class ApplicationSubmittedScreen extends StatelessWidget {
  const ApplicationSubmittedScreen({Key? key}) : super(key: key);

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
                          'assets/images/application-submited.png',
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
    'Application Submitted',
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
        'Your application is in review. We’ll reach out soon—meanwhile, grab a coffee and relax!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 22 / 14, // Line height calculated as a multiple of font size
          letterSpacing: 0,
          color: Color(0xFF718096),
        ),
      ),
    ),
  ),
)
,
                        const SizedBox(height: 144),
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
                      backgroundColor: Color.fromRGBO(11,106,136,1),
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
                      
                        const SizedBox(height: 24),
                        
                        // Track application button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Password reset logic would go here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(11, 106, 136, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                             
       
                            child: const Text(
                              'Track Application',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Back to Login link
                       
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