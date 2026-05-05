import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';
import '../../common/theme/app_theme.dart';
import '../../data/services/firebase_service.dart';
import '../auth/auth_screen.dart';
import '../shipping_address/shipping_address_screen.dart';
import '../notifications/notification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseService().userId;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text(
          'Hồ sơ của tôi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
            fontFamily: AppTextStyles.bodyFont,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header: Avatar & Info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkBrown.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.milkTea, AppColors.lightBrown],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.milkTea.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person, size: 50, color: AppColors.white),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: FirebaseService().getUserInfo(userId),
                    builder: (context, snapshot) {
                      final name = snapshot.data?['name'] ?? 'Khách hàng thân thiết';
                      final email = snapshot.data?['email'] ?? 'Chưa đăng nhập';
                      return Column(
                        children: [
                          Text(name, style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown, fontFamily: AppTextStyles.bodyFont)),
                          const SizedBox(height: 6),
                          Text(email, style: TextStyle(
                            color: AppColors.grey, fontSize: 14, fontFamily: AppTextStyles.bodyFont)),
                        ],
                      );
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Đơn hàng
                  _buildSectionTitle('Đơn hàng & Thanh toán'),
                  const SizedBox(height: 8),
                  _buildOptionTile(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Đơn hàng của tôi',
                    subtitle: 'Xem lịch sử và trạng thái đơn hàng',
                    onTap: () => Get.find<CartController>().changeTab(3),
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.favorite_border_rounded,
                    title: 'Danh sách yêu thích',
                    subtitle: 'Các món bạn đã lưu',
                    onTap: () => Get.find<CartController>().changeTab(1),
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Địa chỉ giao hàng',
                    subtitle: 'Quản lý địa chỉ nhận hàng',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const ShippingAddressScreen(),
                      ));
                    },
                  ),

                  const SizedBox(height: 20),

                  // Section: Tài khoản
                  _buildSectionTitle('Tài khoản & Cài đặt'),
                  const SizedBox(height: 8),
                  _buildOptionTile(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Thông báo',
                    subtitle: 'Quản lý cài đặt thông báo',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ));
                    },
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: 'Trung tâm hỗ trợ',
                    subtitle: 'Hỏi đáp và liên hệ',
                    onTap: () {
                      Get.snackbar('Thông báo', 'Tính năng đang phát triển',
                        backgroundColor: AppColors.milkTea, colorText: AppColors.white);
                    },
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'Về Boba House',
                    subtitle: 'Phiên bản 1.0.0',
                    onTap: () {
                      Get.snackbar('Boba House', 'Phiên bản 1.0.0 - Nhóm 6451071014 & 6451071059',
                        backgroundColor: AppColors.milkTea, colorText: AppColors.white);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Đăng xuất'),
                            content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          Get.snackbar('Thành công', 'Đã đăng xuất',
                            backgroundColor: Colors.green, colorText: AppColors.white);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const AuthScreen()),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, color: AppColors.rose),
                      label: const Text(
                        'ĐĂNG XUẤT',
                        style: TextStyle(
                          color: AppColors.rose,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTextStyles.bodyFont,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.rose, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.darkBrown,
        fontFamily: AppTextStyles.bodyFont,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBrown.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.tapioca.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.milkTea, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: AppTextStyles.bodyFont,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey,
            fontFamily: AppTextStyles.bodyFont,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}
