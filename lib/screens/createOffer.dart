import 'package:flutter/material.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFF2F2F2),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const Spacer(),
                  const Text(
                    'Create Offer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Custom Offer',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              OfferCard(
                title: 'Build Your Offer',
                subtitle: 'Set an offer that works best for your business',
                buttonText: 'Create Offer',
                imagePath:
                    'assets/images/buildoffer.png', // Add image in assets
                    onPressed: () {
                      // Handle button press
                      Navigator.pushNamed(context, '/createOffer');
                    },
              ),
              const SizedBox(height: 24),
              const Text(
                'Recommended Offer for You',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              OfferCard(
                title: '30% Off up to \$80',
                subtitle: 'Grow your business with an offer',
                buttonText: 'Active Now',
                imagePath: 'assets/images/activateoffer.png',
                  onPressed: () {
                      // Handle button press
                      Navigator.pushNamed(context, '/createOffer');
                    },
              ),
              const SizedBox(height: 24),
              const Text(
                'Track Offer',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              OfferCard(
                title: '30% Off up to \$80',
                subtitle: 'Grow your business with an offer',
                buttonText: 'Track Offer',
                imagePath: 'assets/images/trackoffer.png',
                  onPressed: () {
                      // Handle button press
                      Navigator.pushNamed(context, '/createOffer');
                    },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imagePath;
  final VoidCallback onPressed;


  const OfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imagePath,
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 13)),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF125C6D),
                    foregroundColor:
                        Colors.white, // <-- Set text/icon color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
