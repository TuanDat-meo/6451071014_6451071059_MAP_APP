import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attribute_controller.dart';
import '../../data/models/attribute_model.dart';
import '../layout/admin_layout.dart';

class AttributePage extends StatelessWidget {
  const AttributePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AttributeController());

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
                      'Thuộc Tính Sản Phẩm',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => controller.selectedIds.isNotEmpty 
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFEDF2F7), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE2E8F0))),
                          child: Text('Đã chọn ${controller.selectedIds.length}', style: const TextStyle(color: Color(0xFF4A5568), fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      : const SizedBox.shrink()
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEditAttributeDialog(context, controller),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('THÊM THUỘC TÍNH', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4361EE),
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0F2F5)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: TextField(
                onChanged: (val) => controller.updateSearch(val),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFFA0AEC0), size: 22),
                  hintText: 'Tìm kiếm theo tên hoặc giá trị...',
                  hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Data Table Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Obx(() {
                  if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

                  final query = controller.searchQuery.value.toLowerCase();
                  final realAttributes = controller.filteredAttributes;
                  final dummyAttributes = _getDummyAttributes()
                      .where((item) => item['name'].toString().toLowerCase().contains(query))
                      .toList();
                  
                  final displayList = [...realAttributes, ...dummyAttributes];

                  return SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: true,
                      onSelectAll: (isSelected) {
                        if (isSelected == true) {
                          for (var item in displayList) {
                            controller.selectedIds.add(item is AttributeModel ? item.id! : (item as Map)['id'].toString());
                          }
                        } else {
                          controller.selectedIds.clear();
                        }
                        controller.selectedIds.refresh();
                      },
                      columnSpacing: 24,
                      headingRowHeight: 56,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                      columns: const [
                        DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('THUỘC TÍNH', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('GIÁ TRỊ', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('NGÀY CẬP NHẬT', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('THAO TÁC', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                      ],

                      rows: List.generate(displayList.length, (i) {
                        final item = displayList[i];
                        if (item is AttributeModel) {
                          return _buildNativeRow(context, i + 1, item, controller);
                        }
                        final d = item as Map;
                        return _buildRow(context, i + 1, d, controller);
                      }),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 15),
            // Pagination Dot
            Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: const Color(0xFF536DFE), borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDummyAttributes() {
    return [
      {'id': '1', 'name': 'size', 'vals': ['Lớn', 'Vừa', 'Nhỏ'], 'date': '2026-02-25'},
      {'id': '2', 'name': 'mức đường', 'vals': ['100%', '70%', '50%', '30%', '0%'], 'date': '2026-02-25'},
      {'id': '3', 'name': 'mức đá', 'vals': ['Thường', 'Ít đá', 'Không đá'], 'date': '2026-02-25'},
      {'id': '4', 'name': 'topping', 'vals': ['Trân châu đen', 'Thạch phô mai', 'Kem cheese'], 'date': '2026-02-25'},
    ];
  }

  DataRow _buildRow(BuildContext context, int seq, Map d, AttributeController controller) {
    final String id = d['id'];
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
        DataCell(Text('#$seq', style: const TextStyle(color: Color(0xFF718096), fontSize: 13))),
        DataCell(Text(
          d['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748), fontSize: 15),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (d['vals'] as List<String>).map((val) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(val, style: const TextStyle(color: Color(0xFF718096), fontSize: 12, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        )),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFC6F6D5).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 6, color: Color(0xFF38A169)),
              SizedBox(width: 6),
              Text('Hoạt động', style: TextStyle(color: Color(0xFF2F855A), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        )),
        DataCell(Text(d['date'], style: const TextStyle(color: Color(0xFF718096), fontSize: 13))),
        DataCell(Row(
          children: [
            Container(
              decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                icon: const Icon(Icons.edit_rounded, color: Color(0xFF3182CE), size: 16),
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                padding: EdgeInsets.zero,
                onPressed: () => _showEditAttributeDialog(context, controller, id: id, name: d['name'], values: List<String>.from(d['vals'])),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E), size: 16),
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                padding: EdgeInsets.zero,
                onPressed: () => _showDeleteConfirm(context, controller, id, d['name']),
              ),
            ),
          ],
        )),

      ]
    );
  }

  DataRow _buildNativeRow(BuildContext context, int seq, AttributeModel attr, AttributeController controller) {
    final String id = attr.id!;
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
        DataCell(Text('#$seq', style: const TextStyle(color: Color(0xFF718096), fontSize: 13))),
        DataCell(Text(
          attr.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748), fontSize: 15),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (attr.values ?? []).map((val) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(val, style: const TextStyle(color: Color(0xFF718096), fontSize: 12, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        )),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFC6F6D5).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 6, color: Color(0xFF38A169)),
              SizedBox(width: 6),
              Text('Hoạt động', style: TextStyle(color: Color(0xFF2F855A), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        )),
        const DataCell(Text('2026-02-25', style: TextStyle(color: Color(0xFF718096), fontSize: 13))),
        DataCell(Row(
          children: [
            Container(
              decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                icon: const Icon(Icons.edit_rounded, color: Color(0xFF3182CE), size: 16),
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                padding: EdgeInsets.zero,
                onPressed: () => _showEditAttributeDialog(context, controller, id: id, name: attr.name, values: attr.values),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E), size: 16),
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                padding: EdgeInsets.zero,
                onPressed: () => _showDeleteConfirm(context, controller, id, attr.name),
              ),
            ),
          ],
        )),

      ]
    );
  }

  void _showEditAttributeDialog(BuildContext context, AttributeController controller, {String? id, String? name, List<String>? values}) {
    final nameController = TextEditingController(text: name);
    final valController = TextEditingController(text: values?.join(', '));

    Get.defaultDialog(
      title: id == null ? 'Thêm Thuộc Tính' : 'Chỉnh Sửa Thuộc Tính',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
      backgroundColor: Colors.white,
      radius: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      content: SizedBox(
        width: 400,
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên thuộc tính (ví dụ: size, mức đường)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valController,
              decoration: const InputDecoration(
                labelText: 'Giá trị (phân cách bằng dấu phẩy)',
                hintText: 'Nhỏ, Vừa, Lớn',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      textConfirm: id == null ? 'THÊM' : 'LƯU',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF4361EE),
      onConfirm: () async {
        final List<String> vals = valController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        if (id == null) {
          await controller.addAttribute(nameController.text, vals);
        } else {
          await controller.updateAttribute(id, nameController.text, vals);
        }
        Get.back();
      },
      textCancel: 'HỦY',
      cancelTextColor: const Color(0xFF718096),
    );
  }

  void _showDeleteConfirm(BuildContext context, AttributeController controller, String id, String name) {
    Get.defaultDialog(
      title: 'Xác Nhận Xóa',
      middleText: 'Bạn có chắc chắn muốn xóa thuộc tính "$name" không?',
      textConfirm: 'XÓA',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFE53E3E),
      onConfirm: () async {
        await controller.deleteAttribute(id);
        Get.back();
      },
      textCancel: 'HỦY',
      cancelTextColor: const Color(0xFF718096),
    );
  }
}
