import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_export.dart';
import '../widgets/notification_order_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample notification data
  final List<NotificationData> _allNotifications = [
    NotificationData(
      id: '1',
      type: 'Order confirmed',
      date: '20/09/2025',
      orderNumber: '#12345',
      description: 'Order number #12345 has been confirmed and the tow truck is on the way to pickup your vehicle.',
      fromLocation: 'Accra Newtown',
      toLocation: 'Mr. Krabbs Mechanic Shop',
      serviceName: 'Ofosu Towing Services',
      price: 'GHS 400.00',
      isRead: false,
    ),
    NotificationData(
      id: '2',
      type: 'Order confirmed',
      date: '24/09/2025',
      orderNumber: '#12345',
      description: 'Order number #12345 has been confirmed and the water is on its way to you.',
      fromLocation: 'Delivery to',
      toLocation: 'No.1 Ashongman Estates',
      serviceName: 'Mr. Ansah & Sons',
      price: 'GHS 200.00',
      isRead: false,
    ),
    NotificationData(
      id: '3',
      type: 'Order confirmed',
      date: '20/09/2025',
      orderNumber: '#12345',
      description: 'Order number #12345 has been confirmed and the tow truck is on the way to pickup your vehicle.',
      fromLocation: 'Accra Newtown',
      toLocation: 'Mr. Krabbs Mechanic Shop',
      serviceName: 'Ofosu Towing Services',
      price: 'GHS 400.00',
      isRead: true,
    ),
    NotificationData(
      id: '4',
      type: 'Order confirmed',
      date: '24/09/2025',
      orderNumber: '#12345',
      description: 'Order number #12345 has been confirmed and the water is on its way to you.',
      fromLocation: 'Delivery to',
      toLocation: 'No.1 Ashongman Estates',
      serviceName: 'Mr. Ansah & Sons',
      price: 'GHS 200.00',
      isRead: true,
    ),
    NotificationData(
      id: '5',
      type: 'Order confirmed',
      date: '20/09/2025',
      orderNumber: '#12345',
      description: 'Order number #12345 has been confirmed and the tow truck is on the way to pickup your vehicle.',
      fromLocation: 'Accra Newtown',
      toLocation: 'Mr. Krabbs Mechanic Shop',
      serviceName: 'Ofosu Towing Services',
      price: 'GHS 400.00',
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationData> get _unreadNotifications =>
      _allNotifications.where((notification) => !notification.isRead).toList();

  int get _unreadCount => _unreadNotifications.length;

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
                  _buildNotificationsList(_allNotifications),
                  _buildNotificationsList(_unreadNotifications),
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
          onTap: () {
            // Mark as read when tapped
            if (!notification.isRead) {
              setState(() {
                notification.isRead = true;
              });
            }
            // Navigate to order details or tracking screen
            // context.push('/customer/order-details/${notification.orderNumber}');
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