import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/pages.dart';
import '../../customer/core/app_export.dart';
import '../../customer/core/utils/size_utils.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../service_provider/widgets/provider_status_toggle.dart';
import '../../service_provider/widgets/sp_bottom_nav_bar.dart';
import '../../service_provider/core/utils/nav_helper.dart';
import '../providers/api_service_provider.dart';
class ChatInboxScreen extends ConsumerStatefulWidget {
  final bool isProvider;

  const ChatInboxScreen({super.key, this.isProvider = false});

  @override
  ConsumerState<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends ConsumerState<ChatInboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  int _selectedBottomNavIndex = 2; // Chats tab is selected
  bool _isLoading = true;
  String? _error;
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
    _loadConversations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                _buildTabBar(),
                Expanded(
                  child: _buildChatList(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: widget.isProvider
              ? SPBottomNavBar(
                  currentIndex: 2,
                  items: const [
                    SPBottomNavItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.assignment_outlined),
                      activeIcon: Icon(Icons.assignment),
                      label: 'Requests',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.chat_bubble_outline),
                      activeIcon: Icon(Icons.chat_bubble),
                      label: 'Chats',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.account_balance_wallet_outlined),
                      activeIcon: Icon(Icons.account_balance_wallet),
                      label: 'Finances',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: 'Account',
                    ),
                  ],
                  onItemSelected: (index) {
                    ProviderNav.goToIndex(context, index);
                  },
                )
              : CustomBottomNavBar(
                  currentIndex: _selectedBottomNavIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedBottomNavIndex = index;
                    });
                    switch (index) {
                      case 0:
                        context.go(AppRoutes.customerHome);
                        break;
                      case 1:
                        context.push(AppRoutes.history);
                        break;
                      case 2:
                        break;
                      case 3:
                        context.push(AppRoutes.accountSettings);
                        break;
                    }
                  },
                ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back arrow
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            
            // Title
            const Text(
              'Chat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const Spacer(),
            
            // Notification bell
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // Handle notification tap
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black87,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                // Red notification dot
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Refresh icon
            IconButton(
              onPressed: () {
                _loadConversations();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.black87,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            if (widget.isProvider) ...[
              const SizedBox(width: 8),
              ProviderStatusToggle(
                isOnline: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value ? 'Status: Online' : 'Status: Offline'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your inbox',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildTabItem('All', 0, isSelected: _selectedTabIndex == 0),
              SizedBox(width: 24.h),
              _buildTabItem('Unread', 1, hasNotification: true, isSelected: _selectedTabIndex == 1),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index, {bool isSelected = false, bool hasNotification = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
        _tabController.animateTo(index);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(
                    color: Color(0xFF1B5A96),
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF1B5A96) : const Color(0xFF6B7280),
              ),
            ),
            if (hasNotification) ...[
              SizedBox(width: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '99+',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Sample chat data
  final List<ChatItem> _allChats = [
    ChatItem(
      senderName: 'Mr Ansah & Sons',
      messagePreview: 'Hello, are you on your way now? I\'ve been wai...',
      timestamp: '11:41 AM',
      isRead: true,
      isSent: true,
      isActive: false,
      avatarUrl: '',
    ),
    ChatItem(
      senderName: 'Ofosu Towing Services',
      messagePreview: 'We have arrived and are about to pickup y...',
      timestamp: '11:41 AM',
      isRead: false,
      isSent: false,
      isActive: true,
      avatarUrl: '',
    ),
    ChatItem(
      senderName: 'Ofosu Towing Services',
      messagePreview: 'We have arrived and are about to pickup y...',
      timestamp: '11:41 AM',
      isRead: false,
      isSent: false,
      isActive: false,
      avatarUrl: '',
    ),
    ChatItem(
      senderName: 'Mr Ansah & Sons',
      messagePreview: 'Hello, are you on your way now? I\'ve been wai...',
      timestamp: '11:41 AM',
      isRead: true,
      isSent: true,
      isActive: false,
      avatarUrl: '',
    ),
    ChatItem(
      senderName: 'Mr Ansah & Sons',
      messagePreview: 'Hello, are you on your way now? I\'ve been wai...',
      timestamp: '11:41 AM',
      isRead: true,
      isSent: true,
      isActive: false,
      avatarUrl: '',
    ),
    ChatItem(
      senderName: 'Mr Ansah & Sons',
      messagePreview: 'Hello, are you on your way now? I\'ve been wai...',
      timestamp: '11:41 AM',
      isRead: true,
      isSent: true,
      isActive: false,
      avatarUrl: '',
    ),
    ChatItem(
      senderName: 'Mr Ansah & Sons',
      messagePreview: 'Hello, are you on your way now? I\'ve been wai...',
      timestamp: '11:41 AM',
      isRead: true,
      isSent: true,
      isActive: false,
      avatarUrl: '',
    ),
  ];

  Widget _buildChatList() {
    return Container(
      color: Colors.grey[50],
      child: TabBarView(
        controller: _tabController,
        children: [
          _isLoading ? const Center(child: CircularProgressIndicator()) : (_error != null ? Center(child: Text(_error!)) : _buildAllChats()),
          _isLoading ? const Center(child: CircularProgressIndicator()) : (_error != null ? Center(child: Text(_error!)) : _buildUnreadChats()),
        ],
      ),
    );
  }

  Widget _buildAllChats() {
    if (_allChats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                'No chats yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Start a conversation from orders or providers',
                style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _allChats.length,
      itemBuilder: (context, index) {
        return _buildChatItem(_allChats[index]);
      },
    );
  }

  Widget _buildUnreadChats() {
    final unreadChats = _allChats.where((chat) => !chat.isRead).toList();
    if (unreadChats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mark_chat_unread, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                'No unread chats',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 6),
              const Text(
                'New messages will appear here',
                style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: unreadChats.length,
      itemBuilder: (context, index) {
        return _buildChatItem(unreadChats[index]);
      },
    );
  }

  Widget _buildChatItem(ChatItem chat) {
    return InkWell(
      onTap: () {
        // Navigate to chat thread screen with chat details
        context.pushNamed(
          AppRouteNames.chatThread,
          queryParameters: {
            'contactAvatar': chat.avatarUrl,
            'contactName': chat.senderName,
            'contactSubtitle': 'Bulk Water Supplier',
            'ctx': widget.isProvider ? 'provider' : 'customer',
            if (chat.requestId != null && chat.requestId!.isNotEmpty) 'requestId': chat.requestId!,
            if (chat.otherProfileId != null && chat.otherProfileId!.isNotEmpty) 'otherProfileId': chat.otherProfileId!,
          },
        );
      },
      child: Container(
        color: chat.isActive ? const Color(0xFFE8F4FD) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Unread indicator dot (only for unread messages)
              if (!chat.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1B5A96),
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 20), // Spacing for read messages
            
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              backgroundImage: chat.avatarUrl.isNotEmpty 
                  ? NetworkImage(chat.avatarUrl) 
                  : null,
              child: chat.avatarUrl.isEmpty 
                  ? Text(
                      chat.senderName.isNotEmpty ? chat.senderName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 12),
            
            // Chat content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender name and timestamp row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.senderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            chat.timestamp,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (chat.isSent) ...[
                            const SizedBox(width: 4),
                            Text(
                              '• Sent',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Message preview
                  Text(
                    chat.messagePreview,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final api = ref.read(apiServiceProvider);
    final res = await api.getConversations(limit: 50);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (res.success && res.data != null) {
        final items = res.data!;
        _allChats
          ..clear()
          ..addAll(items.map((c) => ChatItem(
                senderName: (c['contact_name'] ?? c['sender_name'] ?? 'Unknown').toString(),
                messagePreview: (c['last_message_text'] ?? c['preview'] ?? '').toString(),
                timestamp: (c['last_message_time'] ?? '').toString(),
                isRead: (c['unread_count'] is int) ? (c['unread_count'] as int) == 0 : true,
                isSent: false,
                isActive: false,
                avatarUrl: (c['avatar_url'] ?? '').toString(),
                requestId: (c['request_id'] ?? '').toString(),
                otherProfileId: (c['other_profile_id'] ?? '').toString(),
              )));
      } else {
        _error = res.message ?? 'Failed to load conversations';
      }
    });
  }

}

class ChatItem {
  final String senderName;
  final String messagePreview;
  final String timestamp;
  final bool isRead;
  final bool isSent;
  final bool isActive;
  final String avatarUrl;
  final String? requestId;
  final String? otherProfileId;

  ChatItem({
    required this.senderName,
    required this.messagePreview,
    required this.timestamp,
    this.isRead = false,
    this.isSent = false,
    this.isActive = false,
    this.avatarUrl = '',
    this.requestId,
    this.otherProfileId,
  });
}