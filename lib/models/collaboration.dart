import 'package:intl/intl.dart';

class Collaboration {
  final int id;
  final String businessName;
  final String ownerName;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  Collaboration({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Collaboration.fromJson(Map<String, dynamic> json) {
    return Collaboration(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      description: json['description'] ?? '',
      startDate:
          DateTime.parse(json['start_date'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toString()),
      status: json['status'] ?? 'pending',
    );
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('dd MMM yy').format(date);
  }
}

class CollaborationRequest {
  final int partnerBusinessId;
  final String targetBusinessType;
  final String description;
  final String startDate;
  final String endDate;
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final String socialLinks;

  CollaborationRequest({
    required this.partnerBusinessId,
    required this.targetBusinessType,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.socialLinks,
  });

  Map<String, dynamic> toJson() {
    return {
      'partner_business_id': partnerBusinessId,
      'target_business_type': targetBusinessType,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'contact_name': contactName,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'social_links': socialLinks,
    };
  }
}
