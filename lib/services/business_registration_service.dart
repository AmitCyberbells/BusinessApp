import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class BusinessRegistrationService {
  static const String baseUrl = 'https://dev.frequenters.com';

  Future<bool> registerBusiness({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
    required String zip,
    required String lat,
    required String lng,
    required String website,
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required int categoryId,
    required int childCategoryId,
    String? logo,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/register/business');
      debugPrint('🌐 Making request to: $uri');

      // Generate a random password for initial registration
      // In a real app, you might want to let the user set this
      const password = 'Welcome@123';

      // Log request data
      final requestData = {
        'business_name': name,
        'business_email': email,
        'business_phone': phone,
        'address_line1': address,
        'city': city,
        'state': state,
        'country': country,
        'zip_code': zip,
        'latitude': lat,
        'longitude': lng,
        'website': website,
        'owner_name': ownerName,
        'owner_email': ownerEmail,
        'owner_phone': ownerPhone,
        'category_id': categoryId.toString(),
        'child_category_id': childCategoryId.toString(),
        'password': password,
        'password_confirmation': password,
      };
      debugPrint('📤 Request data: ${jsonEncode(requestData)}');

      // Create multipart request
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        })
        ..fields.addAll(requestData);

      // Add logo if provided
      if (logo != null) {
        debugPrint('📎 Adding logo file: $logo');
        request.files.add(await http.MultipartFile.fromPath('logo', logo));
      }

      debugPrint('📤 Sending request with headers: ${request.headers}');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      debugPrint('📥 Response status code: ${response.statusCode}');
      debugPrint('📥 Response body: $responseBody');

      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save the token if it's in the response
        if (jsonResponse['token'] != null) {
          debugPrint('🔑 Received authentication token');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', jsonResponse['token']);
        }
        return true;
      } else {
        if (jsonResponse['errors'] != null) {
          debugPrint(
              '❌ Validation errors: ${jsonEncode(jsonResponse['errors'])}');
          throw Exception(
              'Validation failed: ${jsonEncode(jsonResponse['errors'])}');
        }
        throw Exception(
            jsonResponse['message'] ?? 'Failed to register business');
      }
    } catch (e) {
      debugPrint('❌ Error during registration: $e');
      rethrow;
    }
  }
}
