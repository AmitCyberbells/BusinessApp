import 'package:business_app/screens/email-sent.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

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
                    // Image container with responsive sizing
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 244,
                          maxHeight: 204,
                        ),
                        child: Image.asset(
                          'assets/images/forgot-pass.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Text and form section with flexible height
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(37,56,77,1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enter your email below and we\'ll get you back into your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Email input field
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            border: OutlineInputBorder(
                             
                              borderRadius: BorderRadius.circular(8.0),
                             
                            ),
                            focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: const Color.fromRGBO(11,106,136,1)), // Change this color to what you want
    ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        
                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Password reset logic would go here
                              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailSent()),
                  );
                              
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(11, 106, 136, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Back to Login link
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Back to ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(113, 114, 122, 1),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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