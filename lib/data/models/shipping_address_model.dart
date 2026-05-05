class ShippingAddress {
  final String id;
  final String userId;
  final String recipientName;
  final String phoneNumber;
  final String address;
  final String ward;
  final String district;
  final String province;
  final String postalCode;
  bool isDefault;
  final DateTime createdAt;

  ShippingAddress({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phoneNumber,
    required this.address,
    required this.ward,
    required this.district,
    required this.province,
    required this.postalCode,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Full address string
  String getFullAddress() {
    return '$address, $ward, $district, $province, $postalCode';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'address': address,
      'ward': ward,
      'district': district,
      'province': province,
      'postalCode': postalCode,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ShippingAddress.fromJson(Map<dynamic, dynamic> json) {
    return ShippingAddress(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      recipientName: json['recipientName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      ward: json['ward'] ?? '',
      district: json['district'] ?? '',
      province: json['province'] ?? '',
      postalCode: json['postalCode'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  ShippingAddress copyWith({
    String? id,
    String? userId,
    String? recipientName,
    String? phoneNumber,
    String? address,
    String? ward,
    String? district,
    String? province,
    String? postalCode,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recipientName: recipientName ?? this.recipientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
