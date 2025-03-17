import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OwnerDetailsScreen extends StatelessWidget {
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
                  const Text(
                    'Owner Details',
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
                          value: 0.75, // 75% progress (3 of 4)
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5F6B)),
                          strokeWidth: 4,
                        ),
                      ),
                      Text(
                        '3 of 4',
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
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Full Name',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: InputDecoration(
                          
                          hintText: 'Enter Full Name',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Email Address',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter Password',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Confirm Password',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),
              
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/business-logo');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(11,106,136,1),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
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
    ));
  }
}