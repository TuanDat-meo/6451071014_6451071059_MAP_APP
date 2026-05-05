import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/order_model.dart';
import '../../data/services/firebase_service.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String get _currentUserId => _firebaseService.userId;
  String selectedFilter = 'all'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: StreamBuilder<List<Order>>(
              stream: _firebaseService.getAllOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                final userOrders = (snapshot.data ?? [])
                    .where((o) => o.userId == _currentUserId)
                    .toList();
                
                userOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                
                final filteredOrders = selectedFilter == 'all' 
                    ? userOrders 
                    : userOrders.where((o) => o.status.name == selectedFilter).toList();

                if (filteredOrders.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(context, filteredOrders[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterOrders(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  Widget _buildFilterTabs() {
    final filters = [
      {'label': 'Tất cả', 'value': 'all'},
      {'label': 'Chờ xác nhận', 'value': 'pending'},
      {'label': 'Đang chuẩn bị', 'value': 'preparing'},
      {'label': 'Đang giao', 'value': 'onTheWay'},
      {'label': 'Đã giao', 'value': 'delivered'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: filters
            .map((filter) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _filterOrders(filter['value'] as String),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedFilter == filter['value'] ? Colors.brown : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selectedFilter == filter['value'] ? Colors.brown : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        filter['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selectedFilter == filter['value'] ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text('Không có đơn hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          const SizedBox(height: 10),
          Text('Bạn chưa có đơn hàng nào trong danh mục này',
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'vi_VN');

    return GestureDetector(
      onTap: () => _showOrderDetail(context, order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã: #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(dateFormat.format(order.createdAt),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(order.status.displayName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey[200]),
            const SizedBox(height: 12),

            // Order Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Giao đến', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(order.recipientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Tổng tiền', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(currencyFormat.format(order.totalAmount),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            _buildProgressIndicator(order.status),
            const SizedBox(height: 12),

            // View Detail Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () => _showOrderDetail(context, order),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.brown),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Xem chi tiết',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.brown)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(OrderStatus status) {
    final steps = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];

    final currentStepIndex = steps.indexOf(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                return Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stepIndex <= currentStepIndex ? Colors.brown : Colors.grey[300],
                  ),
                  child: stepIndex < currentStepIndex
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                );
              } else {
                final lineIndex = index ~/ 2;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: lineIndex < currentStepIndex ? Colors.brown : Colors.grey[300],
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                  ),
                );
              }
            }),
          ),
        ),
        const SizedBox(height: 4),
        Text('Bước ${currentStepIndex + 1} / ${steps.length}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.amber;
      case OrderStatus.confirmed: return Colors.blue;
      case OrderStatus.preparing: return Colors.orange;
      case OrderStatus.ready: return Colors.green;
      case OrderStatus.onTheWay: return Colors.purple;
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
    }
  }

  // ==================== CHI TIẾT ĐƠN HÀNG ====================
  void _showOrderDetail(BuildContext context, Order order) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'vi_VN');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (ctx, scrollController) => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chi tiết đơn hàng',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mã đơn hàng
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long_rounded, size: 18, color: Colors.brown),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Mã: #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Status & Date
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Trạng thái:', style: TextStyle(fontSize: 13)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(order.status.displayName,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Ngày đặt: ${dateFormat.format(order.createdAt)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Items List
                    const Text('Sản phẩm đã đặt', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.product.image.isNotEmpty && item.product.image.startsWith('assets/')
                                ? Image.asset(item.product.image, width: 60, height: 60, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: Colors.grey[200],
                                      child: const Icon(Icons.local_cafe, color: Colors.brown)))
                                : Container(width: 60, height: 60, color: Colors.grey[200],
                                    child: const Icon(Icons.local_cafe, color: Colors.brown)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text('Size: ${item.size} x ${item.quantity}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                if (item.toppings.isNotEmpty)
                                  Text('Topping: ${item.toppings.join(", ")}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
                            ),
                          ),
                          Text(currencyFormat.format(item.getTotalPrice()),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.brown)),
                        ],
                      ),
                    )).toList(),

                    const SizedBox(height: 12),

                    // Phương thức thanh toán
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.payment, size: 18, color: Colors.brown),
                          const SizedBox(width: 8),
                          Text('Thanh toán: ${order.paymentMethod.displayName}',
                              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Shipping Address
                    const Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.recipientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(order.recipientPhone, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          Text(order.shippingAddress, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Order Summary
                    const Text('Tóm tắt đơn hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Tạm tính', currencyFormat.format(order.subtotal)),
                    _buildSummaryRow('Phí vận chuyển', currencyFormat.format(order.shippingCost)),
                    if (order.discountCost > 0)
                      _buildSummaryRow('Giảm giá', '-${currencyFormat.format(order.discountCost)}', color: Colors.green),
                    Divider(color: Colors.grey[300]),
                    _buildSummaryRow('Tổng cộng', currencyFormat.format(order.totalAmount), isBold: true, color: Colors.brown),

                    const SizedBox(height: 24),

                    // ===== NÚT XÁC NHẬN ĐƠN HÀNG =====
                    if (order.status == OrderStatus.pending)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _confirmOrder(context, order);
                          },
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                          label: const Text('Xác nhận đơn hàng',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),

                    if (order.status == OrderStatus.pending)
                      const SizedBox(height: 10),

                    // ===== NÚT HỦY ĐƠN HÀNG =====
                    if (order.status != OrderStatus.cancelled && order.status != OrderStatus.delivered)
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showCancelDialog(context, order);
                          },
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
                          label: const Text('Hủy đơn hàng',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Xác nhận đơn hàng → chuyển status sang confirmed
  void _confirmOrder(BuildContext context, Order order) async {
    try {
      await _firebaseService.updateOrderStatus(order.id, OrderStatus.confirmed);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đơn hàng đã được xác nhận thành công!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi xác nhận: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hủy đơn hàng'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              try {
                await _firebaseService.updateOrderStatus(order.id, OrderStatus.cancelled);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đơn hàng đã được hủy'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi hủy đơn: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Xác nhận hủy', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
