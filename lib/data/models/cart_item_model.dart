import 'boba_model.dart';

class CartItem {
  final String id; // ID duy nhất cho cart item
  final BobaModel product;
  int quantity;
  String size; // M, L, XL
  List<String> toppings; // Topping được chọn
  double additionalPrice; // Giá thêm từ size + topping

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.size = 'M',
    this.toppings = const [],
    this.additionalPrice = 0,
  });

  // Tính tổng giá của item
  double getTotalPrice() {
    return (product.price + additionalPrice) * quantity;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(), // Lưu toàn bộ thông tin sản phẩm
      'quantity': quantity,
      'size': size,
      'toppings': toppings,
      'additionalPrice': additionalPrice,
    };
  }

  // Tạo từ JSON (Sử dụng cho Firebase Order)
  factory CartItem.fromMap(Map<dynamic, dynamic> json) {
    final productMap = json['product'] as Map<dynamic, dynamic>?;
    
    // Tạo sản phẩm mặc định nếu dữ liệu cũ bị thiếu
    final product = productMap != null 
        ? BobaModel.fromJson(productMap, productMap['id'] ?? '')
        : BobaModel(id: 'unknown', name: 'Sản phẩm cũ', price: 0, image: '', description: '', category: '');

    return CartItem(
      id: json['id'] ?? '',
      product: product,
      quantity: json['quantity'] ?? 1,
      size: json['size'] ?? 'M',
      toppings: List<String>.from(json['toppings'] ?? []),
      additionalPrice: (json['additionalPrice'] ?? 0).toDouble(),
    );
  }

  // Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json, BobaModel product) {
    return CartItem(
      id: json['id'] ?? '',
      product: product,
      quantity: json['quantity'] ?? 1,
      size: json['size'] ?? 'M',
      toppings: List<String>.from(json['toppings'] ?? []),
      additionalPrice: (json['additionalPrice'] ?? 0).toDouble(),
    );
  }

  // Copy with
  CartItem copyWith({
    String? id,
    BobaModel? product,
    int? quantity,
    String? size,
    List<String>? toppings,
    double? additionalPrice,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      toppings: toppings ?? this.toppings,
      additionalPrice: additionalPrice ?? this.additionalPrice,
    );
  }
}
