import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../layout/admin_layout.dart';
import 'order_detail_page.dart';
import '../../data/models/order_model.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return AdminLayout(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Quản lý đơn hàng',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
            ),
            const SizedBox(height: 25),

            // Actions Row
            Row(
              children: [
                // Search
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFFA0AEC0), size: 22),
                      hintText: 'Tìm mã đơn, tên khách...',
                      hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Refresh Btn
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF3182CE)),
                  label: const Text('Làm mới', style: TextStyle(color: Color(0xFF3182CE))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFFEDF2F7)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Data Table
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Obx(() {
                  if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

                  final hasData = controller.orders.isNotEmpty;
                  final List<dynamic> displayList = (hasData ? controller.orders : _getDummyOrders()) as List<dynamic>;

                  return SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: true,
                      onSelectAll: (isSelected) {
                        if (isSelected == true) {
                          for (var item in displayList) {
                            controller.selectedIds.add(hasData ? (item as OrderModel).id! : (item as Map)['id'].toString());
                          }
                        } else {
                          controller.selectedIds.clear();
                        }
                        controller.selectedIds.refresh();
                      },
                      columnSpacing: 20,
                      dataRowMaxHeight: 60,
                      headingRowHeight: 50,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                      columns: const [
                        DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('MÃ ĐƠN', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('KHÁCH HÀNG', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('MÓN', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('THANH TOÁN', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('TỔNG TIỀN', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('NGÀY ĐẶT', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                        DataColumn(label: Text('HÀNH ĐỘNG', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                      ],

                      rows: List.generate(displayList.length, (i) {
                        if (hasData) {
                          final ord = displayList[i] as OrderModel;
                          return _buildNativeRow(i + 1, ord, controller);
                        }
                        final d = displayList[i] as Map;
                        final String id = d['id'];
                        final dummyOrder = OrderModel(
                          id: id,
                          customerId: 'cust1',
                          customerName: d['cust'],
                          orderDate: DateTime.now(),
                          totalAmount: (d['amt'] as num).toDouble(),
                          status: d['st'],
                          items: [
                            OrderItem(productId: 'p1', productName: 'Trà sữa truyền thống', quantity: 1, price: 35000, productImage: 'assets/image.png'),
                            OrderItem(productId: 'p2', productName: 'Trà sữa Matcha', quantity: 1, price: 45000, productImage: 'assets/image1.png'),
                          ],
                        );
                        
                        return DataRow(
                          selected: controller.selectedIds.contains(id),
                          onSelectChanged: (val) => controller.toggleSelection(id),
                          cells: [
                          DataCell(Text('${i + 1}', style: const TextStyle(color: Color(0xFF718096)))),

                          DataCell(
                            InkWell(
                              onTap: () => Get.to(() => OrderDetailPage(order: dummyOrder)),
                              child: Text(
                                '#${d['id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3182CE),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFE2E8F0),
                                ),
                              ),
                            )
                          ),
                          DataCell(Row(
                            children: [
                              CircleAvatar(radius: 10, backgroundColor: const Color(0xFFEBF8FF), child: Text(d['cust'][0], style: const TextStyle(fontSize: 10, color: Color(0xFF4299E1)))),
                              const SizedBox(width: 8),
                              Text(d['cust'], style: const TextStyle(color: Color(0xFF4A5568))),
                            ],
                          )),
                          const DataCell(Text('2 sp', style: TextStyle(color: Color(0xFF718096)))),
                          DataCell(_buildFancyStatus(d['st'])),
                          DataCell(_buildFancyPayment(d['pay'])),
                          DataCell(Text('\$${d['amt']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748)))),
                          DataCell(Text(d['date'], style: const TextStyle(color: Color(0xFF718096)))),
                          DataCell(Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  icon: const Icon(Icons.visibility_rounded, color: Color(0xFF3182CE), size: 16),
                                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Get.to(() => OrderDetailPage(order: dummyOrder)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  icon: const Icon(Icons.delete_sweep_rounded, color: Color(0xFFE53E3E), size: 16),
                                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          )),

                        ]);
                      }),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildNativeRow(int seq, OrderModel ord, OrderController controller) {
    final String id = ord.id ?? '';
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
      DataCell(Text('$seq', style: const TextStyle(color: Color(0xFF718096)))),

      DataCell(
        InkWell(
          onTap: () => Get.to(() => OrderDetailPage(order: ord)),
          child: Text(
            '#${ord.id?.substring(0, 8).toUpperCase() ?? ""}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3182CE), decoration: TextDecoration.underline),
          ),
        )
      ),
      DataCell(Row(
        children: [
          CircleAvatar(radius: 10, backgroundColor: const Color(0xFFEBF8FF), child: Text(ord.customerName.isNotEmpty ? ord.customerName[0] : '?', style: const TextStyle(fontSize: 10, color: Color(0xFF4299E1)))),
          const SizedBox(width: 8),
          Text(ord.customerName, style: const TextStyle(color: Color(0xFF4A5568))),
        ],
      )),
      DataCell(Text('${ord.items.length} sp', style: const TextStyle(color: Color(0xFF718096)))),
      DataCell(_buildFancyStatus(ord.status)),
      DataCell(_buildFancyPayment('PAID')),
      DataCell(Text('${ord.totalAmount.toStringAsFixed(0)} đ', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748)))),
      const DataCell(Text('25/04/2026', style: TextStyle(color: Color(0xFF718096)))),
      DataCell(Row(
        children: [
          Container(
            decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: const Icon(Icons.visibility_rounded, color: Color(0xFF3182CE), size: 16),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              onPressed: () => Get.to(() => OrderDetailPage(order: ord)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53E3E), size: 16),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              onPressed: () {},
            ),
          ),
        ],
      )),

    ]);
  }

  Widget _buildFancyStatus(String status) {
    Color bg, text;
    String label;
    switch (status.toUpperCase()) {
      case 'DELIVERED':
        bg = const Color(0xFFF0FDF4); text = const Color(0xFF16A34A); label = 'ĐÃ GIAO'; break;
      case 'REFUNDED':
        bg = const Color(0xFFF1F5F9); text = const Color(0xFF64748B); label = 'HOÀN TIỀN'; break;
      case 'CANCELLED':
        bg = const Color(0xFFFEF2F2); text = const Color(0xFFEF4444); label = 'ĐÃ HỦY'; break;
      default:
        bg = const Color(0xFFFFF7ED); text = const Color(0xFFEA580C); label = 'CHỜ XỬ LÝ';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(color: text, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
    );
  }

  Widget _buildFancyPayment(String pay) {
    if (pay.toUpperCase() == 'PAID') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFBBF7D0))),
        child: const Text('ĐÃ THANH TOÁN', style: TextStyle(color: Color(0xFF16A34A), fontSize: 9, fontWeight: FontWeight.w800)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFFECACA))),
      child: const Text('CHỜ THANH TOÁN', style: TextStyle(color: Color(0xFFEF4444), fontSize: 9, fontWeight: FontWeight.w800)),
    );
  }

  List<Map<String, dynamic>> _getDummyOrders() {
    return [
      {'id': 'ORD-8821', 'cust': 'duong ngok', 'amt': 120000, 'st': 'DELIVERED', 'pay': 'PAID', 'date': '24/04/2026'},
      {'id': 'ORD-7712', 'cust': 'wakita kanenori', 'amt': 45000, 'st': 'PENDING', 'pay': 'PENDING', 'date': '25/04/2026'},
      {'id': 'ORD-6623', 'cust': 'hattori heji', 'amt': 85000, 'st': 'DELIVERED', 'pay': 'PAID', 'date': '24/04/2026'},
    ];
  }
}

