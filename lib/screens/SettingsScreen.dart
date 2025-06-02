import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPushEnabled = true;
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          const Text(
            'PROFILE',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          // Push Notification
          _buildToggleTile(
            title: 'Push Notification',
            value: isPushEnabled,
            onChanged: (val) => setState(() => isPushEnabled = val),
          ),

          // Dark Mode
          _buildToggleTile(
            title: 'Dark Mode',
            value: isDarkModeEnabled,
            onChanged: (val) => setState(() => isDarkModeEnabled = val),
            activeColor: Colors.deepPurple.shade100,
            thumbColor: Colors.white,
          ),

          // Language
          _buildArrowTile(
            title: 'Language',
            trailingText: 'Espanol',
            onTap: () {},
          ),

          // Change Password
          _buildArrowTile(
            title: 'Change Password',
            onTap: () {},
          ),

          const SizedBox(height: 24),
          const Text(
            'OTHER',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          // About
          _buildArrowTile(title: 'About', onTap: () {}),

          // Privacy Policy
          _buildArrowTile(title: 'Privacy Policy', onTap: () {}),

          // Terms and Conditions
          _buildArrowTile(title: 'Terms and Conditions', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
    Color? thumbColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor ?? const Color(0xFF1A5C77),
            activeTrackColor: activeColor?.withOpacity(0.4) ??
                const Color(0xFF1A5C77).withOpacity(0.4),
            thumbColor: thumbColor != null
                ? MaterialStateProperty.all(thumbColor)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowTile({
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }
}
