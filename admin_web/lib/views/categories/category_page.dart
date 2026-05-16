import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../data/models/category_model.dart';
import '../layout/admin_layout.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller
    final CategoryController controller = Get.put(CategoryController());

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
                const Text(
                  'Danh Mục Sản Phẩm',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddCategoryDialog(context, controller),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('THÊM DANH MỤC', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
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
                  hintText: 'Tìm kiếm danh mục theo tên...',
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
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final query = controller.searchQuery.value.toLowerCase();
                  final realCategories = controller.filteredCategories;
                  final realNames = realCategories.map((c) => c.name.toLowerCase()).toSet();
                  final dummyCategories = _getDummyData()
                      .where((item) => item['name'].toString().toLowerCase().contains(query))
                      .where((item) => !realNames.contains(item['name'].toString().toLowerCase()))
                      .toList();
                  
                  final displayList = [...realCategories, ...dummyCategories];

                  return SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: true,
                      onSelectAll: (isSelected) {
                        if (isSelected == true) {
                          for (var item in displayList) {
                            controller.selectedIds.add(item is CategoryModel ? item.id! : (item as Map)['id'].toString());
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
                        DataColumn(label: Text('DANH MỤC', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('NỔI BẬT', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('NGÀY CẬP NHẬT', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                        DataColumn(label: Text('THAO TÁC', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A5568), fontSize: 12))),
                      ],
                      rows: List.generate(displayList.length, (index) {
                        final item = displayList[index];
                        final bool isReal = item is CategoryModel;
                        final String id = isReal ? (item as CategoryModel).id! : (item as Map)['id'].toString();
                        final String catName = isReal ? (item as CategoryModel).name : (item as Map)['name'].toString();
                        final String date = isReal ? 'N/A' : (item as Map)['date'].toString();
                        
                        return DataRow(
                          selected: controller.selectedIds.contains(id),
                          onSelectChanged: (val) => controller.toggleSelection(id),
                          cells: [
                          DataCell(Text('${index + 1}', style: const TextStyle(color: Color(0xFF4A5568)))),
                          DataCell(Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F3F5),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage('https://api.dicebear.com/7.x/identicon/png?seed=${catName.hashCode}'),
                                    fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(catName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                            ],
                          )),
                          const DataCell(Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 20)),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6FFFA),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFB2F5EA)),
                            ),
                            child: const Text('Hoạt động', style: TextStyle(color: Color(0xFF38B2AC), fontSize: 11, fontWeight: FontWeight.bold)),
                          )),
                          DataCell(Text(date, style: const TextStyle(color: Color(0xFF718096), fontSize: 13))),
                          DataCell(Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Color(0xFF3182CE), size: 16),
                                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _showEditCategoryDialog(context, controller, isReal ? (item as CategoryModel) : CategoryModel(id: id, name: catName)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53E3E), size: 16),
                                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _showDeleteConfirm(context, controller, id, catName),
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
            const SizedBox(height: 15),
            // Pagination dot (like bottom of image 1)
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

  List<Map<String, dynamic>> _getDummyData() {
    return [
      {'id': '1', 'name': 'Trà Sữa Truyền Thống', 'featured': true, 'date': '24/02/2026'},
      {'id': '2', 'name': 'Trà Hoa Quả', 'featured': true, 'date': '24/02/2026'},
      {'id': '3', 'name': 'Đá Xay (Ice Blended)', 'featured': true, 'date': '24/02/2026'},
      {'id': '4', 'name': 'Topping Đặc Biệt', 'featured': true, 'date': '24/02/2026'},
      {'id': '5', 'name': 'Ăn Vặt Kèm Theo', 'featured': true, 'date': '24/02/2026'},
    ];
  }

  void _showAddCategoryDialog(BuildContext context, CategoryController controller) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    Get.defaultDialog(
      title: 'Thêm danh mục mới',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Tên danh mục'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: 'Mô tả'),
          ),
        ],
      ),
      textCancel: 'Hủy',
      textConfirm: 'Lưu',
      onConfirm: () async {
        if (nameController.text.isNotEmpty) {
          await controller.addCategory(CategoryModel(
            name: nameController.text,
            description: descController.text,
          ));
          Get.back();
        }
      }
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryController controller, CategoryModel category) {
    final nameController = TextEditingController(text: category.name);
    final descController = TextEditingController(text: category.description);

    Get.defaultDialog(
      title: 'Chỉnh sửa danh mục',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Tên danh mục'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: 'Mô tả'),
          ),
        ],
      ),
      textCancel: 'Hủy',
      textConfirm: 'Cập nhật',
      onConfirm: () async {
        if (nameController.text.isNotEmpty) {
          final model = CategoryModel(
            id: category.id,
            name: nameController.text,
            description: descController.text,
          );
          
          if (category.id != null && !category.id!.startsWith('1') && category.id!.length > 5) {
             await controller.updateCategory(model);
             Get.snackbar('Thành công', 'Đã cập nhật danh mục', backgroundColor: Colors.blue, colorText: Colors.white);
          } else {
             // It's a dummy category (ID is '1', '2' etc) - save as NEW
             await controller.addCategory(CategoryModel(
               name: nameController.text,
               description: descController.text,
             ));
             Get.snackbar('Thành công', 'Đã lưu danh mục mẫu thành danh mục thật', backgroundColor: Colors.green, colorText: Colors.white);
          }
          Get.back();
        }
      }
    );
  }

  void _showDeleteConfirm(BuildContext context, CategoryController controller, String id, String name) {
    Get.defaultDialog(
      title: 'Xác nhận xóa',
      middleText: 'Bạn có chắc chắn muốn xóa danh mục [$name] không?',
      textConfirm: 'Xóa',
      textCancel: 'Hủy',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        await controller.deleteCategory(id);
        Get.back();
      },
    );
  }
}

