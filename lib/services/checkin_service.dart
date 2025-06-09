import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:business_app/utils/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckinService {
  static const String baseUrl = 'https://dev.frequenters.com';

  static Future<int> _getBusinessId() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Log all available keys in SharedPreferences
      final keys = prefs.getKeys();
      debugPrint('Available SharedPreferences keys: $keys');

      // Try different ways to get the business_id
      var businessId;

      // Try as string first
      final businessIdStr = prefs.getString('business_id');
      debugPrint('business_id from SharedPreferences (string): $businessIdStr');

      if (businessIdStr != null) {
        // Try to parse the string to int
        try {
          businessId = int.parse(businessIdStr);
          debugPrint(
              'Successfully parsed business_id string to int: $businessId');
        } catch (e) {
          debugPrint('Failed to parse business_id string to int: $e');
        }
      }

      // If string parsing failed, try getting as int
      if (businessId == null) {
        businessId = prefs.getInt('business_id');
        debugPrint('business_id from SharedPreferences (int): $businessId');
      }

      // Final validation
      if (businessId == null || businessId <= 0) {
        debugPrint('Invalid or missing business ID in SharedPreferences');
        throw Exception(
            'Business ID not found or invalid. Please log in again.');
      }

      debugPrint(
          'Final business ID value: $businessId (${businessId.runtimeType})');
      return businessId;
    } catch (e) {
      debugPrint('Error getting business ID: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> checkInCustomer({
    required String qrData,
  }) async {
    try {
      debugPrint('Starting check-in process with detailed logging...');
      debugPrint('Raw QR Data received: $qrData');

      // Get business ID from shared preferences
      final businessId = await _getBusinessId();
      debugPrint('Using business ID: $businessId (${businessId.runtimeType})');

      final token = await AuthService.getAuthToken();
      if (token == null) {
        debugPrint('Error: No auth token found');
        throw Exception('Authentication token not found');
      }
      debugPrint('Auth token retrieved successfully');

      // Validate QR data before sending
      if (qrData.isEmpty) {
        debugPrint('Error: QR Data is empty');
        throw Exception('QR data cannot be empty');
      }

      // Ensure business_id is sent as an integer
      final requestBody = {
        'qr_data': qrData,
        'business_id': businessId, // This will be an int
      };
      debugPrint('Request body: $requestBody');

      final response = await http.post(
        Uri.parse('$baseUrl/api/checkin/customer'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Check-in API Response Status: ${response.statusCode}');
      debugPrint('Check-in API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint('Successful check-in response: $responseData');
        return responseData;
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Unknown error occurred';
        throw Exception('Failed to check in customer: $errorMessage');
      }
    } catch (e) {
      debugPrint('Error during check-in: $e');
      rethrow;
    }
  }

  static Future<bool> checkInWithUID({
    required String customerUid,
    int? businessId,
  }) async {
    try {
      debugPrint('Starting UID check-in process...');
      debugPrint('Customer UID: $customerUid');

      // Get business ID from shared preferences if not provided
      final actualBusinessId = businessId ?? await _getBusinessId();
      debugPrint('Using business ID: $actualBusinessId');

      final token = await AuthService.getAuthToken();
      if (token == null) {
        debugPrint('Error: No auth token found');
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/checkin/by-uid'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customer_uid': customerUid,
          'business_id': actualBusinessId,
          'type': 'business_checkin'
        }),
      );

      debugPrint('UID Check-in API Response Status: ${response.statusCode}');
      debugPrint('UID Check-in API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Unknown error occurred';
        throw Exception('Failed to check in customer: $errorMessage');
      }
    } catch (e) {
      debugPrint('Error during UID check-in: $e');
      rethrow; // Rethrow to preserve the original error message
    }
  }
}
