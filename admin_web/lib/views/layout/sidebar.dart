import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'ADMIN PANEL',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildMenuItem(Icons.dashboard, 'Dashboard', AppRoutes.dashboard),
          _buildMenuItem(Icons.category, 'Categories', AppRoutes.categories),
          _buildMenuItem(Icons.list, 'Attributes', AppRoutes.attributes),
          _buildMenuItem(Icons.branding_watermark, 'Brands', AppRoutes.brands),
          _buildMenuItem(Icons.shopping_bag, 'Products', AppRoutes.products),
          _buildMenuItem(Icons.shopping_cart, 'Orders', AppRoutes.orders),
          _buildMenuItem(Icons.people, 'Customers', AppRoutes.customers),
          _buildMenuItem(Icons.confirmation_number, 'Coupons', AppRoutes.coupons),
          const Divider(),
          _buildMenuItem(Icons.logout, 'Logout', AppRoutes.login),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Get.toNamed(route),
      selected: Get.currentRoute == route,
    );
  }
}
