import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/cart_model.dart';
import '../data/models/order_model.dart';
import '../data/services/firebase_service.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  // Sử dụng .obs để lắng nghe sự thay đổi của giỏ hàng
  var cart = CartModel(id: const Uuid().v4(), items: []).obs;
  
  // Quản lý tab hiện tại của ứng dụng
  var selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // Thêm sản phẩm vào giỏ
  void addToCart(CartItem item) {
    // Tạo bản sao của items hiện tại
    List<CartItem> currentItems = List.from(cart.value.items);
    
    // Kiểm tra xem sản phẩm cùng size và topping đã có chưa
    final existingIndex = currentItems.indexWhere((i) => 
      i.product.id == item.product.id && 
      i.size == item.size && 
      _listEquals(i.toppings, item.toppings)
    );

    if (existingIndex >= 0) {
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + item.quantity,
      );
    } else {
      currentItems.add(item);
    }

    // Cập nhật lại cart obs
    cart.value = cart.value.copyWith(items: currentItems);
    update(); // Force update UI
  }

  // Xóa sản phẩm khỏi giỏ
  void removeFromCart(String itemId) {
    List<CartItem> currentItems = List.from(cart.value.items);
    currentItems.removeWhere((item) => item.id == itemId);
    cart.value = cart.value.copyWith(items: currentItems);
    update();
  }

  // Cập nhật số lượng
  void updateQuantity(String itemId, int quantity) {
    List<CartItem> currentItems = List.from(cart.value.items);
    final index = currentItems.indexWhere((i) => i.id == itemId);
    
    if (index >= 0) {
      if (quantity <= 0) {
        currentItems.removeAt(index);
      } else {
        currentItems[index] = currentItems[index].copyWith(quantity: quantity);
      }
    }
    
    cart.value = cart.value.copyWith(items: currentItems);
    update();
  }

  // Xóa sạch giỏ hàng
  void clearCart() {
    cart.value = cart.value.copyWith(items: []);
    update();
  }

  // Xử lý Thanh toán
  Future<void> processCheckout() async {
    if (cart.value.items.isEmpty) return;

    try {
      final userId = FirebaseService().userId;
      
      // 1. Tạo đối tượng Order mới
      final newOrder = Order(
        id: const Uuid().v4(),
        userId: userId,
        items: List.from(cart.value.items),
        subtotal: subtotal,
        shippingCost: cart.value.shippingCost,
        taxCost: cart.value.taxCost,
        discountCost: cart.value.discountCost,
        totalAmount: total,
        shippingAddressId: 'default_id',
        recipientName: 'Khách hàng',
        recipientPhone: 'Chưa có số',
        shippingAddress: 'Địa chỉ mặc định (Bạn có thể cập nhật sau)',
        status: OrderStatus.pending,
        paymentMethod: PaymentMethod.cash,
      );

      // 2. Lưu vào Firebase
      await FirebaseService().createOrder(newOrder);
      
      // 3. Xóa giỏ hàng
      clearCart();
      
      // 4. Chuyển sang tab Đơn hàng (Index là 3)
      changeTab(3);
      
      // 5. Thông báo thành công
      Get.snackbar(
        'Thành công',
        'Đơn hàng của bạn đã được tiếp nhận!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tạo đơn hàng: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Hàm so sánh 2 list topping
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!b.contains(a[i])) return false;
    }
    return true;
  }

  // Getters
  double get subtotal => cart.value.getSubtotal();
  double get total => cart.value.getTotalPrice();
  int get itemCount => cart.value.getItemCount();
}
