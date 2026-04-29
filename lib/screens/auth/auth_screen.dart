import 'package:flutter/material.dart';
import '../../common/theme/app_theme.dart';
import '../../common/widgets/app_button.dart';
import '../../data/services/auth_service.dart';
import '../home/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {
      _errorMessage = null; // Clear error when switching tabs
    }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _loginEmailController.text.trim();
      final password = _loginPasswordController.text;

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Vui lòng nhập email và mật khẩu';
          _isLoading = false;
        });
        return;
      }

      final error = await _authService.login(email, password);
      
      setState(() {
        _isLoading = false;
        if (error != null) {
          _errorMessage = error;
        } else {
          // Login successful - navigate to home
          _errorMessage = null;
          _showSuccessSnackbar('Đăng nhập thành công!');
          
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi: $e';
      });
    }
  }

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final name = _registerNameController.text.trim();
      final email = _registerEmailController.text.trim();
      final password = _registerPasswordController.text;
      final confirmPassword = _registerConfirmPasswordController.text;

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Vui lòng điền đầy đủ thông tin';
          _isLoading = false;
        });
        return;
      }

      final error = await _authService.register(name, email, password, confirmPassword);
      
      setState(() {
        _isLoading = false;
        if (error != null) {
          _errorMessage = error;
        } else {
          // Registration successful
          _errorMessage = null;
          _showSuccessSnackbar('Tạo tài khoản thành công! Vui lòng đợi xác minh từ quản trị viên.');
          // Clear form
          _registerNameController.clear();
          _registerEmailController.clear();
          _registerPasswordController.clear();
          _registerConfirmPasswordController.clear();
          // Switch to login tab
          _tabController.animateTo(0);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi: $e';
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // Decorative background blobs
          Positioned(
            top: -60,
            right: -60,
            child: _DecorativeCircle(
              size: 220,
              color: AppColors.milkTea.withOpacity(0.12),
            ),
          ),
          Positioned(
            top: 80,
            left: -40,
            child: _DecorativeCircle(
              size: 140,
              color: AppColors.rose.withOpacity(0.1),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('🧋', style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 10),
                          Text(
                            'BOBA HOUSE',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.mediumBrown,
                              fontSize: 13,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _tabController.index == 0
                            ? 'Chào mừng\ntrở lại! 👋'
                            : 'Tạo tài khoản\nmới ✨',
                        style: AppTextStyles.display.copyWith(fontSize: 34),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _tabController.index == 0
                            ? 'Đăng nhập để tiếp tục đặt hàng yêu thích'
                            : 'Đăng ký để nhận ưu đãi thành viên mới',
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Tab bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _CustomTabBar(controller: _tabController),
                ),

                const SizedBox(height: 28),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _LoginTab(
                        emailController: _loginEmailController,
                        passwordController: _loginPasswordController,
                        obscurePassword: _obscurePassword,
                        onTogglePassword: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        isLoading: _isLoading,
                        onSubmit: _handleLogin,
                        onSwitchToRegister: () => _tabController.animateTo(1),
                        errorMessage: _errorMessage,
                      ),
                      _RegisterTab(
                        nameController: _registerNameController,
                        emailController: _registerEmailController,
                        passwordController: _registerPasswordController,
                        confirmPasswordController: _registerConfirmPasswordController,
                        obscurePassword: _obscurePassword,
                        obscureConfirmPassword: _obscureConfirmPassword,
                        onTogglePassword: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        onToggleConfirmPassword: () => setState(
                            () => _obscureConfirmPassword = !_obscureConfirmPassword),
                        isLoading: _isLoading,
                        onSubmit: _handleRegister,
                        onSwitchToLogin: () => _tabController.animateTo(0),
                        errorMessage: _errorMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Custom Tab Bar ────────────────────────────────────────────────────────────

class _CustomTabBar extends StatelessWidget {
  final TabController controller;

  const _CustomTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.tapioca.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.darkBrown,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBrown.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
        labelStyle: AppTextStyles.button.copyWith(fontSize: 14),
        unselectedLabelStyle:
            AppTextStyles.body.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.grey,
        tabs: const [
          Tab(text: 'Đăng nhập'),
          Tab(text: 'Đăng ký'),
        ],
      ),
    );
  }
}

// ─── Login Tab ─────────────────────────────────────────────────────────────────

class _LoginTab extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onSwitchToRegister;
  final String? errorMessage;

  const _LoginTab({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.isLoading,
    required this.onSubmit,
    required this.onSwitchToRegister,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error message
          if (errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          _AppTextField(
            controller: emailController,
            label: 'Email',
            hint: 'your@email.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _AppTextField(
            controller: passwordController,
            label: 'Mật khẩu',
            hint: '••••••••',
            obscureText: obscurePassword,
            prefixIcon: Icons.lock_outline_rounded,
            suffixIcon: obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: onTogglePassword,
          ),
          const SizedBox(height: 12),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Quên mật khẩu?',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.mediumBrown,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Đăng nhập',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
          const SizedBox(height: 20),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.tapioca, thickness: 1.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('hoặc', style: AppTextStyles.label),
              ),
              Expanded(child: Divider(color: AppColors.tapioca, thickness: 1.5)),
            ],
          ),
          const SizedBox(height: 20),

          // Social login
          _SocialButton(
            icon: '🍎',
            label: 'Tiếp tục với Apple',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _SocialButton(
            icon: '🌐',
            label: 'Tiếp tục với Google',
            onTap: () {},
          ),
          const SizedBox(height: 28),

          Center(
            child: GestureDetector(
              onTap: onSwitchToRegister,
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(fontSize: 14),
                  children: [
                    const TextSpan(text: 'Chưa có tài khoản? '),
                    TextSpan(
                      text: 'Đăng ký ngay',
                      style: TextStyle(
                        color: AppColors.mediumBrown,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Register Tab ──────────────────────────────────────────────────────────────

class _RegisterTab extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onSwitchToLogin;
  final String? errorMessage;

  const _RegisterTab({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.isLoading,
    required this.onSubmit,
    required this.onSwitchToLogin,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        children: [
          // Error message
          if (errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          _AppTextField(
            controller: nameController,
            label: 'Họ và tên',
            hint: 'Nguyễn Văn A',
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          _AppTextField(
            controller: emailController,
            label: 'Email',
            hint: 'your@email.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _AppTextField(
            controller: passwordController,
            label: 'Mật khẩu',
            hint: 'Tối thiểu 8 ký tự',
            obscureText: obscurePassword,
            prefixIcon: Icons.lock_outline_rounded,
            suffixIcon: obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: onTogglePassword,
          ),
          const SizedBox(height: 16),
          _AppTextField(
            controller: confirmPasswordController,
            label: 'Xác nhận mật khẩu',
            hint: '••••••••',
            obscureText: obscureConfirmPassword,
            prefixIcon: Icons.lock_outline_rounded,
            suffixIcon: obscureConfirmPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: onToggleConfirmPassword,
          ),
          const SizedBox(height: 8),

          // Terms
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (_) {},
                activeColor: AppColors.darkBrown,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.body.copyWith(fontSize: 12),
                    children: [
                      const TextSpan(text: 'Tôi đồng ý với '),
                      TextSpan(
                        text: 'Điều khoản sử dụng',
                        style: TextStyle(
                          color: AppColors.mediumBrown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' và '),
                      TextSpan(
                        text: 'Chính sách bảo mật',
                        style: TextStyle(
                          color: AppColors.mediumBrown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Tạo tài khoản',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
          const SizedBox(height: 24),

          GestureDetector(
            onTap: onSwitchToLogin,
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.body.copyWith(fontSize: 14),
                children: [
                  const TextSpan(text: 'Đã có tài khoản? '),
                  TextSpan(
                    text: 'Đăng nhập',
                    style: TextStyle(
                      color: AppColors.mediumBrown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ────────────────────────────────────────────────────────────

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.body.copyWith(color: AppColors.darkBrown, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.grey, size: 20)
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: AppColors.grey, size: 20),
              )
            : null,
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.tapioca, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorativeCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
