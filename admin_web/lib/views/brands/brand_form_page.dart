import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/brand_controller.dart';
import '../../data/models/brand_model.dart';
import '../layout/admin_layout.dart';

class BrandFormPage extends StatelessWidget {
  final BrandModel? brand;
  const BrandFormPage({super.key, this.brand});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandController>();
    final nameController = TextEditingController(text: brand?.name);
    final imageUrl = (brand?.image ?? '').obs;

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
              Text(
                brand == null ? 'Add New Brand' : 'Edit Brand',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Brand Name'),
                      TextField(
                        controller: nameController,
                        decoration: _buildInputDecoration('Enter brand name (e.g., Nike, Puma)'),
                      ),
                      const SizedBox(height: 25),
                      _buildLabel('Brand Logo / Image'),
                      Obx(() => Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: imageUrl.value.isEmpty
                            ? InkWell(
                                onTap: () {
                                  // Image picker logic here
                                  imageUrl.value = 'https://via.placeholder.com/150'; // dummy
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
                                    SizedBox(height: 10),
                                    Text('Click to upload brand logo', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  Center(child: Image.network(imageUrl.value, fit: BoxFit.contain)),
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () => imageUrl.value = '',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      )),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Save logic
                            Get.back();
                            Get.snackbar('Success', 'Brand saved successfully', 
                                backgroundColor: Colors.green, colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(brand == null ? 'CREATE BRAND' : 'UPDATE BRAND'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
