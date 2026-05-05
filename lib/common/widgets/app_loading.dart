import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Loading indicator tái sử dụng với màu sắc nhất quán
class AppLoading extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const AppLoading({
    super.key,
    this.size = 40,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.milkTea,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-screen loading overlay
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const AppLoading(
              message: 'Đang xử lý...',
            ),
          ),
      ],
    );
  }
}
