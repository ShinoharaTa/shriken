import 'package:flutter/material.dart';
import 'package:shriken/components/app_drawer.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: "新しいリプライ",
      content: "@alice があなたの投稿にリプライしました",
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      isRead: false,
      type: NotificationType.reply,
    ),
    NotificationItem(
      title: "いいね",
      content: "@bob があなたの投稿にいいねしました",
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      isRead: false,
      type: NotificationType.like,
    ),
    NotificationItem(
      title: "新しいフォロワー",
      content: "@charlie があなたをフォローしました",
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
      isRead: true,
      type: NotificationType.follow,
    ),
    NotificationItem(
      title: "リポスト",
      content: "@dave があなたの投稿をリポストしました",
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      isRead: true,
      type: NotificationType.repost,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('通知'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'すべて既読',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      drawer: AppDrawer(), // ハンバーガーメニューを追加
      body: Column(
        children: [
          // ヘッダー統計
          if (_notifications.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '通知センター',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          unreadCount > 0 
                              ? '$unreadCount件の未読通知があります'
                              : 'すべて既読です',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // 通知リスト
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationTile(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            '通知はありません',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: notification.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead 
              ? Colors.transparent
              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: notification.isRead ? 0 : 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: notification.isRead 
              ? null
              : LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.02),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: notification.isRead 
                ? Colors.grey[300] 
                : _getNotificationColor(notification.type),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: notification.isRead 
                  ? Colors.grey[600] 
                  : Colors.white,
              size: 20,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead 
                        ? FontWeight.w500 
                        : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                notification.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () => _markAsRead(notification),
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Colors.red[400]!;
      case NotificationType.reply:
        return Colors.blue[400]!;
      case NotificationType.repost:
        return Colors.green[400]!;
      case NotificationType.follow:
        return Theme.of(context).colorScheme.secondary;
      case NotificationType.mention:
        return Colors.orange[400]!;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.reply:
        return Icons.reply;
      case NotificationType.repost:
        return Icons.repeat;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.mention:
        return Icons.alternate_email;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else {
      return '${difference.inDays}日前';
    }
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }
}

class NotificationItem {
  final String title;
  final String content;
  final DateTime timestamp;
  bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });
}

enum NotificationType {
  like,
  reply,
  repost,
  follow,
  mention,
}
