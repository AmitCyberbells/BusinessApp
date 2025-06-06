import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:business_app/models/chat_message.dart';
import 'package:business_app/utils/constants.dart';

class ChatService {
  static Future<List<ChatMessage>> getMessages(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/chat/messages/$userId'),
        headers: {
          //  'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          // Add any required headers like authorization tokens here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }
}
