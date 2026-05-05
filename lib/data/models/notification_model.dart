import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // 'order', 'promo', 'system'
  final DateTime createdAt;
  final bool isRead;
  final String? orderId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    DateTime? createdAt,
    this.isRead = false,
    this.orderId,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'orderId': orderId,
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    try { return (value).toDate(); } catch (_) {}
    return null;
  }

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'system',
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
      orderId: json['orderId'],
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      orderId: orderId,
    );
  }

  IconData get iconData {
    switch (type) {
      case 'order':
        return Icons.receipt_long_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }
}
