import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Hình ảnh sản phẩm tái sử dụng với fallback khi lỗi
class AppProductImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const AppProductImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imagePath.startsWith('assets/')
          ? Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            )
          : Image.network(
              imagePath,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingPlaceholder();
              },
            ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.tapioca.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Center(
        child: Icon(Icons.local_cafe, color: AppColors.milkTea, size: 40),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.tapioca.withOpacity(0.2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.milkTea),
          ),
        ),
      ),
    );
  }
}
