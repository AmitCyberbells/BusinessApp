import 'package:intl/intl.dart';

class ChatDetailMessage {
  final int id;
  final int? businessId;
  final int senderId;
  final int receiverId;
  final String messageText;
  final String? groupTarget;
  final int chatEnabled;
  final int enableButtons;
  final int isGroupMessage;
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
    return ChatDetailMessage(
      id: json['id'] ?? 0,
      businessId: json['business_id'],
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      messageText: json['message_text'] ?? '',
      groupTarget: json['group_target'],
      chatEnabled: json['chat_enabled'] ?? 0,
      enableButtons: json['enable_buttons'] ?? 0,
      isGroupMessage: json['is_group_message'] ?? 0,
      readBy: List<int>.from(json['read_by'] ?? []),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      senderName: json['sender_name'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      senderImage: json['sender_image'],
      receiverImage: json['receiver_image'],
      timeAgo: json['time_ago'] ?? '',
    );
  }

  // Helper method to check if the message is from the current user
  bool isFromCurrentUser(int? currentUserId) {
    return senderId == currentUserId;
  }
}
