import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../layout/admin_layout.dart';
import 'order_detail_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Obx(() {
                if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
                
                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Seq')),
                      DataColumn(label: Text('Order ID')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Item')),
                      DataColumn(label: Text('Order Status')),
                      DataColumn(label: Text('Payment')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: controller.orders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final order = entry.value;
                      return DataRow(cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text('#${order.id?.substring(0, 8).toUpperCase() ?? "N/A"}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                        DataCell(Row(
                          children: [
                            CircleAvatar(radius: 12, backgroundColor: Colors.blue[100], child: Text(order.customerName[0], style: const TextStyle(fontSize: 10))),
                            const SizedBox(width: 8),
                            Text(order.customerName),
                          ],
                        )),
                        DataCell(Text('${order.items.length} sp')),
                        DataCell(_buildStatusChip(order.status)),
                        DataCell(_buildPaymentChip('PENDING')), // Placeholder
                        DataCell(Text('\$${order.totalAmount}', style: const TextStyle(fontWeight: FontWeight.bold))),
                        const DataCell(Text('25/04/2026')), // Placeholder
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, color: Colors.blue, size: 20),
                              onPressed: () => Get.to(() => OrderDetailPage(order: order)),
                            ),
                            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () {}),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    if (status == 'Delivered') color = Colors.green;
    if (status == 'Cancelled') color = Colors.red;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPaymentChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.red[100]!)),
      child: const Text('PENDING', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Tìm mã đơn, tên khách...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.refresh), label: const Text('Làm mới')),
      ],
    );
  }
}
