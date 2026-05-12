class CustomerModel {
  String? id;
  String fullName;
  String email;
  String? phoneNumber;
  String? avatarUrl;
  DateTime? createdAt;

  CustomerModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'avatarUrl': avatarUrl,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory CustomerModel.fromJson(Map<String, dynamic> json, String documentId) => CustomerModel(
    id: documentId,
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    phoneNumber: json['phoneNumber'],
    avatarUrl: json['avatarUrl'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );
}
