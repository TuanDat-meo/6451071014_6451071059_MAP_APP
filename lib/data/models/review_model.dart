class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final String orderId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.orderId,
    required this.rating,
    required this.comment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'productName': productName,
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    try { return (value).toDate(); } catch (_) {}
    return null;
  }

  factory ReviewModel.fromJson(Map<dynamic, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Ẩn danh',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      orderId: json['orderId'] ?? '',
      rating: (json['rating'] ?? 5).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
    );
  }
}
