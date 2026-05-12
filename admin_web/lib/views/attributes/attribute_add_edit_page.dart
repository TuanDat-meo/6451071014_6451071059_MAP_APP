import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attribute_controller.dart';
import '../../data/models/attribute_model.dart';
import '../layout/admin_layout.dart';

class AttributeAddEditPage extends StatelessWidget {
  final AttributeModel? attribute;
  const AttributeAddEditPage({super.key, this.attribute});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttributeController>();
    final nameController = TextEditingController(text: attribute?.name);
    final valuesController = TextEditingController(text: attribute?.values.join(', '));

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
              Text(
                attribute == null ? 'Add New Attribute' : 'Edit Attribute',
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
                      _buildLabel('Attribute Name (e.g., Color, Size)'),
                      TextField(
                        controller: nameController,
                        decoration: _buildInputDecoration('Enter attribute name'),
                      ),
                      const SizedBox(height: 25),
                      _buildLabel('Values (Separated by commas)'),
                      TextField(
                        controller: valuesController,
                        decoration: _buildInputDecoration('e.g., Red, Blue, Green'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tip: Use commas to separate different values for this attribute.',
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Logic to save
                            Get.back();
                            Get.snackbar('Success', 'Attribute saved successfully', 
                                backgroundColor: Colors.green, colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(attribute == null ? 'CREATE ATTRIBUTE' : 'UPDATE ATTRIBUTE'),
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
