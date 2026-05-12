import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard('Tổng đơn hàng', '150', Colors.blue),
              _buildStatCard('Doanh thu', '12.000.000đ', Colors.green),
              _buildStatCard('Khách hàng', '1,200', Colors.orange),
              _buildStatCard('Mã giảm giá', '5', Colors.red),
            ],
          ),
          const SizedBox(height: 30),
          const Expanded(
            child: Card(
              child: Center(child: Text('Biểu đồ thống kê doanh thu (Placeholder)')),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 10),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
