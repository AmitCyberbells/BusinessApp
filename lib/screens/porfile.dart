import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_back_button.dart';
import './addmenu1.dart';
import './add_service_list.dart';

class BusinessDetails {
  final String name;
  final String email;
  final String? profileImage;
  final String businessType;
  final String location;
  final String category;

  BusinessDetails({
    required this.name,
    required this.email,
    this.profileImage,
    required this.businessType,
    required this.location,
    required this.category,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    final businessData = json['business'] ?? json;
    final businessProfile = businessData['business_profile'] ?? {};

    return BusinessDetails(
      name:
          businessProfile['business_name'] ?? businessData['owner_name'] ?? '',
      email: businessData['email'] ?? '',
      profileImage: businessData['profile_image'],
      businessType:
          businessProfile['industry_type']?.toString() ?? 'Pastry shop',
      location: 'Lagos, Nigeria',
      category: businessProfile['business_category'] ??
          businessProfile['category'] ??
          businessData['business_category'] ??
          businessData['category'] ??
          'Food and Beverages',
    );
  }

  bool get isFoodAndBeverages =>
      category.toLowerCase().contains('food') ||
      category.toLowerCase().contains('beverage') ||
      businessType.toLowerCase().contains('food') ||
      businessType.toLowerCase().contains('restaurant') ||
      businessType.toLowerCase().contains('cafe');
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;
  bool _isLoading = true;
  BusinessDetails? _businessDetails;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
  }

  Future<void> _fetchBusinessDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final businessId = prefs.getString('business_id');

      print('Debug - Token: $token'); // Debug log
      print('Debug - Business ID: $businessId'); // Debug log

      if (token == null || businessId == null) {
        throw Exception('Authentication token or business ID not found');
      }

      final url =
          'https://dev.frequenters.com/api/customer/business-detail/$businessId';
      print('Debug - API URL: $url'); // Debug log

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
          'Debug - Response Status Code: ${response.statusCode}'); // Debug log
      print('Debug - Response Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if data is in the expected format
        if (data == null) {
          throw Exception('Response data is null');
        }

        // If data is nested in a 'data' field, extract it
        final businessData = data['data'] ?? data;

        print('Debug - Parsed Business Data: $businessData'); // Debug log

        setState(() {
          _businessDetails = BusinessDetails.fromJson(businessData);
          _isLoading = false;
        });

        print(
            'Debug - Business Details: ${_businessDetails?.name}, ${_businessDetails?.email}'); // Debug log
      } else if (response.statusCode == 401) {
        // Handle unauthorized access
        await prefs.clear();
        if (mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login-screen', (route) => false);
        }
        throw Exception('Session expired. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ??
            'Failed to load business details: ${response.statusCode}');
      }
    } catch (e) {
      print('Debug - Error: $e'); // Debug log
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    if (_isLoggingOut) return; // Prevent multiple logout attempts

    setState(() {
      _isLoggingOut = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      // Clear all stored credentials
      await prefs.clear();

      if (!mounted) return;

      // Navigate to login screen and remove all previous routes
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login-screen', (route) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging out. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black54),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchBusinessDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          // Background Image
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/profile_bg.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          // Back Button
                          Positioned(
                            top: 40,
                            left: 16,
                            child: Container(
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
                              child: Center(
                                child: CustomBackButton(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Profile Avatar and Info
                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: const Color(0xFF2F6D88),
                              child: Text(
                                _businessDetails?.name.isNotEmpty == true
                                    ? _businessDetails!.name[0].toUpperCase()
                                    : 'B',
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _businessDetails?.name ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _businessDetails?.email ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Rating Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(
                                    4,
                                    (index) => const Icon(Icons.star,
                                        color: Colors.amber, size: 20)),
                                const Icon(Icons.star_half,
                                    color: Colors.amber, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  '4.5/5',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '1,230 User Reviews',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Business Type and Location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.store_outlined, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  _businessDetails?.businessType ??
                                      'Pastry shop',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.location_on_outlined,
                                    size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  _businessDetails?.location ??
                                      'Lagos, Nigeria',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Profile Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'PROFILE',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: 'Edit Business Profile',
                              onTap: () => Navigator.pushNamed(
                                  context, '/editBusinessProfile'),
                            ),
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: 'Edit Owner Details',
                              onTap: () => Navigator.pushNamed(
                                  context, '/editOwnerDetails'),
                            ),
                            _buildMenuItem(
                              icon: Icons.local_offer_outlined,
                              title: 'Offers and Rewards Management',
                              onTap: () {},
                            ),
                            _buildMenuItem(
                              icon: Icons.local_offer_outlined,
                              title: 'Set Check-in Points',
                              onTap: () => Navigator.pushNamed(
                                  context, '/checkInPoints'),
                            ),
                            _buildMenuItem(
                              icon: Icons.visibility_outlined,
                              title: 'View Offers & Rewards',
                              onTap: () {},
                            ),
                            _buildMenuItem(
                              icon: Icons.access_time,
                              title: 'Opening Timings',
                              onTap: () =>
                                  Navigator.pushNamed(context, '/openingHours'),
                            ),
                            _buildMenuItem(
                              icon: _businessDetails?.isFoodAndBeverages == true
                                  ? Icons.restaurant_menu_outlined
                                  : Icons.miscellaneous_services_outlined,
                              title:
                                  _businessDetails?.isFoodAndBeverages == true
                                      ? 'Add Menu Items'
                                      : 'Add Services',
                              onTap: () {
                                if (_businessDetails?.isFoodAndBeverages ==
                                    true) {
                                  // For Food & Beverages businesses
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddMenu1Screen(),
                                    ),
                                  );
                                } else {
                                  // For other businesses (Events, Retail, etc.)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddServiceListScreen(),
                                    ),
                                  );
                                }
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.insights_outlined,
                              title: 'Business Insights',
                              onTap: () {},
                            ),
                            _buildMenuItem(
                              icon: Icons.group_outlined,
                              title: 'Manage Staff',
                              onTap: () =>
                                  Navigator.pushNamed(context, '/manageStaff'),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'SUPPORT',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            _buildMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Settings',
                              onTap: () =>
                                  Navigator.pushNamed(context, '/settings'),
                            ),
                            _buildMenuItem(
                              icon: Icons.help_outline,
                              title: 'Help Center',
                              onTap: () {},
                            ),
                            _buildMenuItem(
                              icon: Icons.info_outline,
                              title: 'Terms and Conditions',
                              onTap: () {},
                            ),
                            _buildMenuItem(
                              icon: Icons.payment_outlined,
                              title: 'Payment & Subscription',
                              onTap: () {},
                            ),
                            const SizedBox(height: 24),
                            // Sign Out Button
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: OutlinedButton(
                                onPressed: _isLoggingOut
                                    ? null
                                    : () => _handleLogout(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.grey),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.logout, color: Colors.red),
                                    const SizedBox(width: 8),
                                    _isLoggingOut
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                            ),
                                          )
                                        : const Text(
                                            'Sign Out',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
