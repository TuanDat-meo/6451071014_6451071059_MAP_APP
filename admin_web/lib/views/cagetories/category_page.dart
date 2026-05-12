import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quản lý danh mục (Cagetories)', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Expanded(child: Card(child: Center(child: Text('Danh sách danh mục sản phẩm')))),
        ],
      ),
    );
  }
}
