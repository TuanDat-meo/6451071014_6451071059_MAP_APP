import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../data/models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find<OrderController>();
    final selectedStatus = order.status.obs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng #${order.id?.substring(0, 8).toUpperCase()}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag, color: Colors.white, size: 30),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ĐƠN HÀNG: #${order.id?.toUpperCase()}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Trạng thái thanh toán: PENDING',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildInfoSection('Thông tin chung', [
                        _buildInfoRow('Ngày đặt:', '25/04/2026 23:11'),
                        _buildInfoRow('Số lượng mục:', '${order.items.length} sản phẩm'),
                        _buildInfoRow('Tổng thanh toán:', '\$${order.totalAmount}'),
                      ]),
                      const SizedBox(height: 20),
                      _buildItemsSection(order.items),
                      const SizedBox(height: 20),
                      _buildTransactionSection(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Right Column
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildStatusUpdateSection(selectedStatus, controller),
                      const SizedBox(height: 20),
                      _buildCustomerSection(order),
                      const SizedBox(height: 20),
                      _buildShippingSection(),
                      const SizedBox(height: 20),
                      _buildActivitySection(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 18),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 30),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildItemsSection(List<OrderItem> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: Colors.blue, size: 18),
              const SizedBox(width: 10),
              Text('Sản phẩm đã mua', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[50]),
                children: const [
                  Padding(padding: EdgeInsets.all(10), child: Text('SẢN PHẨM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(10), child: Text('ĐƠN GIÁ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(10), child: Text('SL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(10), child: Text('TỔNG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                ],
              ),
              ...items.map((item) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(width: 30, height: 30, color: Colors.grey[200], child: const Icon(Icons.image, size: 15)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(item.productName, style: const TextStyle(fontSize: 12))),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(10), child: Text('\$${item.price}', style: const TextStyle(fontSize: 12))),
                  Padding(padding: const EdgeInsets.all(10), child: Text('x${item.quantity}', style: const TextStyle(fontSize: 12))),
                  Padding(padding: const EdgeInsets.all(10), child: Text('\$${item.price * item.quantity}', style: const TextStyle(fontSize: 12))),
                ],
              )),
            ],
          ),
          const Divider(height: 40),
          _buildSummaryRow('Tạm tính', '\$74000'),
          _buildSummaryRow('Giảm giá Coupon', '-\$0', color: Colors.red),
          _buildSummaryRow('Phí vận chuyển', '\$0'),
          _buildSummaryRow('Thuế', '\$7400'),
          const Divider(),
          _buildSummaryRow('Tổng cộng', '\$${order.totalAmount}', isBold: true, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatusUpdateSection(RxString selectedStatus, OrderController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit_calendar, color: Colors.blue, size: 18),
              const SizedBox(width: 10),
              Text('Cập nhật đơn hàng', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus.value,
                isExpanded: true,
                items: ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => selectedStatus.value = val!,
              ),
            ),
          )),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.updateStatus(order.id!, selectedStatus.value),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: const Text('Cập nhật trạng thái'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_outline, color: Colors.blue, size: 18),
              const SizedBox(width: 10),
              Text('Khách hàng', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.blue[50], child: Text(order.customerName[0])),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text('customer@example.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: Colors.blue, size: 18),
              const SizedBox(width: 10),
              Text('Địa chỉ giao hàng', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 16),
              SizedBox(width: 10),
              Expanded(child: Text('66 Bình Dương, Phường Cửa Lò, Tỉnh Nghệ An', style: TextStyle(fontSize: 13))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, color: Colors.blue, size: 18),
              const SizedBox(width: 10),
              Text('Lịch sử hoạt động', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          _buildActivityItem('Đơn hàng được khởi tạo', '25/04/2026 23:11', isFirst: true),
          _buildActivityItem('Trạng thái: DELIVERED', '25/04/2026 15:30', isLast: true, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, {bool isFirst = false, bool isLast = false, Color color = Colors.blue}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            if (!isLast) Container(width: 2, height: 30, color: Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment, color: Colors.blue, size: 18),
              const SizedBox(width: 10),
              Text('Giao dịch (cash)', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 30),
          _buildInfoRow('Trạng thái:', 'PENDING'),
          _buildInfoRow('Ngày vận chuyển:', 'Chưa có thông tin'),
          _buildInfoRow('Số tiền khớp:', '\$0'),
          const Divider(),
          TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Cập nhật giao dịch')),
        ],
      ),
    );
  }
}
