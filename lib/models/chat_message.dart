class ChatMessage {
  final int id;
  final String senderName;
  final String message;
  final String senderImage;
  final String time;
  final bool isRead;
  final int? unreadCount;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.message,
    required this.senderImage,
    required this.time,
    required this.isRead,
    this.unreadCount,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      senderName: json['sender_name']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      senderImage: json['sender_image']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      isRead: json['is_read'] == true,
      unreadCount: json['unread_count'] != null
          ? int.parse(json['unread_count'].toString())
          : null,
    );
  }
}
