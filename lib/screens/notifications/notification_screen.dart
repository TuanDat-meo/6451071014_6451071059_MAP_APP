import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/theme/app_theme.dart';
import '../../data/models/notification_model.dart';
import '../../data/services/firebase_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

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
          TextButton(
            onPressed: () => firebaseService.markAllNotificationsAsRead(),
            child: const Text('Đọc tất cả',
                style: TextStyle(color: AppColors.milkTea, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: firebaseService.getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.milkTea));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationItem(context, notifications[index], firebaseService);
            },
          );
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
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppColors.tapioca.withOpacity(0.3), shape: BoxShape.circle,
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

  Widget _buildNotificationItem(BuildContext context, NotificationModel notification, FirebaseService service) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => service.deleteNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppColors.rose,
        child: const Icon(Icons.delete_rounded, color: AppColors.white),
      ),
      child: GestureDetector(
        onTap: () => service.markNotificationAsRead(notification.id),
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
              BoxShadow(color: AppColors.darkBrown.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(notification.iconData, color: _getTypeColor(notification.type), size: 22),
              ),
              const SizedBox(width: 12),
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
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: AppColors.milkTea, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notification.body,
                        style: TextStyle(fontSize: 13, color: AppColors.grey, height: 1.4),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(_getTimeAgo(notification.createdAt),
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
      case 'order': return AppColors.milkTea;
      case 'promo': return AppColors.matcha;
      default: return AppColors.taro;
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
