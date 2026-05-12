import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var isLoading = false.obs;
  var isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _checkRole(user.uid);
      } else {
        isAdmin.value = false;
      }
    });
  }

  /// HÀM TẠO ADMIN HOÀN CHỈNH - CHỈ CHẠY 1 LẦN
  Future<void> createFirstAdmin() async {
    const String email = "admin@system.com";
    const String password = "Admin123456";

    try {
      print("LOG: Đang kiểm tra/tạo tài khoản Admin...");
      
      UserCredential userCredential;
      try {
        // Thử tạo mới tài khoản
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print("LOG: Đã tạo tài khoản Auth mới.");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          print("LOG: Tài khoản Auth đã có, đang thử đăng nhập để đồng bộ...");
          userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
          print("LOG: Đăng nhập thành công để đồng bộ Firestore.");
        } else {
          print("LỖI AUTH KHI TẠO (${e.code}): ${e.message}");
          rethrow;
        }
      }

      // Tạo hồ sơ Admin hoàn chỉnh trong Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'role': 'admin',
        'fullName': 'Quản trị viên tối cao',
        'phoneNumber': '0901234567',
        'status': 'active',
        'avatar': 'https://ui-avatars.com/api/?name=Admin&background=0D47A1&color=fff',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'permissions': ['all'], 
      }, SetOptions(merge: true));

      print("SUCCESS: TÀI KHOẢN ADMIN ĐÃ SẴN SÀNG!");
      print("Email: $email | Password: $password");
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed') {
        print("LỖI: Bạn chưa bật Email/Password trong Firebase Console!");
      } else {
        print("LỖI FIREBASE (${e.code}): ${e.message}");
      }
    } catch (e) {
      print("LỖI HỆ THỐNG: $e");
    }
  }

  Future<void> _checkRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.get('role') == 'admin') {
        isAdmin.value = true;
      } else {
        isAdmin.value = false;
        await _auth.signOut();
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      print("LỖI KIỂM TRA QUYỀN: $e");
      isAdmin.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      print("LOG: Đang đăng nhập cho $email...");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
      
      print("LOG: Đăng nhập Auth thành công, UID: ${userCredential.user!.uid}");
      await _checkRole(userCredential.user!.uid);
      
      if (isAdmin.value) {
        print("LOG: Quyền Admin hợp lệ, chuyển hướng Dashboard...");
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        print("LOG: Từ chối - User không phải Admin.");
        Get.snackbar('Từ chối', 'Bạn không có quyền quản trị');
      }
    } on FirebaseAuthException catch (e) {
      print("LỖI ĐĂNG NHẬP (${e.code}): ${e.message}");
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: ${e.message}');
    } catch (e) {
      print("LỖI HỆ THỐNG: $e");
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi không mong muốn');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    isAdmin.value = false;
    Get.offAllNamed(AppRoutes.login);
  }
}
