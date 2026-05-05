import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'package:flutter/services.dart';
import 'package:quan_ly_quan_ts/data/services/firebase_service.dart'; // Import service
import 'package:quan_ly_quan_ts/screens/onboarding/onboarding_screen.dart'; 
import 'common/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'controller/cart_controller.dart';
import 'controller/wishlist_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo các Controller của GetX
  Get.put(CartController());
  Get.put(WishlistController());

  // Khởi tạo định dạng ngày tháng/tiền tệ cho tiếng Việt
  await initializeDateFormatting('vi_VN', null);

  // Seed data sẽ được gọi sau khi đăng nhập (auth_screen.dart)

  // Cấu hình thanh trạng thái (StatusBar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BobaApp());
}

class BobaApp extends StatelessWidget {
  const BobaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Boba House',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}
