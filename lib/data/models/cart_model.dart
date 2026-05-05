import 'cart_item_model.dart';

class CartModel {
  final String id;
  final List<CartItem> items;
  double subtotal;
  double shippingCost;
  double taxCost;
  double discountCost;

  CartModel({
    required this.id,
    this.items = const [],
    this.subtotal = 0,
    this.shippingCost = 15000,
    this.taxCost = 0,
    this.discountCost = 0,
  });

  // Tính tổng giá trước khi áp dụng khuyến mãi
  double getSubtotal() {
    return items.fold(0, (sum, item) => sum + item.getTotalPrice());
  }

  // Tính tổng giá cuối cùng
  double getTotalPrice() {
    double total = getSubtotal() + shippingCost + taxCost - discountCost;
    return total < 0 ? 0 : total;
  }

  // Thêm item vào giỏ
  void addItem(CartItem item) {
    final existingIndex = items.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + item.quantity,
      );
    } else {
      items.add(item);
    }
  }

  // Xóa item khỏi giỏ
  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
  }

  // Cập nhật số lượng
  void updateQuantity(String itemId, int quantity) {
    final index = items.indexWhere((i) => i.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(quantity: quantity);
      }
    }
  }

  // Xóa tất cả
  void clear() {
    items.clear();
  }

  // Số lượng item trong giỏ
  int getItemCount() {
    return items.length;
  }

  // Tổng số sản phẩm (tính quantity)
  int getTotalQuantity() {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'discountCost': discountCost,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? '',
      items: (json['items'] as List?)?.map((item) => item as CartItem).toList() ?? [],
      shippingCost: (json['shippingCost'] ?? 15000).toDouble(),
      taxCost: (json['taxCost'] ?? 0).toDouble(),
      discountCost: (json['discountCost'] ?? 0).toDouble(),
    );
  }

  CartModel copyWith({
    String? id,
    List<CartItem>? items,
    double? subtotal,
    double? shippingCost,
    double? taxCost,
    double? discountCost,
  }) {
    return CartModel(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      taxCost: taxCost ?? this.taxCost,
      discountCost: discountCost ?? this.discountCost,
    );
  }
}
