import 'package:flutter/material.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết khách hàng')),
      body: const Center(child: Text('Thông tin chi tiết, lịch sử mua hàng...')),
    );
  }
}
