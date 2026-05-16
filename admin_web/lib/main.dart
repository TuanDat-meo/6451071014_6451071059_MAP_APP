import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Khởi tạo AuthController
  final authController = Get.put(AuthController(), permanent: true);

  runApp(const AdminWebMain());

  // 3. TỰ ĐỘNG TẠO ADMIN (Chỉ chạy sau khi app đã khởi động)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    print("--- ĐANG THIẾT LẬP TÀI KHOẢN ADMIN ---");
    await authController.createFirstAdmin();
  });
}

class AdminWebMain extends StatelessWidget {
  const AdminWebMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        useMaterial3: true,
        fontFamily: 'Roboto',
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: Color(0xFF2D3748), width: 2.0),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF1976D2);
            }
            return null;
          }),
        ),
      ),

    );
  }
}
