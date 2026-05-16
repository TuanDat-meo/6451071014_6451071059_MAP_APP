import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import 'package:admin_web/data/models/product_model.dart';
import '../layout/admin_layout.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

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
                  'Kho sản phẩm',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showProductDialog(context, controller),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('THÊM MỚI SẢN PHẨM', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
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

            // Search Bar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                onChanged: (val) => controller.updateSearch(val),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF536DFE), size: 20),
                  hintText: 'Tìm kiếm sản phẩm...',
                  hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
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
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
                  
                  final query = controller.searchQuery.value.toLowerCase();
                  final realProducts = controller.filteredProducts;
                  final realNames = realProducts.map((p) => p.name.toLowerCase()).toSet();
                  final dummyProducts = _getDummyProducts()
                      .where((item) => item['name'].toString().toLowerCase().contains(query))
                      .where((item) => !realNames.contains(item['name'].toString().toLowerCase()))
                      .toList();
                  
                  final displayList = [...realProducts, ...dummyProducts];

                  return SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: true,
                      onSelectAll: (isSelected) {
                        if (isSelected == true) {
                          for (var item in displayList) {
                            controller.selectedIds.add(item is ProductModel ? item.id! : (item as Map)['id'].toString());
                          }
                        } else {
                          controller.selectedIds.clear();
                        }
                        controller.selectedIds.refresh();
                      },
                      columnSpacing: 20,
                      horizontalMargin: 20,
                      headingRowHeight: 50,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                      columns: const [
                        DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('SẢN PHẨM', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('GIÁ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('LOẠI', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('SỐ LƯỢNG', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('CÒN HÀNG', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('HIỂN THỊ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                        DataColumn(label: Text('THAO TÁC', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12))),
                      ],
                      rows: List.generate(displayList.length, (i) {
                        final p = displayList[i];
                        final bool isReal = p is ProductModel;
                        final String id = isReal ? (p as ProductModel).id! : (p as Map)['id'].toString();
                        final name = isReal ? (p as ProductModel).name : (p as Map)['name'];
                        final price = isReal ? '${(p as ProductModel).price.toStringAsFixed(0)} đ' : '${(p as Map)['price']} đ';
                        final stock = isReal ? '${(p as ProductModel).stock}' : (p as Map)['stock'];
                        String imgUrl = isReal 
                            ? ((p as ProductModel).images.isNotEmpty ? (p as ProductModel).images.first : '') 
                            : (p as Map)['image'] ?? '';
                        
                        // Fix path mismatch: remove 'images/' if it exists in the path
                        imgUrl = imgUrl.replaceAll('assets/images/', 'assets/');

                        return DataRow(
                          selected: controller.selectedIds.contains(id),
                          onSelectChanged: (val) => controller.toggleSelection(id),
                          cells: [
                          DataCell(Text('${i + 1}', style: const TextStyle(color: Color(0xFF94A3B8)))),

                          DataCell(Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F3F5),
                                  borderRadius: BorderRadius.circular(8),
                                  image: imgUrl.isNotEmpty ? DecorationImage(
                                    image: imgUrl.startsWith('assets') 
                                        ? AssetImage(imgUrl) as ImageProvider
                                        : NetworkImage(imgUrl),
                                    fit: BoxFit.cover
                                  ) : null,
                                ),
                                child: imgUrl.isEmpty ? const Icon(Icons.local_drink_rounded, size: 18, color: Color(0xFF94A3B8)) : null,
                              ),
                              const SizedBox(width: 12),
                              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                            ],
                          )),
                          DataCell(Text(price, style: const TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold))),
                          const DataCell(Text('mặc định', style: TextStyle(color: Color(0xFF64748B)))),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(6)),
                            child: Text('$stock Còn hàng', style: const TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.w600)),
                          )),
                          const DataCell(Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20)),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Đã đăng', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 11, fontWeight: FontWeight.w600)),
                          )),
                          const DataCell(Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20)),
                          DataCell(Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Color(0xFF3182CE), size: 16),
                                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _showProductDialog(context, controller, product: isReal ? (p as ProductModel) : null, id: isReal ? null : id, name: isReal ? null : name),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53E3E), size: 16),
                                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _showDeleteConfirm(context, controller, id, name),
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
            // Footer Pagination
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left, color: Color(0xFF64748B), size: 20),
                SizedBox(width: 10),
                Text('Trang 1 / 1', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
                SizedBox(width: 10),
                Icon(Icons.chevron_right, color: Color(0xFF64748B), size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
  List<Map<String, dynamic>> _getDummyProducts() {
    return [
      {'id': '1', 'name': 'Trà sữa truyền thống', 'cat': 'Trà sữa', 'price': 35000, 'stock': 50, 'image': 'assets/image.png', 'desc': 'Trà sữa vị truyền thống thơm ngon đậm đà.'},
      {'id': '2', 'name': 'Trà sữa Matcha', 'cat': 'Trà sữa', 'price': 45000, 'stock': 30, 'image': 'assets/image1.png', 'desc': 'Trà sữa Matcha chuẩn vị Nhật Bản.'},
      {'id': '3', 'name': 'Trà sữa Socola', 'cat': 'Trà sữa', 'price': 42000, 'stock': 25, 'image': 'assets/image2.png', 'desc': 'Sự kết hợp hoàn hảo giữa trà sữa và socola.'},
      {'id': '4', 'name': 'Trà đào cam sả', 'cat': 'Trà trái cây', 'price': 39000, 'stock': 40, 'image': 'assets/image4.png', 'desc': 'Thức uống giải nhiệt thanh mát.'},
      {'id': '5', 'name': 'Trà sữa trân châu đường đen', 'cat': 'Đặc biệt', 'price': 55000, 'stock': 15, 'image': 'assets/image5.png', 'desc': 'Trân châu đường đen dai giòn sần sật.'},
      {'id': '6', 'name': 'Hồng trà sủi bọt', 'cat': 'Trà nguyên chất', 'price': 32000, 'stock': 60, 'image': 'assets/image6.png', 'desc': 'Lớp kem mặn bậy trên nền hồng trà.'},
      {'id': '7', 'name': 'Trà sữa khoai môn', 'cat': 'Trà sữa', 'price': 45000, 'stock': 20, 'image': 'assets/image7.png', 'desc': 'Vị khoai môn thơm bùi tự nhiên.'},
      {'id': '8', 'name': 'Sữa tươi trân châu đường đen', 'cat': 'Đặc biệt', 'price': 50000, 'stock': 10, 'image': 'assets/image8.png', 'desc': 'Sữa tươi nguyên chất kết hợp đường đen.'},
      {'id': '9', 'name': 'Trà dâu tây', 'cat': 'Trà trái cây', 'price': 42000, 'stock': 35, 'image': 'assets/image9.png', 'desc': 'Trà dâu tây tươi mát cho ngày nắng.'},
      {'id': '10', 'name': 'Trà sữa bạc hà', 'cat': 'Trà sữa', 'price': 38000, 'stock': 45, 'image': 'assets/image10.png', 'desc': 'Cảm giác sảng khoái với vị bạc hà mát lạnh.'},
    ];
  }

  void _showDeleteConfirm(BuildContext context, ProductController controller, String id, String name) {
    Get.defaultDialog(
      title: 'Xác nhận xóa',
      middleText: 'Bạn có chắc chắn muốn xóa sản phẩm [$name] không?',
      textConfirm: 'Xóa',
      textCancel: 'Hủy',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        await controller.deleteProduct(id);
        Get.back();
      },
    );
  }

  void _showProductDialog(BuildContext context, ProductController controller, {ProductModel? product, String? id, String? name}) {
    final nameCtrl = TextEditingController(text: product?.name ?? name);
    final priceCtrl = TextEditingController(text: product?.price.toString() ?? '');
    final stockCtrl = TextEditingController(text: product?.stock.toString() ?? '');

    Get.defaultDialog(
      title: product == null && id == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm',
      content: Column(
        children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
          TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Giá'), keyboardType: TextInputType.number),
          TextField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Số lượng'), keyboardType: TextInputType.number),
        ],
      ),
      textConfirm: 'LƯU',
      onConfirm: () async {
        final p = ProductModel(
          id: product?.id ?? id,
          name: nameCtrl.text,
          price: double.tryParse(priceCtrl.text) ?? 0.0,
          stock: int.tryParse(stockCtrl.text) ?? 0,
          images: product?.images ?? [],
          description: product?.description ?? '',
          categoryId: product?.categoryId ?? '',
          brandId: product?.brandId ?? '',
          isFeatured: product?.isFeatured ?? false,
        );
        if (product != null) {
          await controller.updateProduct(p);
          Get.snackbar('Thành công', 'Đã cập nhật sản phẩm', backgroundColor: Colors.blue, colorText: Colors.white);
        } else {
          await controller.addProduct(p);
          Get.snackbar('Thành công', 'Đã lưu sản phẩm mới', backgroundColor: Colors.green, colorText: Colors.white);
        }
        Get.back();
      }
    );
  }
}
