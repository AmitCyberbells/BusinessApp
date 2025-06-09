import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:business_app/models/chat_message.dart';
import 'package:business_app/models/chat_detail_message.dart';
import 'package:business_app/utils/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String baseUrl = 'https://dev.frequenters.com';
  static int? _currentUserId;
  static final Map<int, Function(ChatDetailMessage)> _messageCallbacks = {};
  static final Map<int, bool> _pollingActive = {};

  static Future<void> initialize() async {
    try {
      debugPrint('Initializing chat service...');
      final prefs = await SharedPreferences.getInstance();

      // Log all available keys in SharedPreferences
      final keys = prefs.getKeys();
      debugPrint('Available SharedPreferences keys: $keys');

      // First try to get business_id
      _currentUserId = prefs.getInt('business_id');
      debugPrint('business_id from SharedPreferences: $_currentUserId');

      // If not found, try user_id as string and convert to int
      if (_currentUserId == null) {
        final userIdStr = prefs.getString('user_id');
        debugPrint('user_id from SharedPreferences (string): $userIdStr');

        if (userIdStr != null) {
          _currentUserId = int.tryParse(userIdStr);
          debugPrint('Converted user_id string to int: $_currentUserId');
        }
      }

      if (_currentUserId == null) {
        debugPrint('No valid user ID found in SharedPreferences');
        throw Exception('User not authenticated - Please log in again');
      }

      debugPrint(
          'Chat service initialized successfully with ID: $_currentUserId');
    } catch (e) {
      debugPrint('Error initializing chat service: $e');
      rethrow;
    }
  }

  static Future<List<ChatMessage>> getMessages() async {
    try {
      final token = await AuthService.getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/customer-business/chat/list'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load chat list: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to load chat list');
      }
    } catch (e) {
      debugPrint('Error loading chat list: $e');
      throw Exception('Failed to load chat list: $e');
    }
  }

  static Future<List<ChatDetailMessage>> getChatHistory(int receiverId) async {
    try {
      final token = await AuthService.getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      debugPrint('Fetching chat history for receiver ID: $receiverId');
      final response = await http.get(
        Uri.parse('$baseUrl/api/chat/messages/$receiverId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Chat history response status: ${response.statusCode}');
      debugPrint('Chat history response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? [];
        final messages =
            data.map((json) => ChatDetailMessage.fromJson(json)).toList();

        // Sort messages by creation time to ensure chronological order
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        return messages;
      } else {
        debugPrint('Failed to load chat history: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to load chat history');
      }
    } catch (e) {
      debugPrint('Error getting chat history: $e');
      rethrow;
    }
  }

  static Future<bool> sendChatMessage({
    required int receiverId,
    required String message,
  }) async {
    try {
      final token = await AuthService.getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/business/chat/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'receiver_id': receiverId,
          'message_text': message,
        }),
      );

      debugPrint('Send message response status: ${response.statusCode}');
      debugPrint('Send message response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      rethrow;
    }
  }

  static Future<bool> sendMessage({
    required String messageText,
    required String groupTarget,
    required bool chatEnabled,
    required bool enableButtons,
  }) async {
    try {
      final token = await AuthService.getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/customer-business/broadcast'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': messageText,
          'group_target': groupTarget,
          'chat_enabled': chatEnabled,
          'enable_buttons': enableButtons,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to send broadcast: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to send broadcast message');
      }
    } catch (e) {
      debugPrint('Error sending broadcast message: $e');
      return false;
    }
  }

  static void subscribeToChat(
    int receiverId,
    Function(ChatDetailMessage) onMessageReceived,
  ) {
    _messageCallbacks[receiverId] = onMessageReceived;
    _pollingActive[receiverId] = true;
    _startPolling(receiverId);
  }

  static void _startPolling(int receiverId) async {
    while (_pollingActive[receiverId] == true) {
      try {
        final messages = await getChatHistory(receiverId);
        final lastMessage = messages.isNotEmpty ? messages.last : null;

        if (lastMessage != null && _messageCallbacks.containsKey(receiverId)) {
          _messageCallbacks[receiverId]!(lastMessage);
        }
      } catch (e) {
        debugPrint('Error polling messages: $e');
      }

      // Wait for 3 seconds before next poll
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  static void unsubscribeFromChat(int receiverId) {
    _messageCallbacks.remove(receiverId);
    _pollingActive[receiverId] = false;
  }

  static void dispose() {
    _currentUserId = null;
    _messageCallbacks.clear();
    _pollingActive.clear();
  }
}
