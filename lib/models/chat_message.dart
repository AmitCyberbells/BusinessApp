class ChatMessage {
  final int id;
  final String name;
  final String? profileImage;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;
  final bool isLastMessageRead;

  ChatMessage({
    required this.id,
    required this.name,
    this.profileImage,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    required this.isLastMessageRead,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profileImage: json['profile_image'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
      unreadCount: json['unread_count'] ?? 0,
      isLastMessageRead: json['is_last_message_read'] ?? false,
    );
  }
}
