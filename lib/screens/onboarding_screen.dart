import 'package:business_app/screens/select_business_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    // Get screen dimensions
    final size = MediaQuery.of(context).size;
    final double topSectionHeight = size.height * 0.67; // 2/3 of screen height
    final double bottomSectionHeight = size.height * 0.33; // 1/3 of screen height

    return Scaffold(
      body: Column(
        children: [
          // Top section (2/3 of screen) - Image carousel with overlay text
          Container(
            height: topSectionHeight,
            child: Stack(
              children: [
                // Full image carousel
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
                
                // Dark overlay for better text visibility
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
                
                // Text content and dots indicator stacked correctly
                Positioned(
                  bottom: 40,
                  left: 18,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dots indicator ABOVE the title
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
                      
                      // Title
                      Text(
                        slides[_currentIndex]['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Description
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
                
                // Status bar padding
                SafeArea(
                  child: Container(
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom section (1/3 of screen) - Login and social buttons
          Container(
            height: bottomSectionHeight,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login-screen');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(11, 106, 136, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                // Registration text
                GestureDetector(
                  onTap: () {
                   Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) =>SelectBusinessTypeScreen()),
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
                
                // Divider
                Divider(
                  color: Color(0xFFD4D6DD),
                  thickness: 0.5,
                ),
                
                // Or continue with text
                Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                
                // Social buttons
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