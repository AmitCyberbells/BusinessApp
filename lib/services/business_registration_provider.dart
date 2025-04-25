import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BusinessRegistrationProvider extends ChangeNotifier {
  /// ------- form fields -------
  int? categoryId;
  int? childCategoryId;

  String? businessName;
  String? businessEmail;
  String? businessPhone;

  String? addressLine1;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  String? latitude;
  String? longitude;

  String? password;
  String? website;

  String? ownerName;
  String? ownerEmail;
  String? ownerPhone;
  String? ownerPassword;

  File? logo; // optional

  /// ------- progressive save helpers -------
  void setCategory({required int parentId, required int childId}) {
    categoryId = parentId;
    childCategoryId = childId;
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
    required String pwd,
    String? site,
  }) {
    businessName = name;
    businessEmail = email;
    businessPhone = phone;
    addressLine1 = addr;
    city = cty;
    state = st;
    country = ctry;
    zipCode = zip;
    latitude = lat;
    longitude = lng;
    password = pwd;
    website = site;
    notifyListeners();
  }

  void setOwnerDetails({
    required String name,
    required String email,
    required String phone,
    required String pwd,
  }) {
    ownerName = name;
    ownerEmail = email;
    ownerPhone = phone;
    ownerPassword = pwd;
    notifyListeners();
  }

  void setLogo(File? file) {
    logo = file;
    notifyListeners();
  }

  /// ------- final submit -------
  Future<http.StreamedResponse> submit() async {
  final uri = Uri.parse('https://dev.frequenters.com/api/register/business');
  final req = http.MultipartRequest('POST', uri)
    ..fields['category_id'] = categoryId.toString()
    ..fields['child_category_id'] = childCategoryId.toString()
    ..fields['business_name'] = businessName ?? ''
    ..fields['business_email'] = businessEmail ?? ''
    ..fields['business_phone'] = businessPhone ?? ''
    ..fields['address_line1'] = addressLine1 ?? ''
    ..fields['city'] = city ?? ''
    ..fields['state'] = state ?? ''
    ..fields['country'] = country ?? ''
    ..fields['zip_code'] = zipCode ?? ''
    ..fields['latitude'] = latitude ?? ''
    ..fields['longitude'] = longitude ?? ''
    ..fields['password'] = password ?? ''
    ..fields['password_confirmation'] = password ?? ''
    ..fields['owner_name'] = ownerName ?? ''
    ..fields['owner_email'] = ownerEmail ?? ''
    ..fields['owner_phone'] = ownerPhone ?? ''
    ..fields['website'] = website ?? '';

  if (logo != null) {
    req.files.add(await http.MultipartFile.fromPath('logo', logo!.path));
    print('Logo file added: ${logo!.path}');
  } else {
    print('No logo file provided');
  }

  req.headers['Accept'] = 'application/json';
  final response = await req.send();
  final responseBody = await response.stream.bytesToString();

  print('Submit response status: ${response.statusCode}');
  print('Submit response body: $responseBody');

  // Save business_id if successful
  if (response.statusCode == 200 || response.statusCode == 201) {
    final jsonResponse = jsonDecode(responseBody);
    final businessId = jsonResponse['business_id'].toString(); // Adjust based on actual response structure
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('business_id', businessId);
    print('Business registered, business_id saved: $businessId');
  }

  return response;
}
}