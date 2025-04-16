import 'package:business_app/screens/constants.dart';
import 'package:business_app/screens/select_business_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:business_app/screens/constants.dart'; // Adjust the import path as needed

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
  ];

  final List<Map<String, String>> slides = [
    {
      'title': 'Welcome to Frequenters!',
      'description': 'Build customer loyalty and grow your business with every visit.'
    },
    {
      'title': 'Engage Your Customers',
      'description': 'Connect with customers and reward their loyalty.'
    },
    {
      'title': 'Turn Loyalty into Growth',
      'description': 'Track, retain, and grow your loyal customer base.'
    },
  ];

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double topSectionHeight = size.height * 0.67;
    final double bottomSectionHeight = size.height * 0.33;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: topSectionHeight,
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: topSectionHeight,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: images.map((image) {
                    return Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 18,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: images.asMap().entries.map((entry) {
                          int index = entry.key;
                          return GestureDetector(
                            child: Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.white
                                    : Color(0xFF0B6A88),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Text(
                        slides[_currentIndex]['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                     
                      Text(
                        slides[_currentIndex]['description']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Container(
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: bottomSectionHeight,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Replaced with fullWidthButton
                AppConstants.fullWidthButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login-screen');
                  },
                  text: 'Login', // Editable text
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectBusinessTypeScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Not a member? ',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Register now',
                          style: TextStyle(
                            color: Color(0xFF0B6A88),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xFFD4D6DD),
                  thickness: 0.5,
                ),
                Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(FontAwesomeIcons.google, Color(0xFFEA4335)),
                    SizedBox(width: 16),
                    _buildSocialButton(FontAwesomeIcons.apple, Colors.black),
                    SizedBox(width: 16),
                    _buildSocialButton(FontAwesomeIcons.facebook, Color(0xFF1877F2)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 20),
        padding: EdgeInsets.zero,
      ),
    );
  }
}