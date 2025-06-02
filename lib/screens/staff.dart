import 'package:business_app/screens/addStaff.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Model for Staff data
class Staff {
  final int id;
  final String name;
  final String email;
  final String role;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }
}

class ManageStaffComponent extends StatefulWidget {
  const ManageStaffComponent({Key? key}) : super(key: key);

  @override
  _ManageStaffComponentState createState() => _ManageStaffComponentState();
}

class _ManageStaffComponentState extends State<ManageStaffComponent> {
  List<Map<String, dynamic>> managers = [];
  List<Map<String, dynamic>> teamMembers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStaffData();
  }
  Future<void> fetchStaffData() async {
  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      setState(() {
        errorMessage = 'No authentication token found. Please log in.';
        isLoading = false;
      });
      return;
    }

    const baseUrl = 'https://dev.frequenters.com';
    final url = Uri.parse('$baseUrl/api/business/staff-listing');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      print('Raw JSON: $decoded');
      if (decoded is List) {
        final List<Staff> staffList = decoded.map((json) => Staff.fromJson(json as Map<String, dynamic>)).toList();
        print('Staff List: ${staffList.map((s) => {'id': s.id, 'name': s.name, 'role': s.role}).toList()}');

        // Limit total staff to 5 (managers + employees)
        staffList.sort((a, b) => a.role == 'manager' ? -1 : 1); // Prioritize managers
        final limitedStaffList = staffList.take(5).toList();

        setState(() {
          // Get all managers with their IDs
          managers = limitedStaffList
              .where((staff) => staff.role.toLowerCase() == 'manager')
              .map((staff) => {'name': staff.name, 'id': staff.id} as Map<String, dynamic>)
              .toList();

          // If no managers, display "No Manager"
          if (managers.isEmpty) {
            managers.add({'name': 'No Manager', 'id': 0} as Map<String, Object>);
          }
          print('Managers: $managers');

          // Get employees (non-managers) with their IDs
          teamMembers = limitedStaffList
              .where((staff) => staff.role.toLowerCase() == 'employee')
              .map((staff) => {'name': staff.name, 'id': staff.id} as Map<String, dynamic>)
              .toList();
          print('Team Members: $teamMembers');

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected response format: Expected a JSON list';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to load staff data: ${response.statusCode}';
        isLoading = false;
      });
    }
  } catch (e, stackTrace) {
    print('Error: $e');
    print('StackTrace: $stackTrace');
    setState(() {
      errorMessage = 'Error fetching staff data: $e';
      isLoading = false;
    });
  }
}
  Future<void> _deleteStaff(int id) async {
    if (id == 0) return; // Don't attempt to delete "No Manager"

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorMessage = 'No authentication token found. Please log in.';
        });
        return;
      }

      const baseUrl = 'https://dev.frequenters.com';
      final url = Uri.parse('$baseUrl/api/business/staff/$id');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully deleted, refresh the staff list
        await fetchStaffData();
      } else {
        setState(() {
          errorMessage = 'Failed to delete staff: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error deleting staff: $e';
      });
    }
  }

  void _showDeleteConfirmationDialog(int id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deactivate Account'),
          content:
              Text('Are you sure you want to deactivate $name\'s account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteStaff(id); // Call the delete API
              },
              child: Text('Deactivate', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Manage Staff',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(errorMessage!,
                        style: TextStyle(color: Colors.red)))
                : ListView(
                    children: [
                      SizedBox(height: 16),

                      // Manager Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Manager',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      ...managers.map((staff) => _buildStaffRow(
                          staff['name'], staff['id'],
                          isDeletable: staff['id'] != 0)),

                      SizedBox(height: 16),

                      // Team Member Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Team Member',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      ...teamMembers.map((staff) => _buildStaffRow(
                          staff['name'], staff['id'],
                          isDeletable: true)),

                      Divider(
                          height: 32, thickness: 1, color: Colors.grey[300]),

                      // Add New rows (hide icon if staff count is 5)
                      _buildAddNewRow(),
                      Divider(thickness: 1, color: Colors.grey[300]),
                      _buildAddNewRow(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildStaffRow(String name, int id, {bool isDeletable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          if (isDeletable)
            GestureDetector(
              onTap: () => _showDeleteConfirmationDialog(id, name),
              child: Icon(
                Icons.delete_outline,
                size: 24,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddNewRow() {
    final totalStaffCount = managers.length + teamMembers.length;
    // Adjust count if "No Manager" is present
    final adjustedCount = managers.contains({'name': 'No Manager', 'id': 0})
        ? totalStaffCount - 1
        : totalStaffCount;

    if (adjustedCount >= 5)
      return SizedBox.shrink(); // Hide the entire row if limit reached

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add New',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewPositionScreen()),
              );
              if (result == true) {
                fetchStaffData(); // Refresh the staff list if a new staff was added
              }
            },
            child: Icon(
              Icons.add,
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
