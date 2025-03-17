import 'package:business_app/screens/login_dashboard.dart';
import 'package:business_app/screens/reset-pass.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'select_business_type_screen.dart';
import 'Forgot-Password.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 223, 93, 93),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible
                       ?FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    color: const Color.fromRGBO(143,144,152,1),
                    size: 18,
                
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: Text('Forgot password?', style: TextStyle(color: const Color.fromRGBO(11, 106, 136, 1))),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(11, 106, 136, 1),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Sign Up Button
            Center(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RichText(
        text: TextSpan(
          text: 'Not a member?',
          style: TextStyle(color: const Color.fromRGBO(113, 114, 122, 1)),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => SelectBusinessTypeScreen()),
                 );

                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove default padding
                  minimumSize: Size(0, 0), // Prevent extra space
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink button
                ),
                child: Text(
                  ' Sign Up',
                  style: TextStyle(
                    color: const Color.fromRGBO(11, 106, 136, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),


            SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Or continue with',
                style: TextStyle(color: const Color.fromRGBO(113, 114, 122, 1)),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(FontAwesomeIcons.google, Colors.red),
                SizedBox(width: 12),
                _buildSocialButton(FontAwesomeIcons.apple, Colors.black),
                SizedBox(width: 12),
                _buildSocialButton(FontAwesomeIcons.facebook, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width:45,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
