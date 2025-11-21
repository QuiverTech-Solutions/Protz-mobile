import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../customer/core/app_export.dart';
import '../providers/api_service_provider.dart';

class CustomerServiceChatScreen extends ConsumerStatefulWidget {
  const CustomerServiceChatScreen({super.key});

  @override
  ConsumerState<CustomerServiceChatScreen> createState() => _CustomerServiceChatScreenState();
}

class _CustomerServiceChatScreenState extends ConsumerState<CustomerServiceChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello. I am not able to reach my towing service provider. They are not responding to my calls or texts. Can I get any assistance?",
      timestamp: "9:41 PM • Sent",
      isFromUser: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final api = ref.read(apiServiceProvider);
    // Attempt to send as support message; if backend lacks endpoint, fall back to local append
    final res = await api.sendMessage(requestId: 'support', messageContent: text);
    if (res.success) {
      setState(() {
        _messages.add(ChatMessage(
          text: text,
          timestamp: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'} • Sent",
          isFromUser: true,
        ));
      });
    } else {
      setState(() {
        _messages.add(ChatMessage(
          text: text,
          timestamp: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'} • Sent",
          isFromUser: true,
        ));
      });
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Today label
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Today',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
            
            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            
            // Message input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.h, 12.h, 16.h, 12.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color(0xFF2B2930),
            ),
            onPressed: () => context.pop(),
          ),
          SizedBox(width: 8.h),
          
          // Avatar
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFF086788),
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.h),
              child: Image.asset(
                'assets/images/protz_avatar.png', // You can replace with actual avatar
                width: 40.h,
                height: 40.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF086788),
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          
          SizedBox(width: 12.h),
          
          // Name and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Protz',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B2930),
                  ),
                ),
                Text(
                  'Customer Service',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF086788),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: message.isFromUser 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: message.isFromUser 
                  ? const Color(0xFF086788)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: message.isFromUser 
                    ? Colors.white 
                    : const Color(0xFF2B2930),
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            message.timestamp,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 16.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Emoji button
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
              onPressed: () {
                // TODO: Implement emoji picker
              },
            ),
          ),
          
          SizedBox(width: 12.h),
          
          // Text input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20.h),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 10.h,
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2B2930),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          
          SizedBox(width: 12.h),
          
          // Send button
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFF086788),
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                size: 18,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String timestamp;
  final bool isFromUser;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isFromUser,
  });
}