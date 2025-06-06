import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _businessIdKey = 'business_id';

  // Save auth token and business ID
  static Future<void> saveAuthData(String token, int businessId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_businessIdKey, businessId);
  }

  // Get auth token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get business ID
  static Future<int?> getBusinessId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final businessIdStr = prefs.getString(_businessIdKey);
      if (businessIdStr == null) return null;

      return int.tryParse(businessIdStr) ?? 0;
    } catch (e) {
      debugPrint('Error getting business ID: $e');
      return null;
    }
  }

  // Clear auth data on logout
  static Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_businessIdKey);
    } catch (e) {
      debugPrint('Error clearing auth data: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveBusinessId(dynamic businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Convert to string regardless of input type
      final businessIdStr = businessId?.toString() ?? '';
      await prefs.setString(_businessIdKey, businessIdStr);
      debugPrint('Business ID saved: $businessIdStr');
    } catch (e) {
      debugPrint('Error saving business ID: $e');
    }
  }
}
