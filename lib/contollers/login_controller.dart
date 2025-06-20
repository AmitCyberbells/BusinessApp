import 'package:business_app/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final ApiService _apiService = ApiService();

  Future<void> login(String email, String password) async {
    try {
      final data = await _apiService.login(email, password);
      final token = data['token'];
      final user = data['user'];

      // Get business ID from either business_profile or user ID
      final businessId = user['business_profile']?['business_id']?.toString() ??
          user['id'].toString();
      final userId = user['id'].toString();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('business_id', businessId);
      await prefs.setString('user_id', userId);

      print('User ID saved: $userId');
      print('Business ID saved: $businessId');
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchBusinessId(String token) async {
    try {
      final data = await _apiService.fetchBusinessId(token);
      final businessId = data['business_id'].toString();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('business_id', businessId);
      print('Business ID fetched and saved: $businessId');
    } catch (e) {
      throw e;
    }
  }
}
