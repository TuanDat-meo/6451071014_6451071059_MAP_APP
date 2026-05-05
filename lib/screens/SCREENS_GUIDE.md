# 📱 Hướng Dẫn Sử Dụng Các Screen Chính

## 📋 Danh sách các Screen đã tạo

### 1. **Product Detail Screen** (`lib/screens/product/product_detail_screen.dart`)
- **Chức năng**: Xem chi tiết sản phẩm, chọn size, topping, và số lượng
- **Tính năng**:
  - Hiển thị ảnh sản phẩm đầy đủ
  - Chọn size: M, L, XL (có giá khác nhau)
  - Chọn topping: Trân châu, Jelly, Kem tươi, v.v. (mỗi topping có giá riêng)
  - Điều chỉnh số lượng
  - Hiển thị giá tổng động theo lựa chọn
  - Thêm vào giỏ hàng

### 2. **Cart Screen** (`lib/screens/cart/cart_screen.dart`)
- **Chức năng**: Quản lý giỏ hàng
- **Tính năng**:
  - Hiển thị danh sách sản phẩm trong giỏ
  - Điều chỉnh số lượng từng sản phẩm
  - Xóa sản phẩm khỏi giỏ
  - Áp dụng mã giảm giá
  - Hiển thị tạm tính, phí vận chuyển, thuế, và tổng cộng
  - Nút thanh toán

### 3. **Checkout Screen** (`lib/screens/order/checkout_screen.dart`)
- **Chức năng**: Hoàn tất thanh toán
- **Tính năng**:
  - Bước 1: Chọn địa chỉ giao hàng
  - Bước 2: Chọn phương thức thanh toán (Tiền mặt, Chuyển khoản, Thẻ tín dụng, Ví điện tử)
  - Hiển thị tóm tắt đơn hàng
  - Tạo đơn hàng khi hoàn tất

### 4. **Order Management Screen** (`lib/screens/order/order_management_screen.dart`)
- **Chức năng**: Theo dõi đơn hàng
- **Tính năng**:
  - Lọc đơn hàng theo trạng thái
  - Hiển thị danh sách đơn hàng với trạng thái
  - Xem chi tiết đơn hàng (Modal Bottom Sheet)
  - Chia sẻ đơn hàng
  - Hủy đơn hàng (nếu chưa giao)
  - Progress indicator cho từng đơn hàng

### 5. **Profile Screen** (`lib/screens/profile/profile_screen.dart`)
- **Chức năng**: Quản lý hồ sơ cá nhân
- **Tính năng**:
  - Hiển thị/Chỉnh sửa thông tin cá nhân (Tên, Email, SĐT)
  - Quản lý ảnh đại diện
  - Liên kết đến quản lý địa chỉ
  - Thay đổi mật khẩu
  - Cài đặt thông báo
  - Chính sách bảo mật
  - Đăng xuất

### 6. **Shipping Address Screen** (`lib/screens/shipping_address/shipping_address_screen.dart`)
- **Chức năng**: Quản lý địa chỉ giao hàng
- **Tính năng**:
  - Danh sách địa chỉ
  - Thêm địa chỉ mới
  - Sửa địa chỉ
  - Xóa địa chỉ
  - Đặt địa chỉ mặc định

### 7. **Wishlist Screen** (`lib/screens/wishlist/wishlist_screen.dart`)
- **Chức năng**: Quản lý sản phẩm yêu thích
- **Tính năng**:
  - Hiển thị danh sách sản phẩm yêu thích (Grid view)
  - Xóa khỏi yêu thích
  - Thêm sản phẩm vào giỏ hàng từ wishlist
  - Xem chi tiết sản phẩm

### 8. **Main Navigation Screen** (`lib/screens/main_navigation_screen.dart`)
- **Chức năng**: Navigation chính của ứng dụng
- **Tính năng**:
  - Bottom Navigation Bar với 5 tab chính:
    - Trang chủ
    - Yêu thích
    - Giỏ hàng
    - Đơn hàng
    - Hồ sơ

---

## 🔧 Cách Tích Hợp Với State Management (GetX)

### Bước 1: Cài đặt GetX
```bash
flutter pub add get
```

### Bước 2: Tạo Controllers

**Cart Controller** (`lib/controller/cart_controller.dart`):
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

  void clearCart() {
    cart.value.clear();
    cart.refresh();
  }
}
```

**Order Controller** (`lib/controller/order_controller.dart`):
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
    fetchUserOrders('user1'); // Thay bằng userId thực
  }

  void fetchUserOrders(String userId) {
    firebaseService.getUserOrdersStream(userId).listen((orderList) {
      orders.value = orderList;
    });
  }

  Future<void> createOrder(Order order) async {
    await firebaseService.createOrder(order);
    fetchUserOrders(order.userId);
  }
}
```

### Bước 3: Cập nhật Main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    GetMaterialApp(
      title: 'Boba House',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
      getPages: [
        GetPage(name: '/checkout', page: () => CheckoutScreen(cart: Get.arguments)),
        GetPage(name: '/order-management', page: () => OrderManagementScreen()),
      ],
    ),
  );
}
```

### Bước 4: Sử dụng Controllers trong Screens

**Ví dụ trong Product Detail Screen**:
```dart
final cartController = Get.put(CartController());

void _addToCart() {
  final cartItem = CartItem(...);
  cartController.addItem(cartItem);
  Get.snackbar('Thành công', 'Đã thêm vào giỏ hàng');
}
```

---

## 📊 Cấu Trúc Dữ Liệu (Models)

### CartItem
```
- id: String (unique ID)
- product: BobaModel
- quantity: int
- size: String (M, L, XL)
- toppings: List<String>
- additionalPrice: double
```

### Order
```
- id: String
- userId: String
- items: List<CartItem>
- subtotal: double
- shippingCost: double
- totalAmount: double
- shippingAddressId: String
- status: OrderStatus (pending, confirmed, preparing, ready, onTheWay, delivered, cancelled)
- paymentMethod: PaymentMethod (cash, bankTransfer, creditCard, wallet)
- createdAt: DateTime
```

### ShippingAddress
```
- id: String
- userId: String
- recipientName: String
- phoneNumber: String
- address: String
- ward: String
- district: String
- province: String
- postalCode: String
- isDefault: bool
```

---

## 🔄 Luồng Dữ Liệu Chính

```
Home Screen → Product Detail Screen
    ↓
    → Add Item to Cart
    ↓
Cart Screen → Remove/Update Items
    ↓
    → Checkout
    ↓
Checkout Screen → Select Address → Select Payment
    ↓
    → Create Order
    ↓
Order Management Screen → Track Order
```

---

## 🚀 Các Bước Tiếp Theo

1. **Tích hợp State Management (GetX)** - Quản lý cart, user, orders toàn cục
2. **Thêm Firebase Integration** - Lưu/lấy data từ Firebase
3. **Xây dựng Auth Flow** - Login/Register
4. **Thêm thanh toán online** - Stripe, VNPay, v.v.
5. **Thêm notificationsFirebase Cloud Messaging (FCM)
6. **Testing & Deployment**

---

## ⚙️ Dependencies Cần Thiết

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.1.1
  firebase_auth: ^5.1.2
  cloud_firestore: ^5.0.2
  firebase_database: ^11.0.0
  get: ^4.6.5
  intl: ^0.19.0
  uuid: ^4.0.0
  image_picker: ^1.0.0  # Cho chọn ảnh
```

---

## 📝 Ghi Chú Quan Trọng

- Tất cả screens hiện tại đang dùng **sample data**. Cần thay bằng **real data từ Firebase**
- Cart data đang được lưu **trong local state**. Cần migrate sang **GetX Controller** hoặc **Provider**
- TODO comments trong code để chỉ ra những chỗ cần hoàn thiện
- Routing cần được setup trong **main.dart** hoặc tạo file **routes.dart** riêng

Good luck! 🎉
