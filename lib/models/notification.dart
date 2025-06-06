class NotificationModel {
  final int id;
  final int? customerId;
  final int businessId;
  final String type;
  final String status;
  final String message;
  final String createdAt;
  final String priority;
  final bool isBroadcast;

  NotificationModel({
    required this.id,
    this.customerId,
    required this.businessId,
    required this.type,
    required this.status,
    required this.message,
    required this.createdAt,
    required this.priority,
    required this.isBroadcast,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'],
      businessId: json['business_id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
      priority: json['priority'] ?? 'medium',
      isBroadcast: json['is_broadcast'] == 1,
    );
  }
}

class NotificationsResponse {
  final List<NotificationModel> notifications;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int total;

  NotificationsResponse({
    required this.notifications,
    required this.currentPage,
    required this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.total,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final notificationsData = json['notifications'] ?? {};
    final List<dynamic> data = notificationsData['data'] ?? [];

    return NotificationsResponse(
      notifications:
          data.map((item) => NotificationModel.fromJson(item)).toList(),
      currentPage: notificationsData['current_page'] ?? 1,
      lastPage: notificationsData['last_page'] ?? 1,
      nextPageUrl: notificationsData['next_page_url'],
      prevPageUrl: notificationsData['prev_page_url'],
      total: notificationsData['total'] ?? 0,
    );
  }

  bool get hasMore => nextPageUrl != null;
}
