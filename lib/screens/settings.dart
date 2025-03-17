import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotificationEnabled = false;
  bool locationEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = "Espanol";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "PROFILE",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
             const SizedBox(height: 20),
            
            _buildSwitchTile("Push Notification", pushNotificationEnabled, (value) {
              setState(() {
                pushNotificationEnabled = value;
              });
            }),
           
            _buildSwitchTile("Location", locationEnabled, (value) {
              setState(() {
                locationEnabled = value;
              });
            }),
           
            _buildSwitchTile("Dark Mode", darkModeEnabled, (value) {
              setState(() {
                darkModeEnabled = value;
              });
            }),
          
            _buildNavigationTile("Language", selectedLanguage),
            
            _buildNavigationTile("Change Password"),
            const SizedBox(height: 30),
            const Text(
              "OTHER",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            _buildNavigationTile("About"),
           
            _buildNavigationTile("Privacy Policy"),
          
            _buildNavigationTile("Terms and Conditions"),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                    

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
           activeTrackColor: title == "Dark Mode"
    ? const Color.fromRGBO(44, 122, 156, 1)
    : title == "Push Notification"
        ? const Color.fromRGBO(44, 122, 156, 1)
        : title == "Location"
            ? const Color.fromRGBO(44, 122, 156, 1)
            : null,

            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(String title, [String? subtitle]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [ const SizedBox(height: 10),

              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
             Icon(
  title == "Language" 
      ? LucideIcons.chevronRight 
      : LucideIcons.chevronRight ,
  color: Colors.grey.shade700,
),

            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildDivider() {
  //   return Divider(
  //     color: Colors.grey.shade200,
  //     thickness: 1,
  //   );
  // }
}