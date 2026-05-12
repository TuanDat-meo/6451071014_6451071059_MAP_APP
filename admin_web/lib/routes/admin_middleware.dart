import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'app_routes.dart';

class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Tìm AuthController đã được khởi tạo
    final authController = Get.find<AuthController>();
    
    // Nếu không phải admin thì bắt quay về trang login
    if (authController.isAdmin.value == false) {
      return const RouteSettings(name: AppRoutes.login);
    }
    
    return null;
  }
}
