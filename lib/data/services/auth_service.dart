import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<String?> login(String email, String password) async {
    try {
      // Kiểm tra user có verified không
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        return 'Email không tồn tại trong hệ thống';
      }

      final userData = userSnapshot.docs.first.data();
      
      // Kiểm tra xem user đã verified chưa
      if (userData['verified'] != true) {
        return 'Tài khoản của bạn chưa được xác minh. Vui lòng liên hệ quản trị viên.';
      }

      // Kiểm tra password
      if (userData['password'] != password) {
        return 'Mật khẩu không chính xác';
      }

      // Kiểm tra user có active không
      if (userData['isActive'] != true) {
        return 'Tài khoản của bạn đã bị vô hiệu hóa';
      }

      return null; // Success - no error
    } catch (e) {
      return 'Lỗi đăng nhập: $e';
    }
  }

  Future<String?> register(String name, String email, String password, String confirmPassword) async {
    try {
      if (password != confirmPassword) {
        return 'Mật khẩu xác nhận không khớp';
      }

      // Kiểm tra email đã tồn tại chưa
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        return 'Email đã được sử dụng. Vui lòng sử dụng email khác';
      }

      // Tạo user mới
      await _firestore.collection('users').add({
        'name': name,
        'email': email,
        'password': password,
        'phone': '',
        'address': '',
        'avatar': '',
        'role': 'customer',
        'verified': false,
        'isActive': true,
        'createdAt': Timestamp.now(),
      });

      return null; // Success
    } catch (e) {
      return 'Lỗi đăng ký: $e';
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser(String email) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        return null;
      }

      return userSnapshot.docs.first.data();
    } catch (e) {
      return null;
    }
  }
}
