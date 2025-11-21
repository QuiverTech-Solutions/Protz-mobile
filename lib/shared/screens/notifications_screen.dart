import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../customer/core/app_export.dart';
import '../widgets/notification_order_widget.dart';
import '../providers/api_service_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<NotificationData> _allNotifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationData> get _unreadNotifications =>
      _allNotifications.where((notification) => !notification.isRead).toList();

  int get _unreadCount => _unreadNotifications.length;

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final api = ref.read(apiServiceProvider);
    final res = await api.getNotifications();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res.success && res.data != null) {
          _allNotifications
            ..clear()
            ..addAll(res.data!.map(_mapNotification));
        } else {
          _error = res.message ?? 'Failed to load notifications';
        }
      });
    }
  }

  NotificationData _mapNotification(Map<String, dynamic> json) {
    return NotificationData(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? 'Notification').toString(),
      date: (json['created_at'] ?? json['date'] ?? '').toString(),
      orderNumber: (json['order_number'] ?? json['request_id'] ?? '').toString(),
      description: (json['description'] ?? json['message'] ?? '').toString(),
      fromLocation: (json['from_location'] ?? '').toString(),
      toLocation: (json['to_location'] ?? '').toString(),
      serviceName: (json['service_name'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      isRead: json['is_read'] == true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _isLoading
                      ? Center(child: const CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : _buildNotificationsList(_allNotifications),
                  _isLoading
                      ? Center(child: const CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : _buildNotificationsList(_unreadNotifications),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(8.h),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.h,
                color: appTheme.gray_900,
              ),
            ),
          ),
          SizedBox(width: 8.h),
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.gray_900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your notifications',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
              color: appTheme.light_blue_900,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: appTheme.gray_100,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: appTheme.light_blue_900,
              indicatorWeight: 2,
              labelColor: appTheme.light_blue_900,
              unselectedLabelColor: appTheme.blue_gray_400,
              labelStyle: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(text: 'All'),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Unread'),
                      if (_unreadCount > 0) ...[
                        SizedBox(width: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.h,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.red_500,
                            borderRadius: BorderRadius.circular(12.h),
                          ),
                          child: Text(
                            _unreadCount > 9 ? '9+' : _unreadCount.toString(),
                            style: TextStyle(
                              fontSize: 12.fSize,
                              fontWeight: FontWeight.w500,
                              color: appTheme.white_A700,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildNotificationsList(List<NotificationData> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64.h,
              color: appTheme.blue_gray_400,
            ),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.w500,
                color: appTheme.blue_gray_400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'When you have notifications, they\'ll appear here',
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blue_gray_400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.h),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationOrderWidget(
          notification: notification,
          onTap: () async {
            if (!notification.isRead) {
              final api = ref.read(apiServiceProvider);
              final res = await api.markNotificationRead(notification.id);
              if (res.success) {
                setState(() {
                  notification.isRead = true;
                });
              }
            }
          },
        );
      },
    );
  }
}

class NotificationData {
  final String id;
  final String type;
  final String date;
  final String orderNumber;
  final String description;
  final String fromLocation;
  final String toLocation;
  final String serviceName;
  final String price;
  bool isRead;

  NotificationData({
    required this.id,
    required this.type,
    required this.date,
    required this.orderNumber,
    required this.description,
    required this.fromLocation,
    required this.toLocation,
    required this.serviceName,
    required this.price,
    this.isRead = false,
  });
}