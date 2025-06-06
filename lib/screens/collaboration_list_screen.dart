import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/collaboration.dart';

class CollaborationListScreen extends StatefulWidget {
  const CollaborationListScreen({super.key});

  @override
  State<CollaborationListScreen> createState() =>
      _CollaborationListScreenState();
}

class _CollaborationListScreenState extends State<CollaborationListScreen> {
  List<Collaboration> collaborations = [];
  List<Collaboration> invites = [];
  List<Collaboration> ongoingCollaborations = [];
  List<Collaboration> previousCollaborations = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchCollaborations();
  }

  Future<void> _fetchCollaborations() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final businessId = prefs.getString('business_id');

      if (token == null || businessId == null) {
        throw Exception('Authentication token or business ID not found');
      }

      final url =
          'https://dev.frequenters.com/api/business/collaboration/$businessId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Debug - Response status: ${response.statusCode}'); // Debug log
      print('Debug - Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final List<dynamic> collabList = json.decode(response.body);
        final allCollaborations =
            collabList.map((collab) => Collaboration.fromJson(collab)).toList();

        setState(() {
          // Filter collaborations based on status
          invites = allCollaborations
              .where((c) => c.status.toLowerCase() == 'pending')
              .toList();
          ongoingCollaborations = allCollaborations
              .where((c) => c.status.toLowerCase() == 'active')
              .toList();
          previousCollaborations = allCollaborations
              .where((c) => c.status.toLowerCase() == 'completed')
              .toList();
        });
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['message'] ?? 'Failed to load collaborations');
      }
    } catch (e) {
      print('Debug - Error: $e'); // Debug log
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF005B71),
        onPressed: () {
          Navigator.pushNamed(context, '/setup-collab');
        },
        child: const Icon(Icons.add, size: 30),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Collaboration List',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchCollaborations,
          ),
        ],
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchCollaborations,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchCollaborations,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle('Collaborations Invite'),
                        if (invites.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No pending invites'),
                          )
                        else
                          ...invites.map((invite) => inviteCard(invite)),
                        const SizedBox(height: 16),
                        sectionTitle('Ongoing Collaborations'),
                        if (ongoingCollaborations.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No ongoing collaborations'),
                          )
                        else
                          ...ongoingCollaborations
                              .map((collab) => collaborationCard(collab)),
                        const SizedBox(height: 16),
                        sectionTitle('Previous Collaborations'),
                        if (previousCollaborations.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No previous collaborations'),
                          )
                        else
                          ...previousCollaborations.map((collab) =>
                              collaborationCard(collab, isPrevious: true)),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget inviteCard(Collaboration collaboration) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                          text: 'Business Name: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${collaboration.businessName}\n'),
                      const TextSpan(
                          text: 'Owner Name: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: collaboration.ownerName),
                    ],
                  ),
                ),
              ),
              Chip(
                backgroundColor: const Color(0xFFE5F4F8),
                label: Text('Status: ${collaboration.status}',
                    style: const TextStyle(color: Color(0xFF007E9E))),
              )
            ],
          ),
          const SizedBox(height: 10),
          if (collaboration.description.isNotEmpty) ...[
            Text(
              'Description: ${collaboration.description}',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 12),
          ],
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005B71),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Center(
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Start Date\n',
                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: collaboration
                            .getFormattedDate(collaboration.startDate),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'End Date\n',
                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: collaboration
                            .getFormattedDate(collaboration.endDate),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget collaborationCard(Collaboration collaboration,
      {bool isPrevious = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                    text: 'Business Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '${collaboration.businessName}\n'),
                TextSpan(
                  text: isPrevious ? 'Owner/partner Name: ' : 'Owner Name: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: collaboration.ownerName),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005B71),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Center(
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Start Date\n',
                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: collaboration
                            .getFormattedDate(collaboration.startDate),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'End Date\n',
                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: collaboration
                            .getFormattedDate(collaboration.endDate),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
