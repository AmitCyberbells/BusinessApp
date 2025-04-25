import 'package:business_app/screens/constants.dart';
import 'package:business_app/screens/login_dashboard.dart';
import 'package:business_app/screens/reset-pass.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'select_business_type_screen.dart';
import 'Forgot-Password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  String? _token;
  


Future<void> _fetchBusinessId(String token) async {
  final response = await http.get(
    Uri.parse('https://dev.frequenters.com/api/business'), // Adjust endpoint as needed
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print('Fetch business_id response status: ${response.statusCode}');
  print('Fetch business_id response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final businessId = data['business_id'].toString(); // Adjust based on actual response structure
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('business_id', businessId);
    print('Business ID fetched and saved: $businessId');
  } else {
    print('Failed to fetch business_id: ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch business ID: ${response.body}')),
    );
  }
}
Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    final response = await http.post(
      Uri.parse('https://dev.frequenters.com/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _token = data['token']; // Adjust based on actual API response
      });

      // Store the token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      // Extract and save business_id
      final user = data['user'];
      final businessId = user['business_profile']?['business_id']?.toString() ?? user['id'].toString();
      await prefs.setString('business_id', businessId);
      print('Business ID saved from login: $businessId');

      // Navigate to dashboard
      Navigator.pushNamed(context, '/dashboard1');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${response.body}')),
      );
    }
  }
}
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
        child: Form(
          key: _formKey,
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
              Text('Email Address',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              customTextField(
                controller: emailController,
                hintText: 'Email Address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              customTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: !_passwordVisible, // Fixed to toggle visibility
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text('Forgot password?',
                      style: TextStyle(
                          color: const Color.fromRGBO(11, 106, 136, 1))),
                ),
              ),
              AppConstants.fullWidthButton(
                onPressed: _login,
                text: 'Login',
              ),
              SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Not a member?',
                        style: TextStyle(
                            color: const Color.fromRGBO(113, 114, 122, 1)),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectBusinessTypeScreen()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
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
                  style:
                      TextStyle(color: const Color.fromRGBO(113, 114, 122, 1)),
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
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 45,
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

  Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? icon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      validator: validator,
    );
  }
}