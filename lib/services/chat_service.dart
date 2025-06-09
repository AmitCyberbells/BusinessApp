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

      // Try different ways to get the ID
      String? businessIdStr = prefs.getString('business_id');
      debugPrint('business_id from SharedPreferences (string): $businessIdStr');

      if (businessIdStr != null) {
        try {
          _currentUserId = int.parse(businessIdStr);
          debugPrint(
              'Successfully parsed business_id string to int: $_currentUserId');
        } catch (e) {
          debugPrint('Failed to parse business_id string to int: $e');
        }
      }

      // If business_id not found or invalid, try user_id
      if (_currentUserId == null) {
        String? userIdStr = prefs.getString('user_id');
        debugPrint('user_id from SharedPreferences (string): $userIdStr');

        if (userIdStr != null) {
          try {
            _currentUserId = int.parse(userIdStr);
            debugPrint(
                'Successfully parsed user_id string to int: $_currentUserId');
          } catch (e) {
            debugPrint('Failed to parse user_id string to int: $e');
          }
        }
      }

      // If still no valid ID, try getting business_id as int
      if (_currentUserId == null) {
        _currentUserId = prefs.getInt('business_id');
        debugPrint('business_id from SharedPreferences (int): $_currentUserId');
      }

      // Final validation
      if (_currentUserId == null) {
        debugPrint('No user ID found in SharedPreferences');
        throw Exception('User not authenticated - Please log in again');
      }

      final userId =
          _currentUserId!; // Non-null assertion is safe here because we checked above
      if (userId <= 0) {
        debugPrint('Invalid user ID found in SharedPreferences: $userId');
        throw Exception('Invalid user ID - Please log in again');
      }

      debugPrint('Chat service initialized successfully with ID: $userId');
    } catch (e) {
      debugPrint('Error initializing chat service: $e');
      rethrow;
    }
  }

  static int? getCurrentUserId() {
    return _currentUserId;
  }

  static Future<List<ChatMessage>> getMessages() async {
    try {
      await initialize(); // Make sure we're initialized first
      debugPrint('Getting chat list - Current business ID: $_currentUserId');

      final token = await AuthService.getAuthToken();
      if (token == null) {
        debugPrint('Error: Authentication token not found');
        throw Exception('Authentication token not found');
      }
      debugPrint('Auth token retrieved successfully');

      final url = '$baseUrl/api/customer-business/chat/list';
      debugPrint('Fetching chat list from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Chat list response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      // Log response body only if there's an error
      if (response.statusCode != 200) {
        debugPrint('Error response body: ${response.body}');
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Unknown error';
        throw Exception(
            'Failed to load chat list: $errorMessage (Status: ${response.statusCode})');
      }

      debugPrint('Parsing chat list response...');
      final List<dynamic> data = json.decode(response.body);
      debugPrint('Found ${data.length} chats in the list');

      final messages = data.map((json) {
        try {
          debugPrint('Processing chat item: $json');
          return ChatMessage.fromJson(json);
        } catch (e) {
          debugPrint('Error parsing chat item: $e');
          debugPrint('Problematic JSON: $json');
          rethrow;
        }
      }).toList();

      debugPrint('Successfully processed ${messages.length} chat items');
      return messages;
    } catch (e, stackTrace) {
      debugPrint('Error loading chat list: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to load chat list: $e');
    }
  }

  /// Get chat history between business and customer
  /// @param receiverId - When called from business app, this should be the customer_id
  /// For two-way chat, this retrieves both sent and received messages between business and customer
  static Future<List<ChatDetailMessage>> getChatHistory(int receiverId) async {
    try {
      await initialize(); // Make sure we're initialized
      final token = await AuthService.getAuthToken();
      if (token == null) {
        debugPrint('Error: No auth token found');
        throw Exception('Authentication token not found');
      }

      // Log the context of the chat
      debugPrint(
          'Business App: Fetching chat history with customer ID: $receiverId');
      debugPrint('Current business ID: $_currentUserId');

      final url = '$baseUrl/api/chat/messages/$receiverId';
      debugPrint('Request URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Chat history response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        debugPrint('Error response body: ${response.body}');
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Unknown error';
        throw Exception('Failed to load chat history: $errorMessage');
      }

      // Parse the response
      debugPrint('Parsing chat history response...');
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Extract messages array from the response
      final List<dynamic> messagesData = responseData['messages'] ?? [];
      debugPrint('Found ${messagesData.length} messages in response');

      final messages = messagesData.map((json) {
        try {
          final message = ChatDetailMessage.fromJson(json);
          // Log message direction for debugging
          final direction = message.senderId == _currentUserId
              ? 'sent to customer'
              : 'received from customer';
          debugPrint('Processing message $direction - ID: ${message.id}');
          return message;
        } catch (e) {
          debugPrint('Error parsing message: $e');
          debugPrint('Problematic JSON: $json');
          rethrow;
        }
      }).toList();

      // Sort messages by creation time
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      debugPrint(
          'Returning ${messages.length} messages in chronological order');

      return messages;
    } catch (e) {
      debugPrint('Error getting chat history: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  static Future<bool> sendChatMessage({
    required int
        receiverId, // If sending as business: use customer_id, if sending as customer: use business_id
    required String message,
  }) async {
    try {
      final token = await AuthService.getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      debugPrint('Sending message to receiver ID: $receiverId');
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
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Unknown error';
        throw Exception('Failed to send message: $errorMessage');
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
