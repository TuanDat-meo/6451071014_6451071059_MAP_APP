import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String fullName;
  String role;
  String phoneNumber;
  String status;
  DateTime createdAt;
  List<String> permissions;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneNumber = '',
    this.status = 'active',
    required this.createdAt,
    this.permissions = const [],
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'fullName': fullName,
    'role': role,
    'phoneNumber': phoneNumber,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'permissions': permissions,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] ?? '',
    email: json['email'] ?? '',
    fullName: json['fullName'] ?? '',
    role: json['role'] ?? 'user',
    phoneNumber: json['phoneNumber'] ?? '',
    status: json['status'] ?? 'active',
    createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
    permissions: List<String>.from(json['permissions'] ?? []),
  );
}
