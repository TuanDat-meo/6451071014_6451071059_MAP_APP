import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/coupon_controller.dart';
import 'package:admin_web/data/models/coupon_model.dart';
import '../layout/admin_layout.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  void _showEditDialog(BuildContext context, CouponController controller, {CouponModel? coupon, String? code, String? id}) {
    final codeCtrl = TextEditingController(text: coupon?.code ?? code);
    final amountCtrl = TextEditingController(text: coupon?.discountAmount.toString() ?? '');

    Get.defaultDialog(
      title: coupon == null && id == null ? 'Thêm mã mới' : 'Chỉnh sửa mã',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C1A0E)),
      content: Column(
        children: [
          TextField(
            controller: codeCtrl,
            decoration: const InputDecoration(labelText: 'Mã giảm giá', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: amountCtrl,
            decoration: const InputDecoration(labelText: 'Số tiền/Phần trăm giảm', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      textConfirm: 'LƯU',
      textCancel: 'HỦY',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF2C1A0E),
      onConfirm: () async {
        if (coupon != null || id != null) {
          final updated = CouponModel(
            id: coupon?.id ?? id,
            code: codeCtrl.text,
            discountAmount: double.tryParse(amountCtrl.text) ?? 0.0,
            discountType: coupon?.discountType ?? 'fixed',
            minOrderAmount: coupon?.minOrderAmount ?? 0.0,
            expiryDate: coupon?.expiryDate ?? DateTime.now().add(const Duration(days: 7)),
          );
          await controller.updateCoupon(updated);
        } else {
          final newCoupon = CouponModel(
            code: codeCtrl.text,
            discountAmount: double.tryParse(amountCtrl.text) ?? 0.0,
            discountType: 'fixed',
            minOrderAmount: 0.0,
            expiryDate: DateTime.now().add(const Duration(days: 7)),
          );
          await controller.addCoupon(newCoupon);
        }
        Get.back();
      }
    );
  }

  void _showDeleteConfirm(BuildContext context, CouponController controller, String id, String code) {
    Get.defaultDialog(
      title: 'Xác nhận xóa',
      middleText: 'Bạn có chắc chắn muốn xóa mã [$code] không?',
      textConfirm: 'XÓA',
      textCancel: 'HỦY',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        await controller.deleteCoupon(id);
        Get.back();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());

    return AdminLayout(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quản Lý Mã Giảm Giá',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => controller.selectedIds.isNotEmpty 
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFFFFAF0), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFFBD38D))),
                          child: Text('Đã chọn ${controller.selectedIds.length} mã', style: const TextStyle(color: Color(0xFFB7791F), fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      : const SizedBox.shrink()
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context, controller),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('THÊM MÃ MỚI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C1A0E), // Matched to theme
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Search Bar
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 450,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  onChanged: (val) => controller.updateSearch(val),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFFD4A96A), size: 20),
                    hintText: 'Tìm kiếm mã giảm giá...',
                    hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Table Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

                  final hasRealData = controller.coupons.isNotEmpty;
                  final query = controller.searchQuery.value.toLowerCase();
                  final displayList = hasRealData 
                      ? controller.filteredCoupons 
                      : _getDummyCoupons().where((item) => item['code'].toString().toLowerCase().contains(query)).toList();

                  return SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: true,
                      onSelectAll: (isSelected) {
                        if (isSelected == true) {
                          for (var item in displayList) {
                            controller.selectedIds.add(hasRealData ? (item as CouponModel).id! : (item as Map)['id'].toString());
                          }
                        } else {
                          controller.selectedIds.clear();
                        }
                        controller.selectedIds.refresh();
                      },
                      columnSpacing: 24,
                      headingRowHeight: 52,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                      columns: const [
                        DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('MÃ GIẢM GIÁ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('GIÁ TRỊ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('LOẠI', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('MÔ TẢ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('NGÀY BẮT ĐẦU', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('HẾT HẠN', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                        DataColumn(label: Text('THAO TÁC', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11))),
                      ],

                      rows: List.generate(displayList.length, (i) {
                        if (hasRealData) {
                          final cp = displayList[i] as CouponModel;
                          return _buildNativeRow(context, i + 1, cp, controller);
                        }

                        final d = displayList[i] as Map;
                        final String id = d['id'].toString();
                        return DataRow(
                          selected: controller.selectedIds.contains(id),
                          onSelectChanged: (val) => controller.toggleSelection(id),
                          cells: [
                            DataCell(Text('${i + 1}', style: const TextStyle(color: Color(0xFF94A3B8)))),

                            DataCell(Text(d['code'], style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF475569)))),
                            DataCell(Text(d['val'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
                            DataCell(Text(d['type'], style: const TextStyle(color: Color(0xFF475569)))),
                            DataCell(Text(d['desc'], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF0FFF4), borderRadius: BorderRadius.circular(4)),
                              child: const Text('Đang chạy', style: TextStyle(color: Color(0xFF38A169), fontSize: 11, fontWeight: FontWeight.bold)),
                            )),
                            const DataCell(Text('1/3/2026', style: TextStyle(color: Color(0xFF475569), fontSize: 13))),
                            const DataCell(Text('8/3/2026', style: TextStyle(color: Color(0xFF475569), fontSize: 13))),
                            DataCell(Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: Color(0xFF3182CE), size: 16),
                                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _showEditDialog(context, controller, id: id, code: d['code']),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E), size: 16),
                                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _showDeleteConfirm(context, controller, id, d['code']),
                                  ),
                                ),
                              ],
                            )),
                          ]
                        );
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

  List<Map<String, dynamic>> _getDummyCoupons() {
    return [
      {'id': '1', 'code': 'SUMMER2026', 'val': '20%', 'type': 'Phần trăm', 'desc': 'Giảm cho 20% trên tổng đơn...'},
      {'id': '2', 'code': 'WELCOMETE', 'val': '50.000đ', 'type': 'Cố định', 'desc': 'Giảm cố định cho đơn đầu...'},
      {'id': '3', 'code': 'MILKTEA50', 'val': '50%', 'type': 'Phần trăm', 'desc': 'Giảm nửa giá trà sữa...'},
    ];
  }

  DataRow _buildNativeRow(BuildContext context, int seq, CouponModel coupon, CouponController controller) {
    final String id = coupon.id!;
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
        DataCell(Text('$seq', style: const TextStyle(color: Color(0xFF94A3B8)))),

        DataCell(Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF475569)))),
        DataCell(Text(
          coupon.discountType == 'percentage' ? '${coupon.discountAmount}%' : '${coupon.discountAmount} đ',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))
        )),
        DataCell(Text(coupon.discountType == 'percentage' ? 'Phần trăm' : 'Cố định', style: const TextStyle(color: Color(0xFF475569)))),
        DataCell(Text('Giảm tối thiểu ${coupon.minOrderAmount}đ', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFF0FFF4), borderRadius: BorderRadius.circular(4)),
          child: const Text('Hoạt động', style: TextStyle(color: Color(0xFF38A169), fontSize: 11, fontWeight: FontWeight.bold)),
        )),
        const DataCell(Text('1/3/2026', style: TextStyle(color: Color(0xFF475569), fontSize: 13))),
        DataCell(Text('${coupon.expiryDate.day}/${coupon.expiryDate.month}/${coupon.expiryDate.year}', style: const TextStyle(color: Color(0xFF475569), fontSize: 13))),
        DataCell(Row(
          children: [
             Container(
                decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
                child: IconButton(
                  icon: const Icon(Icons.edit_rounded, color: Color(0xFF3182CE), size: 16),
                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                  padding: EdgeInsets.zero,
                  onPressed: () => _showEditDialog(context, controller, coupon: coupon),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E), size: 16),
                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDeleteConfirm(context, controller, coupon.id!, coupon.code),
                ),
              ),
          ],
        )),
      ],
    );
  }
}

