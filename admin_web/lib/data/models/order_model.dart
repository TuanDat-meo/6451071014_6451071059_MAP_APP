class OrderModel {
  String? id;
  String customerId;
  String customerName;
  DateTime orderDate;
  double totalAmount;
  String status; // e.g., 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
  List<OrderItem> items;

  OrderModel({
    this.id,
    required this.customerId,
    required this.customerName,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'customerName': customerName,
    'orderDate': orderDate.toIso8601String(),
    'totalAmount': totalAmount,
    'status': status,
    'items': items.map((i) => i.toJson()).toList(),
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    customerId: json['customerId'] ?? '',
    customerName: json['customerName'] ?? '',
    orderDate: DateTime.parse(json['orderDate']),
    totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    status: json['status'] ?? 'Pending',
    items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
  );
}

class OrderItem {
  String productId;
  String productName;
  int quantity;
  double price;
  String? productImage;

  OrderItem({required this.productId, required this.productName, required this.quantity, required this.price, this.productImage});

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'price': price,
    'productImage': productImage,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    productId: json['productId'] ?? '',
    productName: json['productName'] ?? '',
    quantity: json['quantity'] ?? 0,
    price: (json['price'] ?? 0).toDouble(),
    productImage: json['productImage'],
  );
}
