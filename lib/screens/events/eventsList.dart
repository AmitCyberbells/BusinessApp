import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../widgets/custom_back_button.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String bannerImage;
  final DateTime startDate;
  final DateTime endDate;
  final String venueName;
  final int totalSeats;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.bannerImage,
    required this.startDate,
    required this.endDate,
    required this.venueName,
    required this.totalSeats,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      name: json['event_name'] ?? '',
      description: json['event_description'] ?? '',
      bannerImage: json['event_banner'] ?? '',
      startDate:
          DateTime.parse(json['start_date'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toString()),
      venueName: json['venue_name'] ?? '',
      totalSeats: int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,
    );
  }
}

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  List<Event> events = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('https://dev.frequenters.com/api/business/event-listing'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['data'] != null &&
            responseData['data'] is Map<String, dynamic>) {
          final eventData = responseData['data'];
          if (eventData['events'] != null && eventData['events'] is List) {
            setState(() {
              events = (eventData['events'] as List)
                  .map((event) => Event.fromJson(event))
                  .toList();
            });
          } else {
            throw Exception('No events found in the response');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ??
            errorData['error'] ??
            'Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e'); // Debug log
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
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
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
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
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              enableInteractiveSelection: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                // TODO: Implement search functionality
              },
              decoration: InputDecoration(
                hintText: 'Search Events',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: $error',
                              style: const TextStyle(color: Colors.red),
                            ),
                            ElevatedButton(
                              onPressed: _fetchEvents,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : events.isEmpty
                        ? const Center(
                            child: Text('No events found'),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchEvents,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                final event = events[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (event.bannerImage.isNotEmpty)
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(8),
                                          ),
                                          child: Image.network(
                                            event.bannerImage,
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('E, MMM d • h:mm a')
                                                  .format(event.startDate),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              event.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              event.venueName,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    // Handle create again
                                                  },
                                                  child: const Text(
                                                    'Create Again',
                                                    style: TextStyle(
                                                      color: Color(0xFF0D5C6C),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${event.totalSeats} seats',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createEvent');
        },
        backgroundColor: const Color(0xFF0D5C6C),
        child: const Icon(Icons.add),
      ),
    );
  }
}
