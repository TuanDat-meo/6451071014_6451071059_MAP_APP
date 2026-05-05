# 🚀 Hướng Dẫn Cài Đặt Nhanh

## 1️⃣ Update Dependencies

### Bước 1: Cài đặt UUID package
Đã cập nhật `pubspec.yaml`. Chạy lệnh:
```bash
flutter pub get
```

### Bước 2: Cài đặt GetX (Recommended)
```bash
flutter pub add get
```

### Bước 3: (Optional) Cài đặt các packages hữu ích khác
```bash
flutter pub add image_picker       # Chọn ảnh
flutter pub add geolocator        # GPS location
flutter pub add url_launcher      # Mở links
flutter pub add share             # Chia sẻ
```

---

## 2️⃣ Update Main.dart (Bắt Buộc)

Thay thế nội dung `main.dart` bằng:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'common/theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cấu hình thanh trạng thái
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BobaApp());
}

class BobaApp extends StatelessWidget {
  const BobaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Boba House',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
      // Định nghĩa routes
      getPages: [
        GetPage(
          name: '/checkout',
          page: () => const CheckoutScreen(cart: CartModel(id: 'temp')),
        ),
        GetPage(
          name: '/order-management',
          page: () => const OrderManagementScreen(),
        ),
        GetPage(
          name: '/shipping-addresses',
          page: () => const ShippingAddressScreen(addresses: []),
        ),
      ],
    );
  }
}
```

---

## 3️⃣ Tạo Controllers (GetX)

### Tạo file `lib/controller/cart_controller.dart`:
```dart
import 'package:get/get.dart';
import '../data/models/cart_model.dart';
import '../data/models/cart_item_model.dart';

class CartController extends GetxController {
  final cart = CartModel(id: 'cart_1').obs;

  void addItem(CartItem item) {
    cart.value.addItem(item);
    cart.refresh();
  }

  void removeItem(String itemId) {
    cart.value.removeItem(itemId);
    cart.refresh();
  }

  void updateQuantity(String itemId, int quantity) {
    cart.value.updateQuantity(itemId, quantity);
    cart.refresh();
  }

  void updateShippingCost(double cost) {
    cart.value.shippingCost = cost;
    cart.refresh();
  }

  void applyDiscount(double discount) {
    cart.value.discountCost = discount;
    cart.refresh();
  }

  void clearCart() {
    cart.value.clear();
    cart.refresh();
  }

  int getCartItemCount() {
    return cart.value.getItemCount();
  }
}
```

### Tạo file `lib/controller/order_controller.dart`:
```dart
import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/services/firebase_service.dart';

class OrderController extends GetxController {
  final orders = <Order>[].obs;
  final firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    // Thay 'user1' bằng actual userId
    fetchUserOrders('user1');
  }

  void fetchUserOrders(String userId) {
    firebaseService.getUserOrdersStream(userId).listen((orderList) {
      orders.value = orderList;
    });
  }

  Future<void> createOrder(Order order) async {
    try {
      await firebaseService.createOrder(order);
      fetchUserOrders(order.userId);
      Get.snackbar('Thành công', 'Đơn hàng đã được tạo');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tạo đơn hàng: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await firebaseService.updateOrderStatus(orderId, status);
      Get.snackbar('Thành công', 'Cập nhật trạng thái đơn hàng');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật: $e');
    }
  }
}
```

### Tạo file `lib/controller/user_controller.dart`:
```dart
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/services/firebase_service.dart';

class UserController extends GetxController {
  final user = Rxn<UserModel>();
  final firebaseService = FirebaseService();

  Future<void> fetchUserInfo(String uid) async {
    try {
      final userData = await firebaseService.getUserInfo(uid);
      if (userData != null) {
        user.value = UserModel.fromJson(userData);
      }
    } catch (e) {
      print('Lỗi khi lấy user info: $e');
    }
  }

  Future<void> updateUserInfo(String uid, Map<String, dynamic> updates) async {
    try {
      await firebaseService.updateUserInfo(uid, updates);
      await fetchUserInfo(uid);
      Get.snackbar('Thành công', 'Cập nhật thông tin thành công');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật: $e');
    }
  }
}
```

---

## 4️⃣ Cập nhật Home Screen

Cập nhật `lib/screens/home/home_screen.dart` để sử dụng Cart Controller:

```dart
// Thêm import
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';
import '../product/product_detail_screen.dart';

// Trong class HomeScreen, sử dụng:
final cartController = Get.put(CartController());

// Thêm GestureDetector để chuyển đến Product Detail
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  },
  child: // ... product card UI
)
```

---

## 5️⃣ Cập nhật Checkout Screen

```dart
// Thêm vào CheckoutScreen
final cartController = Get.find<CartController>();

void _completeOrder() {
  final order = Order(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    userId: 'user1',
    items: cartController.cart.value.items,
    subtotal: cartController.cart.value.getSubtotal(),
    shippingCost: cartController.cart.value.shippingCost,
    taxCost: cartController.cart.value.taxCost,
    discountCost: cartController.cart.value.discountCost,
    totalAmount: cartController.cart.value.getTotalPrice(),
    // ... rest of order details
  );

  Get.find<OrderController>().createOrder(order);
  cartController.clearCart();
}
```

---

## 6️⃣ Chạy Ứng Dụng

```bash
# Clean & get dependencies
flutter clean
flutter pub get

# Run app
flutter run

# Hoặc run trên device specific
flutter run -d emulator-5554   # Android
flutter run -d iPhone           # iOS
```

---

## 7️⃣ Troubleshooting

### Lỗi: Missing import statements
```dart
// Thêm imports cần thiết vào file
import 'package:quan_ly_quan_ts/data/models/order_model.dart';
import 'package:quan_ly_quan_ts/controller/cart_controller.dart';
// etc.
```

### Lỗi: Firebase initialization
- Đảm bảo `firebase_options.dart` đã được generate
- Chạy: `flutterfire configure`

### Lỗi: GetX route not found
- Kiểm tra định nghĩa routes trong `main.dart`
- Ensure routes được định nghĩa trước khi navigate

### Warnings: UUID not found
- Chạy: `flutter pub get`

---

## 8️⃣ Các File Cần Xem Lại

1. ✅ **lib/main.dart** - Cập nhật routing
2. ✅ **lib/controller/** - Tạo controllers
3. ✅ **lib/screens/main_navigation_screen.dart** - Navigation chính
4. ✅ **lib/screens/home/home_screen.dart** - Link đến Product Details
5. ✅ **lib/data/services/firebase_service.dart** - Đã cập nhật

---

## 📞 Cheat Sheet - Navigasi & Data

### Navigate to Product Details
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductDetailScreen(product: product),
  ),
);
```

### Navigate with GetX
```dart
Get.to(() => CheckoutScreen(cart: Get.find<CartController>().cart.value));
```

### Add to Cart
```dart
final cartController = Get.find<CartController>();
cartController.addItem(cartItem);
```

### Create Order
```dart
final orderController = Get.find<OrderController>();
orderController.createOrder(order);
```

---

## 🎉 Chúc Mừng!

Bạn đã hoàn tất setup cơ bản. Bây giờ:
1. ✅ Các screens đã được tạo
2. ✅ Controllers đã được setup
3. ✅ Firebase integration đã sẵn
4. ✅ Navigation đã hoạt động

**Tiếp theo**: Test app, debug issues, và thêm tính năng nâng cao (thanh toán, thông báo, v.v.)

Happy coding! 🚀
