import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OwnerDetailsScreen extends StatelessWidget {
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
      InputDecoration _inputDecoration(String hintText, FocusNode focusNode) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: focusNode.hasFocus ? const Color.fromRGBO(11,106,136,1) : Colors.grey.shade300),
      ),
    );
  }
  }

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
    // White background for the inner gap effect
    Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    ),

    // Background grey circle (representing the incomplete portion - 25%)
    SizedBox(
      width: 45,
      height: 45,
      child: CircularProgressIndicator(
        value: 1.0, // Full circle
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
        strokeWidth: 4,
        strokeCap: StrokeCap.butt,
      ),
    ),

    // White shadow at the starting point (1%)
    Transform.rotate(
      angle: 3.14 * 2 * 0.0, // Start at 0 degrees (top center)
      child: SizedBox(
        width: 45,
        height: 45,
        child: CircularProgressIndicator(
          value: 0.1, // 1% progress for starting white shadow
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 4,
          strokeCap: StrokeCap.butt,
        ),
      ),
    ),
 
    // Main progress indicator with teal color (75%)
    Transform.rotate(
      angle: 3.14 * 2 * 0.03, // Start at 1% (clockwise)
      child: SizedBox(
        width: 45,
        height: 45,
        child: CircularProgressIndicator(
          value: 0.75, // 75% progress
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5F6B)), // Teal color
          strokeWidth: 4,
          strokeCap: StrokeCap.butt,
        ),
      ),
    ),

    // White shadow at the ending point (1%)
    Transform.rotate(
      angle: 3.14 * 2 * 0.77, // Rotate to the end of teal progress
      child: SizedBox(
        width: 45,
        height: 45,
        child: CircularProgressIndicator(
          value: 0.03, // 1% progress for ending white shadow
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 4,
          strokeCap: StrokeCap.butt,
        ),
      ),
    ),

    // Small white circle overlay to create inner gap
    Container(
      width: 41,
      height: 41,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    ),

    // Pure white background for the text
    Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    ),

    // Text centered inside the ring
    Text(
      '3 of 4',
      style: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.5,
      ),
    ),
  ],
)

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
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter Full Name',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Email Address',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter Email Address',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Enter Password',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                      icon: Icon(
                        LucideIcons.helpCircle,
                        color: Colors.white,
                      ),
                      // icon: Icon(Icons.help_outline, size: 16, color: Colors.white),
                      label:
                          Text('Help', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(11, 106, 136, 1),
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
                      backgroundColor: const Color.fromRGBO(11, 106, 136, 1),
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
