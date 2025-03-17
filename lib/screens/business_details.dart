import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BusinessDetailsScreen extends StatefulWidget {
  @override
  _BusinessDetailsScreenState createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final int currentStep = 2;
  final int totalSteps = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                      'Enter Business Details',
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
                            value: 0.5, // 50% progress (2 of 4)
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
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Enter Business Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter Business Name',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                              focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: const Color.fromRGBO(11,106,136,1)), // Change this color to what you want
    ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          
                        ),
                        const SizedBox(height: 10),
                        const Text('Business Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Business Address',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            suffixIcon: Icon(LucideIcons.mapPin, color: Colors.grey.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),

                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: const Color.fromRGBO(11,106,136,1)), // Change this color to what you want
    ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Phone Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '+1 000 000 0000',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: const Color.fromRGBO(11,106,136,1)), // Change this color to what you want
    ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 10),
                        const Text('Business Website (Optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'www.abc.com',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: const Color.fromRGBO(11,106,136,1)), // Change this color to what you want
    ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Select Business Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'e.g. Cafe',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: const Color.fromRGBO(11,106,136,1)), // Change this color to what you want
    ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          icon: Icon(LucideIcons.chevronDown, color: Colors.grey.shade700),
                          items: ['Cafe', 'Retail', 'Services', 'Entertainment']
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
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
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/owner-details');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1F5F6B),
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
                
                SizedBox(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}