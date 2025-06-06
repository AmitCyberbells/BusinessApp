import 'package:flutter/material.dart';
import 'package:business_app/screens/constants.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1F5F6B),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Application Submitted',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F5F6B),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your application is in review. We\'ll reach out soon—meanwhile, grab a coffee and relax!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              buildHelpButton(
                onPressed: () {
                  // Help functionality
                },
              ),
              const SizedBox(height: 16),
              AppConstants.fullWidthButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/track-application');
                },
                text: 'Track Application',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
