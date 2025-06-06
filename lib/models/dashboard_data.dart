import 'package:flutter/foundation.dart';

class DashboardData {
  final int todayCheckins;
  final int todayRewardClaims;
  final ActiveCustomers activeCustomers;
  final List<RecentCustomer> recentActiveCustomers;
  final int openComplaintsLast30Days;

  DashboardData({
    required this.todayCheckins,
    required this.todayRewardClaims,
    required this.activeCustomers,
    required this.recentActiveCustomers,
    required this.openComplaintsLast30Days,
  });

  // Factory constructor for empty state
  factory DashboardData.empty() {
    return DashboardData(
      todayCheckins: 0,
      todayRewardClaims: 0,
      activeCustomers: ActiveCustomers(weekly: 0, monthly: 0),
      recentActiveCustomers: [],
      openComplaintsLast30Days: 0,
    );
  }

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    try {
      return DashboardData(
        todayCheckins: _parseIntValue(json['today_checkins']),
        todayRewardClaims: _parseIntValue(json['today_reward_claims']),
        activeCustomers: ActiveCustomers.fromJson(
            json['active_customers'] ?? {'weekly': 0, 'monthly': 0}),
        recentActiveCustomers: ((json['recent_active_customers'] ?? []) as List)
            .map((item) => RecentCustomer.fromJson(item ?? {}))
            .toList(),
        openComplaintsLast30Days:
            _parseIntValue(json['open_complaints_last_30_days']),
      );
    } catch (e) {
      debugPrint('Error parsing DashboardData: $e');
      return DashboardData(
        todayCheckins: 0,
        todayRewardClaims: 0,
        activeCustomers: ActiveCustomers(weekly: 0, monthly: 0),
        recentActiveCustomers: [],
        openComplaintsLast30Days: 0,
      );
    }
  }

  static int _parseIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
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
    try {
      return ActiveCustomers(
        weekly: DashboardData._parseIntValue(json['weekly']),
        monthly: DashboardData._parseIntValue(json['monthly']),
      );
    } catch (e) {
      debugPrint('Error parsing ActiveCustomers: $e');
      return ActiveCustomers(weekly: 0, monthly: 0);
    }
  }
}

class RecentCustomer {
  final String name;
  final String date;
  final String time;
  final String? avatar;

  RecentCustomer({
    required this.name,
    required this.date,
    required this.time,
    this.avatar,
  });

  factory RecentCustomer.fromJson(Map<String, dynamic> json) {
    try {
      final DateTime dateTime =
          DateTime.parse(json['date'] ?? DateTime.now().toIso8601String());
      return RecentCustomer(
        name: json['name']?.toString() ?? 'Unknown',
        date: '${dateTime.day}/${dateTime.month}/${dateTime.year}',
        time:
            '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
        avatar: json['avatar']?.toString(),
      );
    } catch (e) {
      debugPrint('Error parsing RecentCustomer: $e');
      final now = DateTime.now();
      return RecentCustomer(
        name: 'Unknown',
        date: '${now.day}/${now.month}/${now.year}',
        time:
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        avatar: null,
      );
    }
  }
}
