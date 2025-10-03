import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_export.dart';
import '../core/utils/size_utils.dart';
import '../widgets/call_options_popup.dart';
import '../widgets/attachment_options_popup.dart';
import '../widgets/user_options_bottom_sheet.dart';

class ChatThreadScreen extends StatefulWidget {
  final String contactName;
  final String contactSubtitle;
  final String contactAvatar;

  const ChatThreadScreen({
    Key? key,
    required this.contactName,
    required this.contactSubtitle,
    required this.contactAvatar,
  }) : super(key: key);

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Sample chat messages data
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'Hi there! 👋',
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      status: MessageStatus.seen,
    ),
    ChatMessage(
      id: '2',
      text: 'Hello. How\'s it going?',
      isFromMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 45)),
      status: MessageStatus.seen,
    ),
    ChatMessage(
      id: '3',
      text: 'Everything\'s fine.\nI\'m here to ask if you\'ll be working today.',
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 30)),
      status: MessageStatus.seen,
    ),
    ChatMessage(
      id: '4',
      text: 'Today is an off day so we\'ll resume work tomorrow please.',
      isFromMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 15)),
      status: MessageStatus.seen,
    ),
    ChatMessage(
      id: '5',
      text: 'These are the tanks I have in my home. How much water do you think can fill them up?',
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      status: MessageStatus.seen,
      imageUrl: 'assets/images/water_tanks.jpg',
    ),
    ChatMessage(
      id: '6',
      text: 'Hi there! 👋',
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      status: MessageStatus.seen,
    ),
    ChatMessage(
      id: '7',
      text: 'Hello. How\'s it going?',
      isFromMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      status: MessageStatus.seen,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMessagesList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF333333),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF0891B2),
            backgroundImage: widget.contactAvatar.isNotEmpty 
                ? AssetImage(widget.contactAvatar) 
                : null,
            child: widget.contactAvatar.isEmpty 
                ? Text(
                    widget.contactName.isNotEmpty 
                        ? widget.contactName[0].toUpperCase() 
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                if (widget.contactSubtitle.isNotEmpty)
                  Text(
                    widget.contactSubtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0891B2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showCallOptions();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.phone,
                color: Color(0xFF0891B2),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _showUserOptions();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.more_vert,
                color: Color(0xFF333333),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _getMessagesWithSeparators().length,
        itemBuilder: (context, index) {
          final item = _getMessagesWithSeparators()[index];
          if (item is String) {
            return _buildDateSeparator(item);
          } else if (item is ChatMessage) {
            return _buildMessageBubble(item);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<dynamic> _getMessagesWithSeparators() {
    List<dynamic> items = [];
    String? lastDate;
    
    for (var message in _messages) {
      String currentDate = _getDateString(message.timestamp);
      if (lastDate != currentDate) {
        items.add(currentDate);
        lastDate = currentDate;
      }
      items.add(message);
    }
    
    return items;
  }

  Widget _buildDateSeparator(String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isFromMe = message.isFromMe;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isFromMe) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF0891B2),
                  backgroundImage: widget.contactAvatar.isNotEmpty 
                      ? AssetImage(widget.contactAvatar) 
                      : null,
                  child: widget.contactAvatar.isEmpty 
                      ? Text(
                          widget.contactName.isNotEmpty 
                              ? widget.contactName[0].toUpperCase() 
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isFromMe ? const Color(0xFF0891B2) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isFromMe ? 20 : 4),
                      bottomRight: Radius.circular(isFromMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            message.imageUrl!,
                            width: 200,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (message.text.isNotEmpty) const SizedBox(height: 8),
                      ],
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: isFromMe ? Colors.white : const Color(0xFF374151),
                            height: 1.4,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(
              left: isFromMe ? 0 : 40,
              right: isFromMe ? 0 : 0,
            ),
            child: Row(
              mainAxisAlignment: isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                if (isFromMe) ...[
                  const SizedBox(width: 4),
                  Text(
                    '• ${message.status.displayName}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Emoji button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.emoji_emotions_outlined,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Text input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Attachment button
            GestureDetector(
              onTap: _showAttachmentOptions,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.attach_file,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0891B2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: _messageController.text.trim(),
            isFromMe: true,
            timestamp: DateTime.now(),
            status: MessageStatus.sent,
          ),
        );
      });
      _messageController.clear();
      
      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      // Today
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else {
      // Older dates
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _getDateString(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showCallOptions() {
    CallOptionsPopup.show(
      context,
      contactName: widget.contactName,
      onInAppCall: () {
        _handleInAppCall();
      },
      onOfflineCall: () {
        _handleOfflineCall();
      },
      onEmergencyCall: () {
        _handleEmergencyCall();
      },
    );
  }

  void _handleInAppCall() {
    // TODO: Implement in-app voice call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting in-app voice call with ${widget.contactName}...'),
        backgroundColor: const Color(0xFF1B5A96),
      ),
    );
  }

  void _handleOfflineCall() {
    // TODO: Implement offline voice call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting offline voice call with ${widget.contactName}...'),
        backgroundColor: Colors.grey[700],
      ),
    );
  }

  void _handleEmergencyCall() {
    // TODO: Implement emergency call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Initiating emergency call...'),
        backgroundColor: Color(0xFFE53E3E),
      ),
    );
  }

  void _showAttachmentOptions() {
    AttachmentOptionsPopup.show(
      context,
      onPhotoTap: () {
        _handlePhotoAttachment();
      },
      onVideoTap: () {
        _handleVideoAttachment();
      },
      onDocumentTap: () {
        _handleDocumentAttachment();
      },
      onAudioTap: () {
        _handleAudioAttachment();
      },
    );
  }

  void _handlePhotoAttachment() {
    // TODO: Implement photo attachment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo attachment selected'),
        backgroundColor: Color(0xFF0891B2),
      ),
    );
  }

  void _handleVideoAttachment() {
    // TODO: Implement video attachment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video attachment selected'),
        backgroundColor: Color(0xFF0891B2),
      ),
    );
  }

  void _handleDocumentAttachment() {
    // TODO: Implement document attachment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document attachment selected'),
        backgroundColor: Color(0xFF0891B2),
      ),
    );
  }

  void _handleAudioAttachment() {
    // TODO: Implement audio attachment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio attachment selected'),
        backgroundColor: Color(0xFF0891B2),
      ),
    );
  }

  void _showUserOptions() {
    UserOptionsBottomSheet.show(
      context,
      onRateProvider: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rate service provider selected')),
        );
      },
      onMuteNotifications: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mute notifications selected')),
        );
      },
      onReportAccount: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report account selected')),
        );
      },
      onBlockUser: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Block user selected')),
        );
      },
    );
  }
}

// Message model
class ChatMessage {
  final String id;
  final String text;
  final bool isFromMe;
  final DateTime timestamp;
  final MessageStatus status;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isFromMe,
    required this.timestamp,
    required this.status,
    this.imageUrl,
  });
}

enum MessageStatus {
  sent,
  delivered,
  seen;

  String get displayName {
    switch (this) {
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.seen:
        return 'Seen';
    }
  }
}

extension MessageStatusExtension on MessageStatus {
  String get name {
    switch (this) {
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.seen:
        return 'Seen';
    }
  }
}