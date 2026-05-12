class CouponModel {
  String? id;
  String code;
  double discountAmount;
  String discountType; // 'percentage' or 'fixed'
  DateTime expiryDate;
  double minOrderAmount;

  CouponModel({
    this.id,
    required this.code,
    required this.discountAmount,
    required this.discountType,
    required this.expiryDate,
    required this.minOrderAmount,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'discountAmount': discountAmount,
    'discountType': discountType,
    'expiryDate': expiryDate.toIso8601String(),
    'minOrderAmount': minOrderAmount,
  };

  factory CouponModel.fromJson(Map<String, dynamic> json, String docId) => CouponModel(
    id: docId,
    code: json['code'] ?? '',
    discountAmount: (json['discountAmount'] ?? 0).toDouble(),
    discountType: json['discountType'] ?? 'fixed',
    expiryDate: DateTime.parse(json['expiryDate']),
    minOrderAmount: (json['minOrderAmount'] ?? 0).toDouble(),
  );
}
