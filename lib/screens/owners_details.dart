import 'package:business_app/screens/constants.dart';
import 'package:business_app/services/business_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class OwnerDetailsScreen extends StatefulWidget {
  const OwnerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final TextEditingController _ownerNameController =
      TextEditingController();
  final TextEditingController _ownerEmailController =
      TextEditingController();
  final TextEditingController _ownerPhoneController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
    passwordController.dispose();
    super.dispose();
    confirmPasswordController.dispose();
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
                      color: Colors.grey.shade100,
                    ),
                    child: IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                    ),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFieldLabel('Enter Full Name'),
                      customTextField(
                        hintText: 'Enter Full Name',
                      ),
                      const SizedBox(height: 10),
                      buildFieldLabel('Email Address'),
                      customTextField(
                        hintText: 'Enter Email Address',
                      ),
                      const SizedBox(height: 10),
                      buildFieldLabel('Enter Password'),
                      const SizedBox(height: 6),
                      customTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: _passwordVisible,
                        icon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            color: const Color.fromRGBO(143, 144, 152, 1),
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildFieldLabel('Confirm Password'),
                      customTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: _passwordVisible,
                        icon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            color: const Color.fromRGBO(143, 144, 152, 1),
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ],
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
                onPressed: () {
                  context.read<BusinessRegistrationProvider>().setOwnerDetails(
                    name:_ownerNameController.text,
                    email: _ownerEmailController.text,
                    phone: _ownerPhoneController.text,
                    pwd: passwordController.text,
                    
                  );
                  Navigator.pushNamed(context, '/business-logo');
                },
                text: 'Next', // Editable text
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFieldLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
      );

  Widget buildTextField(String hintText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
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
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
