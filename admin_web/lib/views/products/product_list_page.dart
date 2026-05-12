import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../layout/admin_layout.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Product Inventory', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('ADD PRODUCT'),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Obx(() {
                if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
                
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('SEQ')),
                        DataColumn(label: Text('PRODUCT')),
                        DataColumn(label: Text('PRICE')),
                        DataColumn(label: Text('TYPE')),
                        DataColumn(label: Text('STOCK')),
                        DataColumn(label: Text('CÒN HÀNG')),
                        DataColumn(label: Text('VISIBLE')),
                        DataColumn(label: Text('STATUS')),
                        DataColumn(label: Text('ACTION')),
                      ],
                      rows: controller.products.asMap().entries.map((entry) {
                        final index = entry.key;
                        final p = entry.value;
                        return DataRow(cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Row(
                            children: [
                              Container(
                                width: 35, height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: p.images.isNotEmpty 
                                  ? Image.network(p.images[0], errorBuilder: (c, e, s) => const Icon(Icons.image, size: 20))
                                  : const Icon(Icons.image, color: Colors.grey, size: 20),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 150,
                                child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis)
                              ),
                            ],
                          )),
                          DataCell(Text('\$${p.price}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                          const DataCell(Text('simple')),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)),
                            child: Text('${p.stock} In Stock', style: const TextStyle(color: Colors.green, fontSize: 11)),
                          )),
                          const DataCell(Icon(Icons.check_circle, color: Colors.green, size: 20)),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
                            child: const Text('Published', style: TextStyle(color: Colors.blue, fontSize: 11)),
                          )),
                          const DataCell(Icon(Icons.check_circle, color: Colors.green, size: 20)),
                          DataCell(Row(
                            children: [
                              IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 18), onPressed: () {}),
                              IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 18), onPressed: () {}),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          const Center(child: Text('< Page 1 of 1 >')),
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
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
