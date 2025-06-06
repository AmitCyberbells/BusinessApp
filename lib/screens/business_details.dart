import 'package:business_app/screens/constants.dart';
import 'package:business_app/services/business_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';
import '../widgets/custom_back_button.dart';

class BusinessDetailsScreen extends StatefulWidget {
  @override
  _BusinessDetailsScreenState createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final int currentStep = 2;
  final int totalSteps = 4;
  String? selectedCategory;
  bool isDropdownOpen = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? _lat;
  String? _lng;
  String? _city;
  String? _state;
  String? _country;
  String? _zip;
  bool _locationReady = false;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Location permission is required to auto-fill address'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        final placemarks =
            await geo.placemarkFromCoordinates(pos.latitude, pos.longitude);

        final place = placemarks.first;

        // Construct a complete address string
        final addressParts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
          place.postalCode,
        ].where((part) => part != null && part.isNotEmpty).toList();

        setState(() {
          _locationController.text = addressParts.join(', ');
          _lat = pos.latitude.toString();
          _lng = pos.longitude.toString();
          _city = place.locality ?? '';
          _state = place.administrativeArea ?? '';
          _country = place.country ?? '';
          _zip = place.postalCode ?? '';
          _locationReady = true;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _getLocationFromAddress(String address) async {
    try {
      if (address.isEmpty) {
        setState(() => _locationReady = false);
        return;
      }

      final locations = await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final placemarks = await geo.placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _lat = location.latitude.toString();
            _lng = location.longitude.toString();
            _city = place.locality ?? '';
            _state = place.administrativeArea ?? '';
            _country = place.country ?? '';
            _zip = place.postalCode ?? '';
            _locationReady = true;
          });
        }
      }
    } catch (e) {
      print('Error geocoding address: $e');
      // Don't show error to user as this is a background operation
      setState(() => _locationReady = false);
    }
  }

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_locationReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set your business location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      context.read<BusinessRegistrationProvider>().setBusinessDetails(
            name: _businessNameController.text,
            email: emailController.text,
            phone: _phoneController.text,
            addr: _locationController.text,
            cty: _city ?? '',
            st: _state ?? '',
            ctry: _country ?? '',
            zip: _zip ?? '',
            lat: _lat ?? '0',
            lng: _lng ?? '0',
            site: _websiteController.text,
          );

      Navigator.pushNamed(context, '/owner-details');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                      child: const CustomBackButton(),
                    ),
                    Text(
                      'Enter Business Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey.shade300),
                            strokeWidth: 4,
                            strokeCap: StrokeCap.butt,
                          ),
                        ),
                        Transform.rotate(
                          angle: 3.14 * 2 * 0.0,
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: CircularProgressIndicator(
                              value: 0.1,
                              backgroundColor: Colors.transparent,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 4,
                              strokeCap: StrokeCap.butt,
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: 3.14 * 2 * 0.02,
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: CircularProgressIndicator(
                              value: 0.50,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF1F5F6B)),
                              strokeWidth: 4,
                              strokeCap: StrokeCap.butt,
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: 3.14 * 2 * 0.52,
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: CircularProgressIndicator(
                              value: 0.02,
                              backgroundColor: Colors.transparent,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 4,
                              strokeCap: StrokeCap.butt,
                            ),
                          ),
                        ),
                        Container(
                          width: 41,
                          height: 41,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '2 of 4',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Enter Business Name',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        customTextField(
                          hintText: 'Enter Business Name',
                          controller: _businessNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter business name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text('Business Address',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        customTextField(
                          hintText:
                              'e.g. 123 Main Street, Floor/Suite (optional)',
                          controller: _locationController,
                          icon: Icon(LucideIcons.mapPin,
                              color: Colors.grey.shade700),
                          onIconTap: _getCurrentLocation,
                          onChanged: (value) {
                            // Debounce address lookup to avoid too many API calls
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              if (_locationController.text == value) {
                                _getLocationFromAddress(value);
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter business address';
                            }
                            // Check if address has at least street and number
                            if (!RegExp(r'\d+.*\s+.*').hasMatch(value)) {
                              return 'Please enter a valid street address with number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter your complete street address or use the location icon to auto-fill.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Business Email Address',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        customTextField(
                          hintText: 'Enter Email Address',
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email address';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text('Phone Number',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        customTextField(
                          hintText: '+1 000 000 0000',
                          controller: _phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (!RegExp(r'^\+?1?\d{10}$')
                                .hasMatch(value.replaceAll(' ', ''))) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text('Business Website (Optional)',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        customTextField(
                            hintText: 'www.abc.com',
                            controller: _websiteController),
                        SizedBox(height: 10),
                        Text('Password',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        customTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: _passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          icon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              color: const Color.fromRGBO(143, 144, 152, 1),
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Confirm Password',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        customTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: _confirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          icon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              color: const Color.fromRGBO(143, 144, 152, 1),
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildHelpButton(
                  onPressed: () {
                    // Help functionality
                  },
                ),
                SizedBox(height: 16),
                AppConstants.fullWidthButton(
                  onPressed: _handleNext,
                  text: 'Next',
                ),
                SizedBox(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
