import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'package:flutter/services.dart';
import 'common/theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    return MaterialApp(
      title: 'Boba House',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}
