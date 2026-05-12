import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quản lý thương hiệu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Thêm thương hiệu')),
            ],
          ),
          const SizedBox(height: 20),
          const Expanded(child: Card(child: Center(child: Text('Danh sách thương hiệu')))),
        ],
      ),
    );
  }
}
