import 'package:business_app/screens/constants.dart';
import 'package:business_app/services/business_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_back_button.dart';
import 'business_logo.dart';

class OwnerDetailsScreen extends StatefulWidget {
  const OwnerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  void _handleNext() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set owner details in provider
      context.read<BusinessRegistrationProvider>().setOwnerDetails(
            name: _ownerNameController.text,
            email: _ownerEmailController.text,
            phone: _ownerPhoneController.text,
          );

      // Navigate to business logo screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrandingScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const CustomBackButton(),
                  ),

                  const Text(
                    'Owner Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Custom progress ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.shade300),
                          strokeWidth: 4,
                        ),
                      ),
                      Transform.rotate(
                        angle: 3.14 * 2 * 0.03,
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: const CircularProgressIndicator(
                            value: 0.75,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1F5F6B)),
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
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

              const SizedBox(height: 40),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildFieldLabel('Enter Full Name'),
                        customTextField(
                          controller: _ownerNameController,
                          hintText: 'Enter Full Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        buildFieldLabel('Email Address'),
                        customTextField(
                          controller: _ownerEmailController,
                          hintText: 'Enter Email Address',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        buildFieldLabel('Phone Number'),
                        customTextField(
                          controller: _ownerPhoneController,
                          hintText: '+1 000 000 0000',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!RegExp(r'^\+?1?\d{10}$')
                                .hasMatch(value.replaceAll(' ', ''))) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Help button
              buildHelpButton(
                onPressed: () {
                  // Help functionality
                },
              ),
              const SizedBox(height: 16),
              AppConstants.fullWidthButton(
                onPressed: _handleNext,
                text: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      );
}
