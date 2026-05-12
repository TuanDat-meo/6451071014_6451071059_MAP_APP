import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/brand_controller.dart';
import '../../data/models/product_model.dart';
import '../layout/admin_layout.dart';

class ProductFormPage extends StatelessWidget {
  final ProductModel? product;
  const ProductFormPage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final categoryController = Get.find<CategoryController>();
    final brandController = Get.find<BrandController>();

    final nameController = TextEditingController(text: product?.name);
    final descController = TextEditingController(text: product?.description);
    final priceController = TextEditingController(text: product?.price.toString());
    final stockController = TextEditingController(text: product?.stock.toString());
    
    final selectedCategory = (product?.categoryId ?? '').obs;
    final selectedBrand = (product?.brandId ?? '').obs;
    final isFeatured = (product?.isFeatured ?? false).obs;

    return AdminLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
                Text(
                  product == null ? 'Add New Product' : 'Edit Product',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Basic Info
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          _buildLabel('Product Name'),
                          TextField(
                            controller: nameController,
                            decoration: _buildInputDecoration('Enter product name'),
                          ),
                          const SizedBox(height: 15),
                          _buildLabel('Description'),
                          TextField(
                            controller: descController,
                            maxLines: 5,
                            decoration: _buildInputDecoration('Enter product description'),
                          ),
                          const SizedBox(height: 20),
                          const Text('Pricing & Inventory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Price ($)'),
                                    TextField(
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      decoration: _buildInputDecoration('0.00'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Stock Quantity'),
                                    TextField(
                                      controller: stockController,
                                      keyboardType: TextInputType.number,
                                      decoration: _buildInputDecoration('0'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Right Column: Organization & Media
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Organization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _buildLabel('Category'),
                              Obx(() => DropdownButtonFormField<String>(
                                value: selectedCategory.value.isEmpty ? null : selectedCategory.value,
                                decoration: _buildInputDecoration('Select Category'),
                                items: categoryController.categories.map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                )).toList(),
                                onChanged: (val) => selectedCategory.value = val ?? '',
                              )),
                              const SizedBox(height: 15),
                              _buildLabel('Brand'),
                              Obx(() => DropdownButtonFormField<String>(
                                value: selectedBrand.value.isEmpty ? null : selectedBrand.value,
                                decoration: _buildInputDecoration('Select Brand'),
                                items: brandController.brands.map((b) => DropdownMenuItem(
                                  value: b.id,
                                  child: Text(b.name),
                                )).toList(),
                                onChanged: (val) => selectedBrand.value = val ?? '',
                              )),
                              const SizedBox(height: 15),
                              Obx(() => CheckboxListTile(
                                title: const Text('Featured Product'),
                                value: isFeatured.value,
                                onChanged: (val) => isFeatured.value = val ?? false,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Product Images', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey),
                                    SizedBox(height: 10),
                                    Text('Click to upload images', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Logic to save product
                            Get.back();
                            Get.snackbar('Success', 'Product saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(product == null ? 'PUBLISH PRODUCT' : 'UPDATE PRODUCT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}
