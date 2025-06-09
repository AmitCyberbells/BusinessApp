class DashboardData {
  final int businessId;
  final int todayCheckins;
  final int todayRewardClaims;
  final ActiveCustomers activeCustomers;
  final List<RecentCustomer> recentActiveCustomers;
  final int openComplaintsLast30Days;

  DashboardData({
    required this.businessId,
    required this.todayCheckins,
    required this.todayRewardClaims,
    required this.activeCustomers,
    required this.recentActiveCustomers,
    required this.openComplaintsLast30Days,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      businessId: json['business_id'] ?? 0,
      todayCheckins: json['today_checkins'] ?? 0,
      todayRewardClaims: json['today_reward_claims'] ?? 0,
      activeCustomers: ActiveCustomers.fromJson(
          json['active_customers'] ?? {'weekly': 0, 'monthly': 0}),
      recentActiveCustomers: (json['recent_active_customers'] as List<dynamic>?)
              ?.map((e) => RecentCustomer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      openComplaintsLast30Days: json['open_complaints_last_30_days'] ?? 0,
    );
  }

  factory DashboardData.empty() {
    return DashboardData(
      businessId: 0,
      todayCheckins: 0,
      todayRewardClaims: 0,
      activeCustomers: ActiveCustomers(weekly: 0, monthly: 0),
      recentActiveCustomers: [],
      openComplaintsLast30Days: 0,
    );
  }
}

class ActiveCustomers {
  final int weekly;
  final int monthly;

  ActiveCustomers({
    required this.weekly,
    required this.monthly,
  });

  factory ActiveCustomers.fromJson(Map<String, dynamic> json) {
    return ActiveCustomers(
      weekly: json['weekly'] ?? 0,
      monthly: json['monthly'] ?? 0,
    );
  }
}

class RecentCustomer {
  final int customerId;
  final String name;
  final String? profileImage;
  final String checkInTime;

  RecentCustomer({
    required this.customerId,
    required this.name,
    this.profileImage,
    required this.checkInTime,
  });

  factory RecentCustomer.fromJson(Map<String, dynamic> json) {
    return RecentCustomer(
      customerId: json['customer_id'] ?? 0,
      name: json['name'] ?? '',
      profileImage: json['profile_image'],
      checkInTime: json['check_in_time'] ?? '',
    );
  }

  String get date => checkInTime.split(' ')[0];
  String get time => checkInTime.split(' ')[1];
}
