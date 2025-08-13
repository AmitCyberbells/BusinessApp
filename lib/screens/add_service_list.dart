import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_service.dart';

class Service {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? photo;
  final int availabilityStatus;
  final int businessId;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.photo,
    required this.availabilityStatus,
    required this.businessId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '',
      photo: json['photo'],
      availabilityStatus: json['availability_status'] ?? 1,
      businessId: json['business_id'],
    );
  }
}

class AddServiceListScreen extends StatefulWidget {
  const AddServiceListScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceListScreen> createState() => _AddServiceListScreenState();
}

class _AddServiceListScreenState extends State<AddServiceListScreen> {
  bool _isLoading = true;
  String? _error;
  List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final businessId = prefs.getString('business_id');

      if (token == null || businessId == null) {
        throw Exception('Authentication token or business ID not found');
      }

      final url =
          'https://dev.frequenters.com/api/customer/service-list?business_id=$businessId';
      print('Fetching services from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Services response: ${response.statusCode}');
      print('Services body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final servicesData =
            (data['data'] != null && data['data']['data'] is List)
                ? data['data']['data']
                : [];
        setState(() {
          _services = List<Service>.from(
            (servicesData as List).map((item) => Service.fromJson(item)),
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load services';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching services: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
          'Add Service List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchServices,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _services.isEmpty
                  ? const Center(
                      child: Text(
                        'Looks empty here... Let\'s add your first item and get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        final service = _services[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: service.photo != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      service.photo!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                            Icons.miscellaneous_services,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                        Icons.miscellaneous_services,
                                        color: Colors.grey),
                                  ),
                            title: Text(
                              service.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service.description),
                                const SizedBox(height: 4),
                                Text(
                                  'Price: \$${service.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: service.availabilityStatus == 1
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                service.availabilityStatus == 1
                                    ? 'Available'
                                    : 'Unavailable',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddServiceScreen(),
            ),
          ).then((_) => _fetchServices());
        },
        backgroundColor: const Color(0xFF2F6D88),
        child: const Icon(Icons.add),
      ),
    );
  }
}
