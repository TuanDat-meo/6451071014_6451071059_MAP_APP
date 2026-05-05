import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget hiển thị trạng thái rỗng (không có dữ liệu) tái sử dụng
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container với background mờ
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.tapioca.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.milkTea,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

            // Action button
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.milkTea,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText!,
                  style: AppTextStyles.button.copyWith(fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
