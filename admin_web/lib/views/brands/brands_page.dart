import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/brand_controller.dart';
import '../../data/models/brand_model.dart';
import '../layout/admin_layout.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());

    return AdminLayout(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quản Lý Thương Hiệu',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Quản lý các đối tác và nhãn hiệu sản phẩm của bạn',
                      style: TextStyle(color: Color(0xFF718096), fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => controller.selectedIds.isNotEmpty 
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFEBF8FF), borderRadius: BorderRadius.circular(6)),
                          child: Text('Đã chọn ${controller.selectedIds.length}', style: const TextStyle(color: Color(0xFF3182CE), fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      : const SizedBox.shrink()
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context, controller),
                  icon: const Icon(Icons.add_business_rounded, size: 18),
                  label: const Text('THÊM THƯƠNG HIỆU MỚI', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.3)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4361EE),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Compact Pill Search Bar
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
                ),
                child: TextField(
                  onChanged: (val) => controller.updateSearch(val),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFF536DFE), size: 20),
                    hintText: 'Tìm kiếm thương hiệu...',
                    hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Data Table
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0F2F5)),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

                  final query = controller.searchQuery.value.toLowerCase();
                  final realBrands = controller.filteredBrands;
                  final dummyBrands = _getDummyBrands()
                      .where((item) => item['name'].toString().toLowerCase().contains(query))
                      .toList();
                  
                  final displayList = [...realBrands, ...dummyBrands];

                  return SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: true,
                      onSelectAll: (isSelected) {
                        if (isSelected == true) {
                          for (var item in displayList) {
                            controller.selectedIds.add(item is BrandModel ? item.id! : (item as Map)['id'].toString());
                          }
                        } else {
                          controller.selectedIds.clear();
                        }
                        controller.selectedIds.refresh();
                      },
                      columnSpacing: 24,
                      headingRowHeight: 52,
                      dataRowMaxHeight: 65,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFF)),
                      columns: const [
                        DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF536DFE), fontSize: 12))),
                        DataColumn(label: Text('THƯƠNG HIỆU', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF536DFE), fontSize: 12))),
                        DataColumn(label: Text('DANH MỤC', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF536DFE), fontSize: 12))),
                        DataColumn(label: Text('NỔI BẬT', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF536DFE), fontSize: 12))),
                        DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF536DFE), fontSize: 12))),
                        DataColumn(label: Text('CẬP NHẬT', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF536DFE), fontSize: 12))),
                        DataColumn(label: Text('THAO TÁC', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF536DFE), fontSize: 12))),
                      ],
                      rows: List.generate(displayList.length, (i) {
                        final item = displayList[i];
                        if (item is BrandModel) {
                          return _buildNativeRow(context, i + 1, item, controller);
                        }
                        final d = item as Map<String, dynamic>;
                        // Clean up image path
                        if (d['image'] != null) {
                          d['image'] = d['image'].toString().replaceAll('assets/images/', 'assets/');
                        }
                        return _buildRow(context, i + 1, d, controller);
                      }),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 15),
            // Pagination Button
            Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: const Color(0xFF3F51B5), borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDummyBrands() {
    return [
      {'id': '11', 'name': 'Gong Cha', 'cats': ['Trà sữa', 'Trà nguyên chất'], 'featured': true, 'date': '24/2/2026', 'image': 'assets/image11.png'},
      {'id': '12', 'name': 'Koi Thé', 'cats': ['Macchiato', 'Trà đen'], 'featured': true, 'date': '24/2/2026', 'image': 'assets/image12.png'},
      {'id': '13', 'name': 'The Alley', 'cats': ['Trân châu đường đen'], 'featured': true, 'date': '24/2/2026', 'image': 'assets/image13.png'},
      {'id': '14', 'name': 'Ding Tea', 'cats': ['Trà trái cây', 'Đá xay'], 'featured': true, 'date': '24/2/2026', 'image': 'assets/image14.png'},
    ];
  }

  DataRow _buildRow(BuildContext context, int index, Map d, BrandController controller) {
    final String id = d['id'];
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
      DataCell(Text('$index', style: const TextStyle(color: Color(0xFF718096)))),

      DataCell(Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              image: d['image'] != null ? DecorationImage(
                image: AssetImage(d['image']),
                fit: BoxFit.cover
              ) : null,
            ),
            child: d['image'] == null ? const Icon(Icons.business, color: Colors.grey, size: 20) : null,
          ),
          const SizedBox(width: 12),
          Text(d['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
        ],
      )),
      DataCell(Wrap(
        spacing: 6,
        children: (d['cats'] as List<String>).map((c) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFE6F0FF), borderRadius: BorderRadius.circular(6)),
          child: Text(c, style: const TextStyle(color: Color(0xFF3182CE), fontSize: 11, fontWeight: FontWeight.w500)),
        )).toList(),
      )),
      DataCell(Icon(Icons.stars, color: (d['featured'] as bool) ? const Color(0xFFFFC107) : Colors.grey[300])),
      const DataCell(Text('Hoạt động', style: TextStyle(color: Color(0xFF38A169), fontWeight: FontWeight.w600, fontSize: 13))),
      DataCell(Text(d['date'], style: const TextStyle(color: Color(0xFF718096), fontSize: 13))),
      DataCell(Row(
        children: [
          Container(
            decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: const Icon(Icons.edit_rounded, color: Color(0xFF3182CE), size: 16),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              onPressed: () => _showEditDialog(context, controller, id: id, name: d['name'], isFeatured: d['featured']),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53E3E), size: 16),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              onPressed: () => _showDeleteConfirm(context, controller, id, d['name']),
            ),
          ),
        ],
      )),

    ]);
  }

  DataRow _buildNativeRow(BuildContext context, int index, BrandModel brand, BrandController controller) {
    final String id = brand.id!;
    return DataRow(
      selected: controller.selectedIds.contains(id),
      onSelectChanged: (val) => controller.toggleSelection(id),
      cells: [
      DataCell(Text('$index', style: const TextStyle(color: Color(0xFF718096)))),

      DataCell(Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 12),
          Text(brand.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
        ],
      )),
      const DataCell(Text('N/A')),
      DataCell(Icon(Icons.stars, color: brand.isFeatured ? const Color(0xFFFFC107) : Colors.grey[300])),
      const DataCell(Text('Hoạt động', style: TextStyle(color: Color(0xFF38A169), fontWeight: FontWeight.w600, fontSize: 13))),
      const DataCell(Text('24/2/2026', style: TextStyle(color: Color(0xFF718096), fontSize: 13))),
      DataCell(Row(
        children: [
          Container(
            decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: const Icon(Icons.edit_rounded, color: Color(0xFF3182CE), size: 16),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              onPressed: () => _showEditDialog(context, controller, id: id, name: brand.name, isFeatured: brand.isFeatured),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53E3E), size: 16),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              onPressed: () => _showDeleteConfirm(context, controller, id, brand.name),
            ),
          ),
        ],
      )),

    ]);
  }

  void _showEditDialog(BuildContext context, BrandController controller, {String? id, String? name, bool isFeatured = false}) {
    final nameController = TextEditingController(text: name);
    final featured = isFeatured.obs;

    Get.defaultDialog(
      title: id == null ? 'Thêm Thương Hiệu' : 'Chỉnh Sửa Thương Hiệu',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
      content: SizedBox(
        width: 400,
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên thương hiệu', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Obx(() => CheckboxListTile(
              title: const Text('Thương hiệu nổi bật'),
              value: featured.value,
              onChanged: (val) => featured.value = val ?? false,
            )),
          ],
        ),
      ),
      textConfirm: id == null ? 'THÊM' : 'LƯU',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF4361EE),
      onConfirm: () async {
        if (id == null) {
          await controller.addBrand(nameController.text, featured.value);
        } else {
          await controller.updateBrand(id, nameController.text, featured.value);
        }
        Get.back();
      },
      textCancel: 'HỦY',
      cancelTextColor: const Color(0xFF718096),
    );
  }

  void _showDeleteConfirm(BuildContext context, BrandController controller, String id, String name) {
    Get.defaultDialog(
      title: 'Xác Nhận Xóa',
      middleText: 'Bạn có chắc chắn muốn xóa thương hiệu "$name" không?',
      textConfirm: 'XÓA',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFE53E3E),
      onConfirm: () async {
        await controller.deleteBrand(id);
        Get.back();
      },
      textCancel: 'HỦY',
      cancelTextColor: const Color(0xFF718096),
    );
  }
}
