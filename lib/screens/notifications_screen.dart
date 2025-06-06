import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/notification.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../utils/auth_service.dart';

class NotificationsScreen extends StatefulWidget {
  final int businessId;

  const NotificationsScreen({
    Key? key,
    required this.businessId,
  }) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _initializeAuthToken();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeAuthToken() async {
    try {
      final token = await AuthService.getAuthToken();
      debugPrint(
          'Auth Token: ${token?.substring(0, 10)}...'); // Print first 10 chars of token

      if (token == null) {
        setState(() {
          _error = 'Not authenticated. Please login again.';
        });
        return;
      }
      setState(() {
        _authToken = token;
      });
      await _fetchNotifications();
    } catch (e) {
      setState(() {
        _error = 'Error initializing: $e';
      });
      debugPrint('Error initializing auth token: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        _fetchNotifications();
      }
    }
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateTime now = DateTime.now();
      final DateTime yesterday = now.subtract(const Duration(days: 1));

      if (parsedDate.year == now.year &&
          parsedDate.month == now.month &&
          parsedDate.day == now.day) {
        return DateFormat('hh:mm a').format(parsedDate);
      } else if (parsedDate.year == yesterday.year &&
          parsedDate.month == yesterday.month &&
          parsedDate.day == yesterday.day) {
        return 'Yesterday ${DateFormat('hh:mm a').format(parsedDate)}';
      } else {
        return DateFormat('MMM dd, yyyy hh:mm a').format(parsedDate);
      }
    } catch (e) {
      return date;
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[300],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _notifications.clear();
                  _currentPage = 1;
                  _hasMore = true;
                });
                _initializeAuthToken();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'push':
        iconData = LucideIcons.bell;
        backgroundColor = const Color(0xFFE3F2FD);
        iconColor = Colors.blue;
        break;
      case 'event':
        iconData = LucideIcons.calendar;
        backgroundColor = const Color(0xFFE8F5E9);
        iconColor = Colors.green;
        break;
      case 'contest':
        iconData = LucideIcons.trophy;
        backgroundColor = const Color(0xFFFFF3E0);
        iconColor = Colors.orange;
        break;
      default:
        iconData = LucideIcons.bell;
        backgroundColor = const Color(0xFFE0E0E0);
        iconColor = Colors.grey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Future<void> _fetchNotifications() async {
    if (_isLoading || _authToken == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final url = Uri.parse(
          'https://dev.frequenters.com/api/notifications?page=$_currentPage&business_id=${widget.businessId}');
      debugPrint('Fetching notifications from: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint('Decoded response data: $responseData');

        if (responseData['success'] == true) {
          final data = NotificationsResponse.fromJson(responseData);
          setState(() {
            _notifications.addAll(data.notifications);
            _hasMore = data.hasMore;
            _currentPage++;
            _isLoading = false;
            _error = null;
          });
        } else {
          throw Exception(
              responseData['message'] ?? 'Failed to load notifications');
        }
      } else if (response.statusCode == 401) {
        debugPrint('Unauthorized access. Clearing auth data.');
        await AuthService.clearAuthData();
        throw Exception('Session expired. Please login again.');
      } else {
        debugPrint('Server error with status code: ${response.statusCode}');
        throw Exception(
            'Server error: ${response.statusCode}\nResponse: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      setState(() {
        _isLoading = false;
        _error = 'Error: ${e.toString()}';
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
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _error != null
          ? _buildErrorWidget()
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _notifications.clear();
                  _currentPage = 1;
                  _hasMore = true;
                });
                await _fetchNotifications();
              },
              child: _notifications.isEmpty && !_isLoading
                  ? const Center(
                      child: Text('No notifications'),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _notifications.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _notifications.length) {
                          if (_isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }

                        final notification = _notifications[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              _buildNotificationIcon(notification.type),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.message,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(notification.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
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
    );
  }
}
