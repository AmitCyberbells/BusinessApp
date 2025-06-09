import 'package:intl/intl.dart';
import 'dart:convert';

class ChatDetailMessage {
  final int id;
  final int? businessId;
  final int senderId;
  final int receiverId;
  final String messageText;
  final String? groupTarget;
  final bool chatEnabled;
  final bool enableButtons;
  final bool isGroupMessage;
  final List<int> readBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String senderName;
  final String receiverName;
  final String? senderImage;
  final String? receiverImage;
  final String timeAgo;

  ChatDetailMessage({
    required this.id,
    this.businessId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    this.groupTarget,
    required this.chatEnabled,
    required this.enableButtons,
    required this.isGroupMessage,
    required this.readBy,
    required this.createdAt,
    required this.updatedAt,
    required this.senderName,
    required this.receiverName,
    this.senderImage,
    this.receiverImage,
    required this.timeAgo,
  });

  factory ChatDetailMessage.fromJson(Map<String, dynamic> json) {
    try {
      // Parse readBy array
      List<int> readByList = [];
      if (json['read_by'] != null) {
        if (json['read_by'] is String) {
          // If read_by is a JSON string, parse it
          try {
            final decoded = jsonDecode(json['read_by']);
            if (decoded is List) {
              readByList = decoded.map((e) => int.parse(e.toString())).toList();
            }
          } catch (e) {
            print('Error parsing read_by JSON string: $e');
          }
        } else if (json['read_by'] is List) {
          readByList = (json['read_by'] as List)
              .map((e) => int.parse(e.toString()))
              .toList();
        }
      }

      // Parse dates
      DateTime parseDate(String? dateStr) {
        if (dateStr == null) return DateTime.now();
        try {
          return DateTime.parse(dateStr);
        } catch (e) {
          print('Error parsing date: $e');
          return DateTime.now();
        }
      }

      // Parse boolean values
      bool parseBool(dynamic value) {
        if (value is bool) return value;
        if (value is int) return value == 1;
        if (value is String)
          return value.toLowerCase() == 'true' || value == '1';
        return false;
      }

      return ChatDetailMessage(
        id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        businessId: int.tryParse(json['business_id']?.toString() ?? ''),
        senderId: int.tryParse(json['sender_id']?.toString() ?? '0') ?? 0,
        receiverId: int.tryParse(json['receiver_id']?.toString() ?? '0') ?? 0,
        messageText: json['message_text']?.toString() ?? '',
        groupTarget: json['group_target']?.toString(),
        chatEnabled: parseBool(json['chat_enabled']),
        enableButtons: parseBool(json['enable_buttons']),
        isGroupMessage: parseBool(json['is_group_message']),
        readBy: readByList,
        createdAt: parseDate(json['created_at']?.toString()),
        updatedAt: parseDate(json['updated_at']?.toString()),
        senderName: json['sender_name']?.toString() ?? 'Unknown',
        receiverName: json['receiver_name']?.toString() ?? 'Unknown',
        senderImage: json['sender_image']?.toString(),
        receiverImage: json['receiver_image']?.toString(),
        timeAgo: json['time_ago']?.toString() ?? '',
      );
    } catch (e, stackTrace) {
      print('Error parsing ChatDetailMessage: $e');
      print('Stack trace: $stackTrace');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  // Helper method to check if the message is from the current user
  bool isFromCurrentUser(int? currentUserId) {
    return senderId == currentUserId;
  }
}
