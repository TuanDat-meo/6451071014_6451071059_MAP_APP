import 'cart_item_model.dart';

enum OrderStatus {
  pending('Chờ xác nhận'),
  confirmed('Đã xác nhận'),
  preparing('Đang chuẩn bị'),
  ready('Sẵn sàng'),
  onTheWay('Đang giao'),
  delivered('Đã giao'),
  cancelled('Đã hủy');

  final String displayName;
  const OrderStatus(this.displayName);
}

enum PaymentMethod {
  cash('Tiền mặt'),
  bankTransfer('Chuyển khoản'),
  creditCard('Thẻ tín dụng'),
  wallet('Ví điện tử');

  final String displayName;
  const PaymentMethod(this.displayName);
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double shippingCost;
  final double taxCost;
  final double discountCost;
  final double totalAmount;
  final String shippingAddressId;
  final String recipientName;
  final String recipientPhone;
  final String shippingAddress;
  OrderStatus status;
  PaymentMethod paymentMethod;
  final DateTime createdAt;
  DateTime? confirmedAt;
  DateTime? readyAt;
  DateTime? deliveredAt;
  String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.taxCost,
    required this.discountCost,
    required this.totalAmount,
    required this.shippingAddressId,
    required this.recipientName,
    required this.recipientPhone,
    required this.shippingAddress,
    this.status = OrderStatus.pending,
    this.paymentMethod = PaymentMethod.cash,
    DateTime? createdAt,
    this.confirmedAt,
    this.readyAt,
    this.deliveredAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  // Get order status color
  String getStatusColor() {
    switch (status) {
      case OrderStatus.pending:
        return '#FFC107'; // Amber
      case OrderStatus.confirmed:
        return '#2196F3'; // Blue
      case OrderStatus.preparing:
        return '#FF9800'; // Orange
      case OrderStatus.ready:
        return '#4CAF50'; // Green
      case OrderStatus.onTheWay:
        return '#9C27B0'; // Purple
      case OrderStatus.delivered:
        return '#4CAF50'; // Green
      case OrderStatus.cancelled:
        return '#F44336'; // Red
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'discountCost': discountCost,
      'totalAmount': totalAmount,
      'shippingAddressId': shippingAddressId,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'shippingAddress': shippingAddress,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'readyAt': readyAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List?)?.map((item) => CartItem.fromMap(item as Map<dynamic, dynamic>)).toList() ?? [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      taxCost: (json['taxCost'] ?? 0).toDouble(),
      discountCost: (json['discountCost'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      shippingAddressId: json['shippingAddressId'] ?? '',
      recipientName: json['recipientName'] ?? '',
      recipientPhone: json['recipientPhone'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'])
          : null,
      readyAt: json['readyAt'] != null ? DateTime.parse(json['readyAt']) : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      notes: json['notes'],
    );
  }

  Order copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? subtotal,
    double? shippingCost,
    double? taxCost,
    double? discountCost,
    double? totalAmount,
    String? shippingAddressId,
    String? recipientName,
    String? recipientPhone,
    String? shippingAddress,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? readyAt,
    DateTime? deliveredAt,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      taxCost: taxCost ?? this.taxCost,
      discountCost: discountCost ?? this.discountCost,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddressId: shippingAddressId ?? this.shippingAddressId,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      readyAt: readyAt ?? this.readyAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      notes: notes ?? this.notes,
    );
  }
}
