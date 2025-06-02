import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220, // Adjusted height to fit the background image
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile_bg.png'),
                      fit: BoxFit.cover,
                      opacity:
                          1, // Re-enabled opacity to match the faded effect
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                Positioned(
                  top: 178, // Position the avatar to overlap the background
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromRGBO(11, 106, 136, 1),
                        child: Text(
                          'B',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'ALBERT STEVANO BAJEFSKI',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'albertstevano@gmail.com',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star_half, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text('4.5/5', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '1,230 User Reviews',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.store_outlined,
                              size: 16, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'Pastry shop',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.location_on_outlined,
                              size: 16, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'Lagos, Nigeria',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16), // Extra space at the bottom
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 166), // Space between header and content
            // Profile Section

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'Edit Business Profile',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to Edit Business Profile screen
                    Navigator.pushNamed(context, '/editBusinessProfile');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'Edit Owner Details',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                     Navigator.pushNamed(context, '/editOwnerDetails');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_offer),
                    title: const Text(
                      'Offers and Rewards Management',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.visibility),
                    title: const Text(
                      'View Offers & Rewards',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text(
                      'Opening Timings',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(context, '/openingHours');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.insights),
                    title: const Text(
                      'Business Insights',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text(
                      'Manage Staff',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                        Navigator.pushNamed(context, '/manageStaff');
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SUPPORT',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text(
                      'Settings',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text(
                      'Help Center',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text(
                      'Terms and Conditions',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text(
                      'Payment & Subscription',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Colors.grey),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
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
    );
  }
}
