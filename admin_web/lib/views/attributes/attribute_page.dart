import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';

class AttributePage extends StatelessWidget {
  const AttributePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quản lý thuộc tính sản phẩm', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Thêm thuộc tính')),
            ],
          ),
          const SizedBox(height: 20),
          const Expanded(child: Card(child: Center(child: Text('Danh sách thuộc tính (Màu sắc, Kích thước...)')))),
        ],
      ),
    );
  }
}
