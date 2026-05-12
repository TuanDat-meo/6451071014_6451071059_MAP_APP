import 'package:get/get.dart';
import '../views/auth/login_page.dart';
import '../views/dashboard/dashboard_page.dart';
import '../views/categories/category_page.dart';
import '../views/brands/brands_page.dart';
import '../views/products/product_list_page.dart';
import '../views/orders/orders_page.dart';
import '../views/customers/customers_page.dart';
import '../views/coupons/coupons_page.dart';
import '../views/attributes/attribute_page.dart';
import 'admin_middleware.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String categories = '/categories';
  static const String brands = '/brands';
  static const String products = '/products';
  static const String orders = '/orders';
  static const String customers = '/customers';
  static const String coupons = '/coupons';
  static const String attributes = '/attributes';

  static final routes = [
    GetPage(name: login, page: () => const LoginPage()),
    
    // Các trang dưới đây sẽ được bảo vệ bởi AdminMiddleware
    GetPage(
      name: dashboard, 
      page: () => const DashboardPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: categories, 
      page: () => const CategoryPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: brands, 
      page: () => const BrandsPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: products, 
      page: () => const ProductListPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: orders, 
      page: () => const OrdersPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: customers, 
      page: () => const CustomersPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: coupons, 
      page: () => const CouponsPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: attributes, 
      page: () => const AttributePage(),
      middlewares: [AdminMiddleware()],
    ),
  ];
}
