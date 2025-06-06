import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'business_registration_service.dart';

class BusinessRegistrationProvider with ChangeNotifier {
  // Category Details
  int? _parentCategoryId;
  int? _childCategoryId;

  // Business Details
  String? _businessName;
  String? _businessEmail;
  String? _businessPhone;
  String? _businessAddress;
  String? _city;
  String? _state;
  String? _country;
  String? _zipCode;
  String? _latitude;
  String? _longitude;
  String? _website;
  String? _logo;

  // Owner Details
  String? _ownerName;
  String? _ownerEmail;
  String? _ownerPhone;

  // Logo
  File? _logoFile;

  final _registrationService = BusinessRegistrationService();

  // Getters
  bool get isComplete {
    final complete = _parentCategoryId != null &&
        _childCategoryId != null &&
        _businessName != null &&
        _businessEmail != null &&
        _businessPhone != null &&
        _businessAddress != null &&
        _ownerName != null &&
        _ownerEmail != null &&
        _ownerPhone != null;
    debugPrint('🔍 Registration data complete: $complete');
    return complete;
  }

  // Setters
  void setCategory({required int parentId, required int childId}) {
    debugPrint('📝 Setting category - Parent: $parentId, Child: $childId');
    _parentCategoryId = parentId;
    _childCategoryId = childId;
    notifyListeners();
  }

  void setBusinessDetails({
    required String name,
    required String email,
    required String phone,
    required String addr,
    required String cty,
    required String st,
    required String ctry,
    required String zip,
    required String lat,
    required String lng,
    required String site,
    String? logoPath,
  }) {
    debugPrint('📝 Setting business details:');
    debugPrint('   Name: $name');
    debugPrint('   Email: $email');
    debugPrint('   Phone: $phone');
    debugPrint('   Address: $addr');
    debugPrint('   City: $cty');
    debugPrint('   State: $st');
    debugPrint('   Country: $ctry');
    debugPrint('   ZIP: $zip');
    debugPrint('   Location: ($lat, $lng)');
    debugPrint('   Website: $site');

    _businessName = name;
    _businessEmail = email;
    _businessPhone = phone;
    _businessAddress = addr;
    _city = cty;
    _state = st;
    _country = ctry;
    _zipCode = zip;
    _latitude = lat;
    _longitude = lng;
    _website = site;
    _logo = logoPath;
    notifyListeners();
  }

  void setOwnerDetails({
    required String name,
    required String email,
    required String phone,
  }) {
    debugPrint('📝 Setting owner details:');
    debugPrint('   Name: $name');
    debugPrint('   Email: $email');
    debugPrint('   Phone: $phone');

    _ownerName = name;
    _ownerEmail = email;
    _ownerPhone = phone;
    notifyListeners();
  }

  void setLogo(File? file) {
    debugPrint('📝 Setting logo file: ${file?.path}');
    _logoFile = file;
    notifyListeners();
  }

  // Submit registration
  Future<bool> submitRegistration(BuildContext context) async {
    try {
      debugPrint('🚀 Starting business registration submission');

      if (_parentCategoryId == null ||
          _childCategoryId == null ||
          _businessName == null ||
          _businessEmail == null ||
          _businessPhone == null ||
          _businessAddress == null ||
          _city == null ||
          _state == null ||
          _country == null ||
          _zipCode == null ||
          _latitude == null ||
          _longitude == null ||
          _website == null ||
          _ownerName == null ||
          _ownerEmail == null ||
          _ownerPhone == null) {
        debugPrint('❌ Missing required fields');
        throw Exception('All fields are required');
      }

      debugPrint('✅ All required fields present, submitting registration');
      debugPrint(
          '📝 Using category IDs: Parent=${_parentCategoryId}, Child=${_childCategoryId}');

      final success = await _registrationService.registerBusiness(
        name: _businessName!,
        email: _businessEmail!,
        phone: _businessPhone!,
        address: _businessAddress!,
        city: _city!,
        state: _state!,
        country: _country!,
        zip: _zipCode!,
        lat: _latitude!,
        lng: _longitude!,
        website: _website!,
        ownerName: _ownerName!,
        ownerEmail: _ownerEmail!,
        ownerPhone: _ownerPhone!,
        categoryId: _parentCategoryId!,
        childCategoryId: _childCategoryId!,
        logo: _logo,
      );

      if (success) {
        debugPrint('✅ Registration successful, clearing data');
        // Clear the data after successful registration
        _clearData();

        // Navigate to success screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/registration-success',
          (route) => false,
        );
        return true;
      }
      debugPrint('❌ Registration failed');
      return false;
    } catch (e) {
      debugPrint('❌ Error during registration submission: $e');
      rethrow;
    }
  }

  void _clearData() {
    debugPrint('🧹 Clearing registration data');
    _parentCategoryId = null;
    _childCategoryId = null;
    _businessName = null;
    _businessEmail = null;
    _businessPhone = null;
    _businessAddress = null;
    _city = null;
    _state = null;
    _country = null;
    _zipCode = null;
    _latitude = null;
    _longitude = null;
    _website = null;
    _logo = null;
    _ownerName = null;
    _ownerEmail = null;
    _ownerPhone = null;
    _logoFile = null;
    notifyListeners();
  }
}
