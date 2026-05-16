import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFF2C1A0E), // Sẫm màu Dark Brown từ theme di động
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A96A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_drink_rounded, color: Color(0xFFD4A96A), size: 26),
                ),
                const SizedBox(width: 12),
                const Text(
                  'BOBA HOUSE',
                  style: TextStyle(
                    color: Color(0xFFF5ECD7), // Màu Kem
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                    fontFamily: 'Playfair Display',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _buildSectionHeader('QUẢN LÝ CHUNG'),
                _buildMenuItem(Icons.grid_view_rounded, 'Bảng điều khiển', AppRoutes.dashboard),
                _buildMenuItem(Icons.category_outlined, 'Danh mục sản phẩm', AppRoutes.categories),
                _buildMenuItem(Icons.info_outline_rounded, 'Danh mục thuộc tính', AppRoutes.attributes),
                _buildMenuItem(Icons.branding_watermark_outlined, 'Danh mục thương hiệu', AppRoutes.brands),
                _buildMenuItem(Icons.card_giftcard_rounded, 'Danh mục mã giảm giá', AppRoutes.coupons),
                _buildMenuItem(Icons.inventory_2_outlined, 'Sản phẩm', AppRoutes.products),
                
                const SizedBox(height: 25),
                _buildSectionHeader('KINH DOANH'),
                _buildMenuItem(Icons.shopping_cart_outlined, 'Đơn hàng', AppRoutes.orders),
                _buildMenuItem(Icons.people_outline_rounded, 'Khách hàng', AppRoutes.customers),
                
                const SizedBox(height: 40),
                _buildMenuItem(Icons.logout_rounded, 'Đăng xuất', AppRoutes.login),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15, top: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF8C7460),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    final isSelected = Get.currentRoute == route;
    const Color milkTeaColor = Color(0xFFD4A96A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => Get.toNamed(route),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? milkTeaColor.withOpacity(0.15) : Colors.transparent,
            border: isSelected ? Border.all(color: milkTeaColor.withOpacity(0.3)) : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? milkTeaColor : const Color(0xFFB8A090),
                size: 21,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFF5ECD7) : const Color(0xFFC4B0A1),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: milkTeaColor,
                    boxShadow: [
                      BoxShadow(color: milkTeaColor, blurRadius: 8, spreadRadius: 1)
                    ]
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
