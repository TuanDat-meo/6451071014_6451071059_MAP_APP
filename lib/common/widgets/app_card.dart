import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Card widget tái sử dụng với shadow và border radius nhất quán
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final double elevation;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.color,
    this.onTap,
    this.elevation = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: 12),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBrown.withOpacity(0.06),
              blurRadius: 8 * elevation,
              offset: Offset(0, 2 * elevation),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
