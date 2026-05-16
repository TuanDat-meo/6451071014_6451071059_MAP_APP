import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            height: 45,
            width: 400,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8ECEF)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm hệ thống...',
                hintStyle: TextStyle(color: Color(0xFFA0AAB6), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFFA0AAB6), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language, color: Color(0xFF718096), size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF718096), size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF718096), size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Color(0xFF718096), size: 22),
          onPressed: () {},
        ),
        const SizedBox(width: 15),
        
        // Tích hợp Menu Popup khi bấm vào User
        PopupMenuButton<String>(
          offset: const Offset(0, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          tooltip: 'Tùy chọn người dùng',
          onSelected: (value) {
            if (value == 'logout') {
              Get.offAllNamed(AppRoutes.login);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'profile',
              child: ListTile(
                dense: true,
                leading: Icon(Icons.person_outline_rounded, color: Color(0xFF2D3748), size: 20),
                title: Text('Hồ sơ cá nhân', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'settings',
              child: ListTile(
                dense: true,
                leading: Icon(Icons.settings_applications_outlined, color: Color(0xFF2D3748), size: 20),
                title: Text('Cài đặt tài khoản', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
            const PopupMenuDivider(height: 1),
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                dense: true,
                leading: Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                title: Text('Đăng xuất', style: TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'User Admin',
                      style: TextStyle(color: Color(0xFF2D3748), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Quản trị viên',
                      style: TextStyle(color: Color(0xFFD4A96A), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4A96A),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'UA',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF718096)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
