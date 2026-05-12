import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/coupon_controller.dart';
import '../layout/admin_layout.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Coupon Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('ADD COUPON'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
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
                      DataColumn(label: Text('COUPON')),
                      DataColumn(label: Text('DISCOUNT VALUE')),
                      DataColumn(label: Text('TYPE')),
                      DataColumn(label: Text('DESCRIPTION')),
                      DataColumn(label: Text('IS ACTIVE')),
                      DataColumn(label: Text('START DATE')),
                      DataColumn(label: Text('END DATE')),
                      DataColumn(label: Text('ACTION')),
                    ],
                    rows: controller.coupons.asMap().entries.map((entry) {
                      final index = entry.key;
                      final coupon = entry.value;
                      return DataRow(cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                        DataCell(Text(coupon.discountType == 'percentage' ? '${coupon.discountAmount}%' : '${coupon.discountAmount} đ')),
                        DataCell(Text(coupon.discountType.capitalizeFirst ?? '')),
                        DataCell(SizedBox(width: 200, child: Text('Giảm cho đơn hàng từ ${coupon.minOrderAmount}đ', overflow: TextOverflow.ellipsis))),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)),
                          child: const Text('Active', style: TextStyle(color: Colors.green, fontSize: 11)),
                        )),
                        const DataCell(Text('1/3/2026')),
                        DataCell(Text('${coupon.expiryDate.day}/${coupon.expiryDate.month}/${coupon.expiryDate.year}')),
                        DataCell(Row(
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 18), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 18), onPressed: () {}),
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
          hintText: 'Search coupon code...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
