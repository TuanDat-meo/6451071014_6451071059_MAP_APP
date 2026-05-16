import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C1A0E), // Dark Brown base
              Color(0xFF4A2F1D), // Warm chocolate accent
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 420,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 55),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Trà Sữa
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A96A).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.local_drink_rounded,
                      size: 45,
                      color: Color(0xFFD4A96A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'BOBA HOUSE ADMIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: Color(0xFF2C1A0E),
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hệ thống quản lý cửa hàng trà sữa',
                    style: TextStyle(
                      color: Color(0xFF7D6452),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 45),
                  // Input Username
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Color(0xFF2C1A0E)),
                    decoration: InputDecoration(
                      hintText: 'Username hoặc Email',
                      hintStyle: const TextStyle(color: Color(0xFFA69284)),
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFFD4A96A)),
                      filled: true,
                      fillColor: const Color(0xFFFBF7F4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: const Color(0xFFD4A96A).withOpacity(0.1), width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Input Password
                  TextField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    style: const TextStyle(color: Color(0xFF2C1A0E)),
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      hintStyle: const TextStyle(color: Color(0xFFA69284)),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFFD4A96A)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: const Color(0xFFA69284),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFBF7F4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: const Color(0xFFD4A96A).withOpacity(0.1), width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 45),
                  // Nút đăng nhập
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authController.isLoading.value 
                        ? null 
                        : () => authController.login(emailController.text, passwordController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C1A0E), // Dark brown btn
                        foregroundColor: const Color(0xFFF5ECD7), // Cream text
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: authController.isLoading.value
                        ? const CircularProgressIndicator(color: Color(0xFFF5ECD7))
                        : const Text(
                            'ĐĂNG NHẬP HỆ THỐNG',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                    ),
                  )),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: Color(0xFF8C7460),
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
