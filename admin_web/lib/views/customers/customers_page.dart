import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer_controller.dart';
import '../layout/admin_layout.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                      DataColumn(label: Text('SEQ')),
                      DataColumn(label: Text('CUSTOMER')),
                      DataColumn(label: Text('EMAIL')),
                      DataColumn(label: Text('PHONE')),
                      DataColumn(label: Text('ORDERS')),
                      DataColumn(label: Text('REGISTER DATE')),
                      DataColumn(label: Text('ACTION')),
                    ],
                    rows: controller.customers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final customer = entry.value;
                      return DataRow(cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue[50],
                              backgroundImage: customer.avatarUrl != null ? NetworkImage(customer.avatarUrl!) : null,
                              child: customer.avatarUrl == null ? Text(customer.fullName[0].toUpperCase(), style: const TextStyle(fontSize: 10)) : null,
                            ),
                            const SizedBox(width: 8),
                            Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        )),
                        DataCell(Text(customer.email)),
                        DataCell(Text(customer.phoneNumber ?? 'N/A')),
                        DataCell(Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(5)),
                            child: const Text('1', style: TextStyle(color: Colors.orange, fontSize: 11)), // Placeholder order count
                          ),
                        )),
                        const DataCell(Text('23/4/2026')), // Placeholder date
                        DataCell(Row(
                          children: [
                            IconButton(icon: const Icon(Icons.visibility_outlined, color: Colors.indigo, size: 20), onPressed: () {}),
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
          const SizedBox(height: 10),
          const Center(child: Text('1')),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search by name, email or phone...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
