class UserModel {
  final String uid;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? avatarUrl;

  UserModel({
    required this.uid,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
