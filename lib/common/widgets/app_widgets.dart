import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Badge hiển thị số lượng (dùng cho giỏ hàng, thông báo, v.v.)
class AppBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color? badgeColor;

  const AppBadge({
    super.key,
    required this.child,
    required this.count,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.rose,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.bodyFont,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Chip lọc (dùng cho bộ lọc trạng thái đơn hàng, danh mục sản phẩm, v.v.)
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.milkTea : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.milkTea : AppColors.tapioca,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.milkTea.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.white : AppColors.grey,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.darkGrey,
                fontFamily: AppTextStyles.bodyFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút icon tròn (dùng cho nút yêu thích, thêm giỏ hàng, v.v.)
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBrown.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.darkBrown,
          size: size * 0.5,
        ),
      ),
    );
  }
}

/// Hiển thị giá tiền với định dạng Việt Nam
class AppPriceText extends StatelessWidget {
  final double price;
  final double fontSize;
  final Color? color;
  final bool isBold;
  final String? prefix;

  const AppPriceText({
    super.key,
    required this.price,
    this.fontSize = 14,
    this.color,
    this.isBold = true,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = _formatCurrency(price);
    return Text(
      prefix != null ? '$prefix$formatted' : formatted,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color ?? AppColors.milkTea,
        fontFamily: AppTextStyles.bodyFont,
      ),
    );
  }

  String _formatCurrency(double amount) {
    final intAmount = amount.toInt();
    final str = intAmount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return '${buffer.toString().split('').reversed.join()} đ';
  }
}

/// Separator ngang với label ở giữa (dùng cho "hoặc", "---", v.v.)
class AppDivider extends StatelessWidget {
  final String? label;

  const AppDivider({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Divider(color: AppColors.tapioca.withOpacity(0.5), thickness: 1);
    }

    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.tapioca.withOpacity(0.5), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label!,
            style: AppTextStyles.label.copyWith(fontSize: 12),
          ),
        ),
        Expanded(child: Divider(color: AppColors.tapioca.withOpacity(0.5), thickness: 1)),
      ],
    );
  }
}
