import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
// https://lucide.dev/icons/
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    
    return Scaffold(
            backgroundColor: Colors.white,

      appBar: AppBar(
        
        title: const Text('About Us'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
          
           
         Text.rich(
  TextSpan(
    children: [
      const TextSpan(
        text: "Welcome to ",
        style: TextStyle(fontSize: 14),
      ),
      TextSpan(
        text: "Frequenters",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold, // Bold style
        ),
      ),
      const TextSpan(
        text: " —the app that rewards you for supporting local businesses and discovering your community! Whether you're grabbing a cup of coffee at your favorite café, enjoying a meal at a local restaurant, or just exploring new shops in town, you can earn points every time you check in.",
        style: TextStyle(fontSize: 14),
      ),
    ],
  ),
),

       
            const Text(
              'Our mission is simple: to encourage people to explore their neighborhoods, support local businesses, and make the most of everyday moments. With Frequenters, each check-in brings you closer to exciting rewards and exclusive offers. The more you visit, the more you earn!',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 40),
            const Text(
              'Why Use Frequenters?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'Earn Points',
              'Every visit to a participating local shop means points in your pocket.',
            ),
            _buildBulletPoint(
              'Exclusive Rewards',
              'Redeem your points for discounts, freebies, and special offers.',
            ),
            _buildBulletPoint(
              'Discover Local Gems',
              'Explore new spots and uncover hidden gems in your area.',
            ),
            _buildBulletPoint(
              'Easy to Use',
              'Simply check in and start earning. It\'s that simple!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          
         Icon(LucideIcons.dot,size: 30),

         
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}