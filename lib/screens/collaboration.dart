import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Collaboration extends StatelessWidget {
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
              // Header with back button and title
              Row(
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
                  
                  // Centered title
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Collaboration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Empty space to balance the layout
                  SizedBox(width: 40),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Business Information section header
              const Text(
                'Business Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              
              SizedBox(height: 20),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Business Name',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: '1 March 2025',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      const Text(
                        'Business Type',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: '1 March 2025',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      const Text(
                        'Location',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: '1 March 2025',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: Icon(LucideIcons.mapPin, color: Colors.black),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      const Text(
                        'Contact Info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      const Text(
                        'Contact Person Name',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: '1 March 2025',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: '1 March 2025',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      
                      const SizedBox(height: 20),
                      const Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: '1 March 2025',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 20),
                      const Text(
                        'Website/Social Media Links(Optional)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: '1 March 2025',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add navigation logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F6E8C), // Teal blue color from the image
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}