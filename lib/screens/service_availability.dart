import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ServiceAvailabilityScreen extends StatefulWidget {
  final String name;
  final String categoryId;
  final String description;
  final String duration;
  final String price;

  const ServiceAvailabilityScreen({
    Key? key,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.duration,
    required this.price,
  }) : super(key: key);

  @override
  State<ServiceAvailabilityScreen> createState() =>
      _ServiceAvailabilityScreenState();
}

class _ServiceAvailabilityScreenState extends State<ServiceAvailabilityScreen> {
  final Map<String, bool> _daysOpen = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': false,
    'Sunday': false,
  };

  final Map<String, String> _timings = {
    'Monday': '09:15 AM to 06:30 PM',
    'Tuesday': '09:15 AM to 06:30 PM',
    'Wednesday': '09:15 AM to 06:30 PM',
    'Thursday': '09:15 AM to 06:30 PM',
    'Friday': '09:15 AM to 06:30 PM',
    'Saturday': '09:15 AM to 06:30 PM',
    'Sunday': '09:15 AM to 06:30 PM',
  };

  bool _isSubmitting = false;

  String _convertTo24Hour(String time) {
    try {
      final inputFormat = DateFormat('hh:mm a');
      final outputFormat = DateFormat('HH:mm');
      return outputFormat.format(inputFormat.parse(time));
    } catch (e) {
      return time; // fallback if already in 24-hour
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Availability Hours',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Manage Your Availability Hours',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _daysOpen.length,
              itemBuilder: (context, index) {
                final day = _daysOpen.keys.elementAt(index);
                return _buildDayItem(day);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F6D88),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Switch(
                value: _daysOpen[day]!,
                onChanged: (value) {
                  setState(() {
                    _daysOpen[day] = value;
                  });
                },
                activeColor: const Color(0xFF2F6D88),
              ),
            ],
          ),
          children: [
            if (_daysOpen[day]!)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Slot 1',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _timings[day]!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '09 hrs 15 mins',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement add/edit time functionality
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '+ Add/Edit Time',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
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

  Future<void> _handleSave() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final businessId = prefs.getString('business_id');
      if (token == null || businessId == null) {
        throw Exception('Authentication token or business ID not found');
      }
      // Prepare availability data
      List<Map<String, dynamic>> availability = [];
      int i = 0;
      _daysOpen.forEach((day, isOpen) {
        final times = _timings[day]!.split(' to ');
        String startTime = times[0];
        String endTime = times.length > 1 ? times[1] : '';
        startTime = _convertTo24Hour(startTime.trim());
        endTime = _convertTo24Hour(endTime.trim());
        availability.add({
          'day': day,
          'start_time': startTime,
          'end_time': endTime,
          'is_open': isOpen ? 1 : 0,
        });
        i++;
      });
      final url = 'https://dev.frequenters.com/api/business/service-post';
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields['business_id'] = businessId;
      request.fields['name'] = widget.name;
      request.fields['category_id'] = widget.categoryId.toString();
      request.fields['description'] = widget.description;
      request.fields['duration'] = widget.duration;
      request.fields['price'] = widget.price;
      // Add availability as array fields
      for (int i = 0; i < availability.length; i++) {
        request.fields['availability[$i][day]'] = availability[i]['day'];
        request.fields['availability[$i][start_time]'] =
            availability[i]['start_time'];
        request.fields['availability[$i][end_time]'] =
            availability[i]['end_time'];
        request.fields['availability[$i][is_open]'] =
            availability[i]['is_open'].toString();
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Service post response: ${response.statusCode}');
      print('Service post body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save: ${response.body}'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
