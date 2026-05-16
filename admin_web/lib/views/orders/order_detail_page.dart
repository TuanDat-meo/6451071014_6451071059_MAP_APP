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
        title: Text(
          'Chi tiết đơn hàng #${order.id?.toUpperCase() ?? ""}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: const Color(0xFFF7FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Hero Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3182CE), Color(0xFF4299E1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF3182CE).withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.shopping_bag, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ĐƠN HÀNG: #${order.id?.toUpperCase()}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Trạng thái thanh toán: ${order.status == 'DELIVERED' ? 'ĐÃ THANH TOÁN' : 'CHỜ THANH TOÁN'}',
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Details Container
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildCardSection(
                        icon: Icons.info_outline,
                        title: 'Thông tin chung',
                        child: Column(
                          children: [
                            _buildDetailRow('Ngày đặt', '25/04/2026 23:11'),
                            _buildDetailRow('Số lượng mục', '${order.items.length} món'),
                            _buildDetailRow('Tổng thanh toán', '${order.totalAmount.toStringAsFixed(0)} đ', isGreen: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCardSection(
                        icon: Icons.inventory_2_outlined,
                        title: 'Sản phẩm đã mua',
                        child: _buildItemsTable(order.items),
                      ),
                      const SizedBox(height: 20),
                      _buildCardSection(
                        icon: Icons.payment,
                        title: 'Giao dịch (cash)',
                        child: Column(
                          children: [
                            _buildDetailRow('Trạng thái', 'CHỜ THANH TOÁN', isOrange: true),
                            _buildDetailRow('Ngày vận chuyển', 'Chưa có thông tin'),
                            _buildDetailRow('Số tiền khớp', '0 đ'),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.edit, size: 14),
                                label: const Text('Cập nhật giao dịch', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                onPressed: () {
                                  Get.snackbar('Thông báo', 'Đã cập nhật thông tin giao dịch!', snackPosition: SnackPosition.BOTTOM);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right Actions Container
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Status Update
                      _buildCardSection(
                        icon: Icons.cached,
                        title: 'Cập nhật đơn hàng',
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Obx(() => DropdownButton<String>(
                                  value: ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'].contains(selectedStatus.value) 
                                      ? selectedStatus.value 
                                      : 'Pending',
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: const [
                                    DropdownMenuItem(value: 'Pending', child: Text('Chờ xử lý')),
                                    DropdownMenuItem(value: 'Processing', child: Text('Đang làm món')),
                                    DropdownMenuItem(value: 'Shipped', child: Text('Đang giao')),
                                    DropdownMenuItem(value: 'Delivered', child: Text('Đã hoàn thành')),
                                    DropdownMenuItem(value: 'Cancelled', child: Text('Đã hủy')),
                                  ],
                                  onChanged: (val) => selectedStatus.value = val!,
                                )),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.updateStatus(order.id!, selectedStatus.value);
                                  Get.snackbar('Thông báo', 'Cập nhật trạng thái thành công!', snackPosition: SnackPosition.BOTTOM);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3182CE),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Cập nhật trạng thái', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Customer Info
                      _buildCardSection(
                        icon: Icons.person_outline,
                        title: 'Khách hàng',
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFFEBF8FF),
                              child: Text(
                                order.customerName.isNotEmpty ? order.customerName[0].toUpperCase() : '?',
                                style: const TextStyle(color: Color(0xFF4299E1), fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                                  Text('${order.customerName.replaceAll(' ', '').toLowerCase()}@gm.uit.edu.vn', style: const TextStyle(color: Color(0xFF718096), fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Shipping
                      _buildCardSection(
                        icon: Icons.local_shipping_outlined,
                        title: 'Địa chỉ giao hàng',
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on, size: 16, color: Color(0xFFE53E3E)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '66 Bình Dương, Phường Cửa Lò, Tỉnh Nghệ An',
                                style: TextStyle(color: Color(0xFF4A5568), height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Timeline
                      _buildCardSection(
                        icon: Icons.history,
                        title: 'Lịch sử hoạt động',
                        child: Column(
                          children: [
                            _buildTimelineItem('Đơn hàng được khởi tạo', '25/04/2026 23:11', isFinished: true),
                            _buildTimelineItem('Trạng thái: ĐÃ HOÀN THÀNH', '25/04/2026 15:30', isLast: true, isSuccess: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF3182CE)),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D3748))),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFEDF2F7)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isGreen = false, bool isOrange = false}) {
    Color valColor = const Color(0xFF2D3748);
    if (isGreen) valColor = const Color(0xFF38A169);
    if (isOrange) valColor = const Color(0xFFDD6B20);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Color(0xFF718096)))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valColor)),
        ],
      ),
    );
  }

  Widget _buildItemsTable(List<OrderItem> items) {
    return Column(
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.5),
          },
          children: [
            const TableRow(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 12), child: Text('SẢN PHẨM', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 11, fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.only(bottom: 12), child: Text('ĐƠN GIÁ', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 11, fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.only(bottom: 12), child: Text('SL', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 11, fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.only(bottom: 12), child: Text('TỔNG', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
              ],
            ),
            ...items.map((i) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC), 
                          borderRadius: BorderRadius.circular(4),
                          image: i.productImage != null ? DecorationImage(
                            image: i.productImage!.startsWith('assets') 
                                ? AssetImage(i.productImage!.replaceAll('assets/images/', 'assets/')) as ImageProvider
                                : NetworkImage(i.productImage!),
                            fit: BoxFit.cover,
                          ) : null,
                        ),
                        child: i.productImage == null ? const Icon(Icons.local_drink_rounded, size: 16, color: Color(0xFFA0AEC0)) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(i.productName, style: const TextStyle(fontSize: 13, color: Color(0xFF4A5568)))),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('${i.price.toStringAsFixed(0)}đ', style: const TextStyle(fontSize: 13))),
                Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('x${i.quantity}', style: const TextStyle(fontSize: 13))),
                Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('${(i.price * i.quantity).toStringAsFixed(0)} đ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), textAlign: TextAlign.right)),
              ],
            )),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: Color(0xFFEDF2F7)),
        const SizedBox(height: 12),
        _buildBillSummary('Tạm tính', '74800 đ'),
        _buildBillSummary('Giảm giá Coupon', '-0 đ', isRed: true),
        _buildBillSummary('Phí vận chuyển', '2 đ'),
        _buildBillSummary('Thuế', '7480 đ'),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              '${order.totalAmount.toStringAsFixed(0)} đ',
              style: const TextStyle(color: Color(0xFF3182CE), fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        )
      ],
    );
  }

  Widget _buildBillSummary(String label, String val, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF718096), fontSize: 13)),
          Text(val, style: TextStyle(color: isRed ? const Color(0xFFE53E3E) : const Color(0xFF2D3748), fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, {bool isLast = false, bool isSuccess = false, bool isFinished = false}) {
    final Color dotColor = isSuccess ? const Color(0xFF38A169) : const Color(0xFF3182CE);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            if (!isLast) Container(width: 1, height: 35, color: const Color(0xFFE2E8F0)),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF2D3748))),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 11)),
              const SizedBox(height: 15),
            ],
          ),
        )
      ],
    );
  }
}
