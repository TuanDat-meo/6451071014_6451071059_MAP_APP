import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/theme/app_theme.dart';
import '../../data/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dữ liệu thông báo mẫu (sau này kết nối Firebase)
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Đơn hàng đã được xác nhận',
      body: 'Đơn hàng #BH001 của bạn đã được xác nhận và đang được chuẩn bị.',
      type: 'order',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      orderId: 'BH001',
    ),
    NotificationModel(
      id: '2',
      title: 'Đơn hàng đang giao',
      body: 'Đơn hàng #BH001 đang trên đường giao đến bạn. Vui lòng chú ý điện thoại.',
      type: 'order',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      orderId: 'BH001',
    ),
    NotificationModel(
      id: '3',
      title: '🎉 Giảm 20% toàn bộ menu!',
      body: 'Nhập mã BOBA20 để nhận ưu đãi giảm 20% cho đơn hàng tiếp theo. Áp dụng đến 30/05.',
      type: 'promo',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationModel(
      id: '4',
      title: 'Chào mừng bạn đến Boba House!',
      body: 'Cảm ơn bạn đã đăng ký tài khoản. Hãy khám phá thực đơn trà sữa phong phú của chúng tôi!',
      type: 'system',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: '🧋 Món mới: Oolong Sữa Tươi',
      body: 'Trà Oolong kết hợp sữa tươi thơm lừng đã có mặt tại Boba House! Thử ngay hôm nay.',
      type: 'promo',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  void _markAsRead(int index) {
    setState(() {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Thông báo',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Đọc tất cả', style: TextStyle(color: AppColors.milkTea, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(context, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.tapioca.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.milkTea),
          ),
          const SizedBox(height: 24),
          const Text('Chưa có thông báo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
          const SizedBox(height: 8),
          Text('Các thông báo mới sẽ hiển thị tại đây',
              style: TextStyle(fontSize: 14, color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, int index) {
    final notification = _notifications[index];
    final timeAgo = _getTimeAgo(notification.createdAt);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppColors.rose,
        child: const Icon(Icons.delete_rounded, color: AppColors.white),
      ),
      child: GestureDetector(
        onTap: () => _markAsRead(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? AppColors.white : AppColors.milkTea.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: notification.isRead
                ? null
                : Border.all(color: AppColors.milkTea.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBrown.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(notification.iconData, color: _getTypeColor(notification.type), size: 22),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                                color: AppColors.darkBrown,
                              )),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.milkTea,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notification.body,
                        style: TextStyle(fontSize: 13, color: AppColors.grey, height: 1.4),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(timeAgo,
                        style: TextStyle(fontSize: 11, color: AppColors.grey.withOpacity(0.7))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'order':
        return AppColors.milkTea;
      case 'promo':
        return AppColors.matcha;
      default:
        return AppColors.taro;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
