import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SetUpCollaboration extends StatefulWidget {
  @override
  _SetUpCollaborationState createState() => _SetUpCollaborationState();
}

class _SetUpCollaborationState extends State<SetUpCollaboration> {
  bool termsAccepted = false;
  
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
                        'Set Up Collaboration',
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
              
              SizedBox(height: 24),
              
              // Collaboration Details section
              const Text(
                'Collaboration Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              
              SizedBox(height: 24),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Describe your collaboration request',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'We are looking for ...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
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
                        maxLines: 6,
                      ),
                      
                      const SizedBox(height: 24),
                      const Text(
                        'Set Duration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Date Row
                      Row(
                        children: [
                          // Start Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Campaign Start Date',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      border: InputBorder.none,
                                    ),
                                    value: '1 March 2025',
                                    items: [
                                      DropdownMenuItem(
                                        value: '1 March 2025',
                                        child: Text('1 March 2025'),
                                      ),
                                    ],
                                    onChanged: (value) {},
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your promo will start on 1 march, 2025 at 04:30 pm. You can stop this offer at any time.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(width: 16),
                          
                          // End Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Campaign End Date',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      border: InputBorder.none,
                                    ),
                                    value: '1 March 2025',
                                    items: [
                                      DropdownMenuItem(
                                        value: '1 March 2025',
                                        child: Text('1 March 2025'),
                                      ),
                                    ],
                                    onChanged: (value) {},
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your promo will end on 1 May, 2025 at 04:30 pm. You can stop this offer at any time.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      const Text(
                        'Target Audience',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            border: InputBorder.none,
                          ),
                          value: 'Demographics, Interests',
                          items: [
                            DropdownMenuItem(
                              value: 'Demographics, Interests',
                              child: Text('Demographics, Interests'),
                            ),
                          ],
                          onChanged: (value) {},
                          icon: Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,
                        ),
                      ),
                      
                      const SizedBox(height: 80),
                      
                      // Terms and Conditions
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: termsAccepted,
                              onChanged: (bool? value) {
                                setState(() {
                                  termsAccepted = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  children: [
                                    TextSpan(text: 'I\'ve read and agree with the '),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                        color: Color(0xFF1F6E8C),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(text: ' and the '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: Color(0xFF1F6E8C),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: termsAccepted ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F6E8C),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey.shade400,
                  ),
                  child: const Text(
                    'Create',
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