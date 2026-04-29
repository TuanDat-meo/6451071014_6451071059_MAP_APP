import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/boba_model.dart';

class FirebaseService {
  // Kết nối tới các nhóm dữ liệu (Collections/Nodes)
  final DatabaseReference _productsRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://vs6451071059-default-rtdb.asia-southeast1.firebasedatabase.app'
  ).ref().child('products');

  final DatabaseReference _usersRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://vs6451071059-default-rtdb.asia-southeast1.firebasedatabase.app'
  ).ref().child('users');

  Future<void> seedData() async {
    try {
      // Xóa dữ liệu cũ và ghi đè dữ liệu mới
      await _productsRef.remove();

      List<BobaModel> dummyProducts = [
        BobaModel(
          name: 'Trà Sữa Trân Châu Đường Đen',
          price: 45000,
          image: 'assets/images/image.png',
          description: 'Sự kết hợp hoàn hảo giữa sữa tươi đá xay và trân châu đường đen ngọt ngào.',
          category: 'Trà Sữa',
        ),
        BobaModel(
          name: 'Trà Đào Cam Sả',
          price: 35000,
          image: 'assets/images/image1.png',
          description: 'Vị trà đào thanh mát kết hợp cùng cam tươi và sả thơm nồng.',
          category: 'Trà Trái Cây',
        ),
        BobaModel(
          name: 'Sô-Cô-La Đá Xay',
          price: 48000,
          image: 'assets/images/image2.png',
          description: 'Sô-cô-la đậm đà được xay mịn cùng đá và phủ kem tươi.',
          category: 'Đá Xay',
        ),
        BobaModel(
          name: 'Matcha Latte',
          price: 50000,
          image: 'assets/images/image4.png',
          description: 'Bột matcha Nhật Bản nguyên chất hòa quyện cùng sữa tươi béo ngậy.',
          category: 'Latte',
        ),
      ];

      for (var product in dummyProducts) {
        await _productsRef.push().set(product.toJson());
      }
      
      print("Đã cập nhật bộ thực đơn mới thành công!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu RTDB: $e");
    }
  }

  // Lấy danh sách sản phẩm theo thời gian thực (Stream)
  Stream<List<BobaModel>> getProductsStream() {
    return _productsRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.entries.map((entry) {
        return BobaModel.fromJson(entry.value as Map<dynamic, dynamic>, entry.key.toString());
      }).toList();
    });
  }

  // Phương thức để lưu thông tin người dùng mới (Dùng sau khi Đăng ký Auth thành công)
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _usersRef.child(uid).set(userData);
      print("Đã lưu thông tin người dùng vào Collection 'users'!");
    } catch (e) {
      print("Lỗi khi tạo người dùng: $e");
    }
  }
}
