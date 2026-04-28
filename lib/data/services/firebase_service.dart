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
      // Kiểm tra xem đã có dữ liệu chưa
      final snapshot = await _productsRef.get();
      if (snapshot.exists) {
        print("Dữ liệu đã tồn tại trên Realtime Database, bỏ qua bước tạo mẫu.");
        return;
      }

      List<BobaModel> dummyProducts = [
        BobaModel(
          name: 'Trà Sữa Trân Châu Đường Đen',
          price: 45000,
          image: 'https://img.freepik.com/free-photo/brown-sugar-bubble-tea-with-milk_23-2148580666.jpg',
          description: 'Sự kết hợp hoàn hảo giữa sữa tươi đá xay và trân châu đường đen ngọt ngào.',
          category: 'Trà Sữa',
        ),
        BobaModel(
          name: 'Trà Đào Cam Sả',
          price: 35000,
          image: 'https://img.freepik.com/free-photo/peach-tea-with-lemon-mint_144627-21652.jpg',
          description: 'Vị trà đào thanh mát kết hợp cùng cam tươi và sả thơm nồng.',
          category: 'Trà Trái Cây',
        ),
        BobaModel(
          name: 'Matcha Latte Latte',
          price: 50000,
          image: 'https://img.freepik.com/free-photo/matcha-latte-isolated-white-background_123827-23424.jpg',
          description: 'Bột matcha Nhật Bản nguyên chất hòa quyện cùng sữa tươi béo ngậy.',
          category: 'Latte',
        ),
        BobaModel(
          name: 'Sô-cô-la Đá Xay',
          price: 48000,
          image: 'https://img.freepik.com/free-photo/chocolate-milkshake-with-whipped-cream_144627-14810.jpg',
          description: 'Sô-cô-la đậm đà được xay mịn cùng đá và phủ kem tươi.',
          category: 'Đá Xay',
        ),
      ];

      for (var product in dummyProducts) {
        // push() tạo một ID ngẫu nhiên giống như Firestore
        await _productsRef.push().set(product.toJson());
      }
      
      print("Đã tạo dữ liệu mẫu thành công trên Realtime Database!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu RTDB: $e");
    }
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
