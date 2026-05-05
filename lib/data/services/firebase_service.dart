import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/boba_model.dart';
import '../models/order_model.dart';
import '../models/shipping_address_model.dart';

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

  final DatabaseReference _ordersRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://vs6451071059-default-rtdb.asia-southeast1.firebasedatabase.app'
  ).ref().child('orders');

  final DatabaseReference _shippingAddressRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://vs6451071059-default-rtdb.asia-southeast1.firebasedatabase.app'
  ).ref().child('shippingAddresses');

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
          price: 45000,
          image: 'assets/images/image1.png',
          description: 'Vị trà đào thanh mát kết hợp cùng cam tươi và sả thơm nồng.',
          category: 'Trà Trái Cây',
        ),
        BobaModel(
          name: 'Sô-Cô-La Đá Xay',
          price: 45000,
          image: 'assets/images/image2.png',
          description: 'Sô-cô-la đậm đà được xay mịn cùng đá và phủ kem tươi.',
          category: 'Đá Xay',
        ),
        BobaModel(
          name: 'Matcha Latte',
          price: 45000,
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

  // ============== ORDER METHODS ==============

  // Tạo đơn hàng mới
  Future<void> createOrder(Order order) async {
    try {
      await _ordersRef.child(order.id).set(order.toJson());
      print("Đã tạo đơn hàng thành công!");
    } catch (e) {
      print("Lỗi khi tạo đơn hàng: $e");
    }
  }

  // Lấy danh sách đơn hàng của user
  Stream<List<Order>> getUserOrdersStream(String userId) {
    return _ordersRef
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.entries.map((entry) {
        return Order.fromJson(entry.value as Map<dynamic, dynamic>);
      }).toList();
    });
  }

  // Lấy tất cả đơn hàng (Debug/Admin)
  Stream<List<Order>> getAllOrdersStream() {
    return _ordersRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.entries.map((entry) {
        return Order.fromJson(entry.value as Map<dynamic, dynamic>);
      }).toList();
    });
  }

  // Lấy chi tiết một đơn hàng
  Future<Order?> getOrder(String orderId) async {
    try {
      final snapshot = await _ordersRef.child(orderId).get();
      if (snapshot.exists) {
        return Order.fromJson(snapshot.value as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print("Lỗi khi lấy đơn hàng: $e");
      return null;
    }
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _ordersRef.child(orderId).update({
        'status': status.name,
      });
      print("Đã cập nhật trạng thái đơn hàng!");
    } catch (e) {
      print("Lỗi khi cập nhật đơn hàng: $e");
    }
  }

  // ============== SHIPPING ADDRESS METHODS ==============

  // Thêm địa chỉ giao hàng mới
  Future<void> addShippingAddress(ShippingAddress address) async {
    try {
      await _shippingAddressRef.child(address.id).set(address.toJson());
      print("Đã thêm địa chỉ giao hàng!");
    } catch (e) {
      print("Lỗi khi thêm địa chỉ: $e");
    }
  }

  // Lấy danh sách địa chỉ giao hàng của user
  Stream<List<ShippingAddress>> getUserShippingAddressesStream(String userId) {
    return _shippingAddressRef
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.entries.map((entry) {
        return ShippingAddress.fromJson(entry.value as Map<dynamic, dynamic>);
      }).toList();
    });
  }

  // Cập nhật địa chỉ giao hàng
  Future<void> updateShippingAddress(ShippingAddress address) async {
    try {
      await _shippingAddressRef.child(address.id).set(address.toJson());
      print("Đã cập nhật địa chỉ giao hàng!");
    } catch (e) {
      print("Lỗi khi cập nhật địa chỉ: $e");
    }
  }

  // Xóa địa chỉ giao hàng
  Future<void> deleteShippingAddress(String addressId) async {
    try {
      await _shippingAddressRef.child(addressId).remove();
      print("Đã xóa địa chỉ giao hàng!");
    } catch (e) {
      print("Lỗi khi xóa địa chỉ: $e");
    }
  }

  // ============== USER METHODS ==============

  // Cập nhật thông tin user
  Future<void> updateUserInfo(String uid, Map<String, dynamic> userData) async {
    try {
      await _usersRef.child(uid).update(userData);
      print("Đã cập nhật thông tin user!");
    } catch (e) {
      print("Lỗi khi cập nhật user: $e");
    }
  }

  // Lấy thông tin user
  Future<Map<dynamic, dynamic>?> getUserInfo(String uid) async {
    try {
      final snapshot = await _usersRef.child(uid).get();
      if (snapshot.exists) {
        return snapshot.value as Map<dynamic, dynamic>;
      }
      return null;
    } catch (e) {
      print("Lỗi khi lấy thông tin user: $e");
      return null;
    }
  }
}
