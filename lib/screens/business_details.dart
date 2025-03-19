import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:geolocator/geolocator.dart';
class BusinessDetailsScreen extends StatefulWidget {
  @override
  _BusinessDetailsScreenState createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final int currentStep = 2;
  final int totalSteps = 4;

    // Add this:
  TextEditingController _locationController = TextEditingController();

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _locationController.text = "${position.latitude}, ${position.longitude}";
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

    // Background grey circle (representing the incomplete portion - 50%)
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

    // Main progress indicator with teal color (50%)
    Transform.rotate(
      angle: 3.14 * 2 * 0.02, // Start at 1% (clockwise)
      child: SizedBox(
        width: 45,
        height: 45,
        child: CircularProgressIndicator(
          value: 0.50, // 50% progress
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5F6B)), // Teal color
          strokeWidth: 4,
          strokeCap: StrokeCap.butt,
        ),
      ),
    ),

    // White shadow at the ending point (1%)
    Transform.rotate(
      angle: 3.14 * 2 * 0.52, // Rotate to the end of teal progress
      child: SizedBox(
        width: 45,
        height: 45,
        child: CircularProgressIndicator(
          value: 0.02, // 1% progress for ending white shadow
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
      '2 of 4',
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
  controller: _locationController,  // Add controller here
  decoration: InputDecoration(
    hintText: 'Business Address',
    hintStyle: TextStyle(color: Colors.grey.shade400),
    suffixIcon: GestureDetector(
      onTap: _getCurrentLocation,  // Trigger location picker
      child: Icon(LucideIcons.mapPin, color: Colors.grey.shade700),
    ),

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
                      backgroundColor: Color.fromRGBO(11,106,136,1),
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