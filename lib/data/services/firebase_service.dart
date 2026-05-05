import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/boba_model.dart';
import '../models/order_model.dart';
import '../models/shipping_address_model.dart';
import '../models/notification_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Các collection references
  CollectionReference get _productsCol => _firestore.collection('products');
  CollectionReference get _ordersCol => _firestore.collection('orders');
  CollectionReference get _notificationsCol => _firestore.collection('notifications');
  CollectionReference get _shippingAddressCol => _firestore.collection('shippingAddresses');
  CollectionReference get _reviewsCol => _firestore.collection('reviews');
  CollectionReference get _usersCol => _firestore.collection('users');

  // Lấy userId hiện tại (từ email đã login, lưu static)
  static String? _currentUserId;
  static String? _currentUserEmail;

  String get userId => _currentUserId ?? 'guest_user';

  /// Gọi sau khi login thành công - lưu userId
  Future<void> setCurrentUser(String email) async {
    _currentUserEmail = email;
    try {
      final snapshot = await _usersCol.where('email', isEqualTo: email).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        _currentUserId = snapshot.docs.first.id;
      }
    } catch (e) {
      print('Lỗi khi lấy userId: $e');
    }
  }

  // ============== SEED DATA ==============

  Future<void> seedData() async {
    try {
      // Seed products nếu chưa có
      final productSnapshot = await _productsCol.limit(1).get();
      if (productSnapshot.docs.isEmpty) {
        final products = [
          // Trà Sữa
          {'name': 'Trà Sữa Trân Châu Đường Đen', 'price': 45000.0, 'image': 'assets/images/image.png',
            'description': 'Sự kết hợp hoàn hảo giữa sữa tươi đá xay và trân châu đường đen ngọt ngào. Vị ngọt tự nhiên, thơm lừng.', 'category': 'Trà Sữa'},
          {'name': 'Trà Sữa Oolong Kem Cheese', 'price': 55000.0, 'image': 'assets/images/image.png',
            'description': 'Trà oolong thượng hạng phủ kem cheese béo ngậy. Hương trà thanh nhẹ hòa quyện vị cheese mặn ngọt.', 'category': 'Trà Sữa'},
          // Trà Trái Cây
          {'name': 'Trà Đào Cam Sả', 'price': 45000.0, 'image': 'assets/images/image1.png',
            'description': 'Vị trà đào thanh mát kết hợp cùng cam tươi và sả thơm nồng. Giải khát tuyệt vời cho mùa hè.', 'category': 'Trà Trái Cây'},
          {'name': 'Trà Vải Lychee Rose', 'price': 50000.0, 'image': 'assets/images/image1.png',
            'description': 'Trà xanh hòa quyện cùng vải thiều tươi và hoa hồng. Hương thơm ngát, vị ngọt dịu tự nhiên.', 'category': 'Trà Trái Cây'},
          // Đá Xay
          {'name': 'Sô-Cô-La Đá Xay', 'price': 45000.0, 'image': 'assets/images/image2.png',
            'description': 'Sô-cô-la đậm đà được xay mịn cùng đá và phủ kem tươi. Đậm vị cacao nguyên chất.', 'category': 'Đá Xay'},
          {'name': 'Cookies & Cream Frappé', 'price': 55000.0, 'image': 'assets/images/image2.png',
            'description': 'Kem vanilla xay mịn cùng bánh cookies giòn tan. Phủ whipped cream và vụn cookies bên trên.', 'category': 'Đá Xay'},
          // Latte
          {'name': 'Matcha Latte', 'price': 50000.0, 'image': 'assets/images/image4.png',
            'description': 'Bột matcha Nhật Bản nguyên chất hòa quyện cùng sữa tươi béo ngậy. Đắng nhẹ, thanh mát.', 'category': 'Latte'},
          {'name': 'Caramel Macchiato', 'price': 55000.0, 'image': 'assets/images/image4.png',
            'description': 'Espresso đậm đà, sữa tươi mịn màng và sốt caramel thơm lừng. Vị ngọt thanh, đắng nhẹ cân bằng.', 'category': 'Latte'},
        ];

        for (var p in products) {
          await _productsCol.add(p);
        }
        print('✅ Đã seed 8 sản phẩm lên Firestore!');
      }

      // Seed notifications cho user hiện tại
      if (_currentUserId != null) {
        await _seedNotifications();
        await _seedShippingAddresses();
      }

      print('✅ Seed data hoàn tất!');
    } catch (e) {
      print('❌ Lỗi seed data: $e');
    }
  }

  Future<void> _seedNotifications() async {
    final snapshot = await _notificationsCol.where('userId', isEqualTo: userId).limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final now = DateTime.now();
    final notifications = [
      {'id': 'noti_1', 'userId': userId, 'title': 'Chào mừng bạn đến Boba House! 🧋',
        'body': 'Cảm ơn bạn đã đăng ký tài khoản. Hãy khám phá thực đơn trà sữa phong phú của chúng tôi nhé!',
        'type': 'system', 'createdAt': Timestamp.fromDate(now.subtract(const Duration(minutes: 5))), 'isRead': false},
      {'id': 'noti_2', 'userId': userId, 'title': '🎉 Giảm 20% toàn bộ menu!',
        'body': 'Nhập mã BOBA20 để nhận ưu đãi giảm 20% cho đơn hàng tiếp theo. Áp dụng đến 30/05.',
        'type': 'promo', 'createdAt': Timestamp.fromDate(now.subtract(const Duration(hours: 2))), 'isRead': false},
      {'id': 'noti_3', 'userId': userId, 'title': '🧋 Món mới: Oolong Sữa Tươi',
        'body': 'Trà Oolong kết hợp sữa tươi thơm lừng đã có mặt tại Boba House! Thử ngay hôm nay.',
        'type': 'promo', 'createdAt': Timestamp.fromDate(now.subtract(const Duration(hours: 6))), 'isRead': false},
      {'id': 'noti_4', 'userId': userId, 'title': 'Mua 1 tặng 1 mỗi thứ 6! 🎁',
        'body': 'Áp dụng cho tất cả các loại trà sữa size L trở lên vào mỗi thứ 6 hàng tuần.',
        'type': 'promo', 'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 1))), 'isRead': true},
    ];

    for (var n in notifications) {
      await _notificationsCol.add(n);
    }
    print('✅ Đã seed notifications!');
  }

  Future<void> _seedShippingAddresses() async {
    final snapshot = await _shippingAddressCol.where('userId', isEqualTo: userId).limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final addresses = [
      {'userId': userId, 'recipientName': 'Nguyễn Văn A', 'phoneNumber': '0901234567',
        'address': '123 Đường Nguyễn Huệ', 'ward': 'Phường Bến Nghé', 'district': 'Quận 1',
        'province': 'TP. Hồ Chí Minh', 'postalCode': '700000', 'isDefault': true,
        'createdAt': Timestamp.now()},
      {'userId': userId, 'recipientName': 'Trần Thị B', 'phoneNumber': '0987654321',
        'address': '456 Đường Lê Lợi', 'ward': 'Phường 1', 'district': 'Quận 3',
        'province': 'TP. Hồ Chí Minh', 'postalCode': '700000', 'isDefault': false,
        'createdAt': Timestamp.now()},
    ];

    for (var a in addresses) {
      await _shippingAddressCol.add(a);
    }
    print('✅ Đã seed shipping addresses!');
  }

  // ============== PRODUCTS ==============

  Stream<List<BobaModel>> getProductsStream() {
    return _productsCol.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BobaModel.fromJson(Map<dynamic, dynamic>.from(data), doc.id);
      }).toList();
    });
  }

  // ============== ORDERS ==============

  Future<void> createOrder(Order order) async {
    try {
      final orderData = order.toJson();
      orderData['userId'] = userId;
      orderData['createdAt'] = Timestamp.fromDate(order.createdAt);
      await _ordersCol.doc(order.id).set(orderData);

      // Tự động tạo notification
      await _notificationsCol.add({
        'userId': userId,
        'title': 'Đơn hàng đã được tiếp nhận! 🎉',
        'body': 'Đơn hàng #${order.id.substring(0, 8)} trị giá ${order.totalAmount.toStringAsFixed(0)}đ đang chờ xác nhận.',
        'type': 'order',
        'orderId': order.id,
        'createdAt': Timestamp.now(),
        'isRead': false,
      });
    } catch (e) {
      print('❌ Lỗi tạo đơn hàng: $e');
    }
  }

  Stream<List<Order>> getAllOrdersStream() {
    return _ordersCol.snapshots().map((snapshot) {
      final List<Order> orders = [];
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Đảm bảo có id
          orders.add(Order.fromJson(Map<dynamic, dynamic>.from(data)));
        } catch (e) {
          print('⚠️ Lỗi parse order ${doc.id}: $e');
        }
      }
      return orders;
    });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _ordersCol.doc(orderId).update({'status': status.name});
  }

  // ============== NOTIFICATIONS ==============

  Stream<List<NotificationModel>> getNotificationsStream() {
    return _notificationsCol
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Chuyển Timestamp thành ISO string cho fromJson
        final jsonData = Map<dynamic, dynamic>.from(data);
        if (jsonData['createdAt'] is Timestamp) {
          jsonData['createdAt'] = (jsonData['createdAt'] as Timestamp).toDate().toIso8601String();
        }
        jsonData['id'] = doc.id;
        return NotificationModel.fromJson(jsonData);
      }).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _notificationsCol.doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllNotificationsAsRead() async {
    final snapshot = await _notificationsCol.where('userId', isEqualTo: userId).get();
    for (var doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    await _notificationsCol.doc(notificationId).delete();
  }

  // ============== SHIPPING ADDRESSES ==============

  Stream<List<ShippingAddress>> getShippingAddressesStream() {
    return _shippingAddressCol
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final jsonData = Map<dynamic, dynamic>.from(data);
        if (jsonData['createdAt'] is Timestamp) {
          jsonData['createdAt'] = (jsonData['createdAt'] as Timestamp).toDate().toIso8601String();
        }
        jsonData['id'] = doc.id;
        return ShippingAddress.fromJson(jsonData);
      }).toList();
    });
  }

  Future<void> addShippingAddress(ShippingAddress address) async {
    final data = address.toJson();
    data['userId'] = userId;
    data['createdAt'] = Timestamp.now();
    await _shippingAddressCol.add(data);
  }

  Future<void> updateShippingAddress(ShippingAddress address) async {
    final data = address.toJson();
    data['userId'] = userId;
    await _shippingAddressCol.doc(address.id).update(data);
  }

  Future<void> deleteShippingAddress(String addressId) async {
    await _shippingAddressCol.doc(addressId).delete();
  }

  Future<void> setDefaultAddress(String addressId) async {
    // Bỏ default cũ
    final snapshot = await _shippingAddressCol.where('userId', isEqualTo: userId).get();
    for (var doc in snapshot.docs) {
      await doc.reference.update({'isDefault': false});
    }
    // Set default mới
    await _shippingAddressCol.doc(addressId).update({'isDefault': true});
  }

  // ============== USERS ==============

  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    await _usersCol.doc(uid).set(userData);
  }

  Future<void> updateUserInfo(String uid, Map<String, dynamic> userData) async {
    await _usersCol.doc(uid).update(userData);
  }

  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    final doc = await _usersCol.doc(uid).get();
    if (doc.exists) return doc.data() as Map<String, dynamic>;
    return null;
  }
}
