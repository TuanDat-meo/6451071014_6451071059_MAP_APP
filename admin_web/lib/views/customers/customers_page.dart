import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer_controller.dart';
import 'package:admin_web/data/models/customer_model.dart';
import '../layout/admin_layout.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());

    // Exact mock data from snapshot
    final List<Map<String, dynamic>> mockData = [
      {'name': 'duong ngok', 'email': '16520270@gm.uit.edu.vn', 'phone': '0978720999', 'orders': 0, 'date': '23/4/2026', 'c': const Color(0xFF667EEA)},
      {'name': 'wakita kanenori', 'email': '16520270@gm.uit.edu.vn', 'phone': '0965332999', 'orders': 1, 'date': '25/4/2026', 'c': const Color(0xFF7F9CF5)},
      {'name': 'hattori heji', 'email': 'ntduong@utc2.edu.vn', 'phone': '0978720999', 'orders': 1, 'date': '24/2/2026', 'c': const Color(0xFFB794F4)},
      {'name': 'wakasa rumi', 'email': 'ntduong@st.utc2.edu.vn', 'phone': '0965879220', 'orders': 4, 'date': '23/2/2026', 'c': const Color(0xFF805AD5)},
    ];

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quản lý khách hàng',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A365D)),
              ),
              Obx(() => controller.selectedIds.isNotEmpty 
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFFED7D7), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Text('Đã chọn ${controller.selectedIds.length}', style: const TextStyle(color: Color(0xFFC53030), fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Color(0xFFC53030), size: 20),
                          onPressed: () => _showBulkDeleteConfirm(context, controller),
                          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink()
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSearchBar(controller),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 4)),
                ],
              ),
              child: Obx(() {
                if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
                
                final query = controller.searchQuery.value.toLowerCase();
                final realCustomers = controller.filteredCustomers;
                final dummyCustomers = mockData
                    .where((item) => 
                        item['name'].toString().toLowerCase().contains(query) || 
                        item['email'].toString().toLowerCase().contains(query))
                    .toList();
                
                final displayList = [...realCustomers, ...dummyCustomers];

                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: const Color(0xFFEDF2F7)),
                  child: SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: true,
                      onSelectAll: (isSelected) {
                        if (isSelected == true) {
                          for (var item in displayList) {
                            controller.selectedIds.add(item is CustomerModel ? item.id! : (item as Map<String, dynamic>)['id'] ?? 'mock_${displayList.indexOf(item)}');
                          }
                        } else {
                          controller.selectedIds.clear();
                        }
                        controller.selectedIds.refresh();
                      },
                      headingTextStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 12, fontWeight: FontWeight.bold),
                      dataRowMinHeight: 60,
                      dataRowMaxHeight: 72,
                      horizontalMargin: 24,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF7FAFC)),
                      columns: const [
                        DataColumn(label: Text('STT')),
                        DataColumn(label: Text('KHÁCH HÀNG')),
                        DataColumn(label: Text('EMAIL')),
                        DataColumn(label: Text('ĐIỆN THOẠI')),
                        DataColumn(label: Text('ĐƠN HÀNG')),
                        DataColumn(label: Text('NGÀY ĐĂNG KÝ')),
                        DataColumn(label: Text('HÀNH ĐỘNG')),
                      ],

                      rows: List.generate(displayList.length, (i) {
                        final item = displayList[i];
                        if (item is CustomerModel) {
                          return _buildNativeRow(context, i + 1, item, controller);
                        }

                        final d = item as Map<String, dynamic>;
                        final String id = d['id']?.toString() ?? 'mock_$i';
                        return _buildRow(context, i + 1, d, controller, id);
                      }),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF4C51BF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, int seq, Map<String, dynamic> d, CustomerController controller, String id) {
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
      DataCell(Text('$seq', style: const TextStyle(color: Color(0xFF718096)))),
      DataCell(Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: (d['c'] as Color).withOpacity(0.15),
            child: Text(d['name'][0].toUpperCase(), style: TextStyle(color: d['c'], fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Text(d['name'], style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
        ],
      )),
      DataCell(Text(d['email'], style: const TextStyle(color: Color(0xFF4A5568)))),
      DataCell(Text(d['phone'], style: const TextStyle(color: Color(0xFF718096)))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFFEEBC8), width: 0.5)),
        child: Text('${d['orders']}', style: const TextStyle(color: Color(0xFFDD6B20), fontSize: 12, fontWeight: FontWeight.bold)),
      )),
      DataCell(Text(d['date'], style: const TextStyle(color: Color(0xFF718096)))),
      DataCell(Row(
        children: [
          _buildActionBtn(Icons.visibility, const Color(0xFFEBF4FF), const Color(0xFF4C51BF)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _showDeleteConfirm(context, controller, id, d['name']),
            child: _buildActionBtn(Icons.delete, const Color(0xFFFFF5F5), const Color(0xFFE53E3E)),
          ),
        ],
      )),
    ]);
  }

  DataRow _buildNativeRow(BuildContext context, int seq, CustomerModel cust, CustomerController controller) {
    final String id = cust.id ?? 'cust_$seq';
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
      DataCell(Text('$seq', style: const TextStyle(color: Color(0xFF718096)))),
      DataCell(Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFE2E8F0),
            backgroundImage: cust.avatarUrl != null ? NetworkImage(cust.avatarUrl!) : null,
            child: cust.avatarUrl == null ? Text(cust.fullName[0].toUpperCase(), style: const TextStyle(color: Color(0xFF4A5568), fontSize: 12, fontWeight: FontWeight.bold)) : null,
          ),
          const SizedBox(width: 12),
          Text(cust.fullName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
        ],
      )),
      DataCell(Text(cust.email, style: const TextStyle(color: Color(0xFF4A5568)))),
      DataCell(Text(cust.phoneNumber ?? 'N/A', style: const TextStyle(color: Color(0xFF718096)))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFFEEBC8))),
        child: const Text('0', style: TextStyle(color: Color(0xFFDD6B20), fontSize: 12, fontWeight: FontWeight.bold)),
      )),
      const DataCell(Text('25/04/2026', style: TextStyle(color: Color(0xFF718096)))),
      DataCell(Row(
        children: [
          _buildActionBtn(Icons.visibility, const Color(0xFFEBF4FF), const Color(0xFF4C51BF)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _showDeleteConfirm(context, controller, id, cust.fullName),
            child: _buildActionBtn(Icons.delete, const Color(0xFFFFF5F5), const Color(0xFFE53E3E)),
          ),
        ],
      )),
    ]);
  }

  Widget _buildActionBtn(IconData icon, Color bg, Color iconCol) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Center(child: Icon(icon, size: 16, color: iconCol)),
    );
  }


  Widget _buildSearchBar(CustomerController controller) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: TextField(
        onChanged: (val) => controller.updateSearch(val),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên, email...',
          hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF667EEA), size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, CustomerController controller, String id, String name) {
    Get.defaultDialog(
      title: 'Xác nhận xóa',
      middleText: 'Bạn có chắc chắn muốn xóa khách hàng [$name] không?',
      textConfirm: 'XÓA',
      textCancel: 'HỦY',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        await controller.deleteCustomer(id);
        Get.back();
      }
    );
  }

  void _showBulkDeleteConfirm(BuildContext context, CustomerController controller) {
    Get.defaultDialog(
      title: 'Xóa nhiều mục',
      middleText: 'Bạn có chắc chắn muốn xóa ${controller.selectedIds.length} khách hàng đã chọn không?',
      textConfirm: 'Xóa tất cả',
      textCancel: 'Hủy',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        for (String id in controller.selectedIds) {
          await controller.deleteCustomer(id);
        }
        controller.selectedIds.clear();
        Get.back();
      },
    );
  }
}

