import 'package:flutter/material.dart';
import 'constants.dart'; // Make sure this is your constants.dart path

class UpdateOwnerDetailsScreen extends StatefulWidget {
  const UpdateOwnerDetailsScreen({super.key});

  @override
  State<UpdateOwnerDetailsScreen> createState() =>
      _UpdateOwnerDetailsScreenState();
}

class _UpdateOwnerDetailsScreenState extends State<UpdateOwnerDetailsScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Update Owner Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Full Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            customTextField(
              controller: fullNameController,
              hintText: 'Full Name',
            ),
            const SizedBox(height: 20),

            const Text(
              'Email Address',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            customTextField(
              controller: emailController,
              hintText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            const Text(
              'Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            customTextField(
              controller: phoneController,
              hintText: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            const Spacer(),
            AppConstants.fullWidthButton(
              text: 'Save',
              onPressed: () {
                // Handle save logic here
                debugPrint("Saved");
              },
            ),
          ],
        ),
      ),
    );
  }
}
