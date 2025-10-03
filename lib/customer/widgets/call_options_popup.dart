import 'package:flutter/material.dart';

class CallOptionsPopup {
  static void show(BuildContext context, {
    required String contactName,
    required VoidCallback onInAppCall,
    required VoidCallback onOfflineCall,
    required VoidCallback onEmergencyCall,
  }) {
    showDialog(
      context: context,
      //backgroundColor: Colors.black54,
      builder: (context) => CallOptionsDialog(
        contactName: contactName,
        onInAppCall: onInAppCall,
        onOfflineCall: onOfflineCall,
        onEmergencyCall: onEmergencyCall,
      ),
    );
  }
}

class CallOptionsDialog extends StatelessWidget {
  final String contactName;
  final VoidCallback onInAppCall;
  final VoidCallback onOfflineCall;
  final VoidCallback onEmergencyCall;

  const CallOptionsDialog({
    super.key,
    required this.contactName,
    required this.onInAppCall,
    required this.onOfflineCall,
    required this.onEmergencyCall,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // In-app voice call option
              _buildCallOption(
                icon: _buildInAppCallIcon(),
                title: 'In-app voice call',
                titleColor: const Color(0xFF1B5A96),
                onTap: () {
                  Navigator.pop(context);
                  onInAppCall();
                },
              ),
              
              //const SizedBox(height: 16),
              
              // Offline voice call option
              _buildCallOption(
                icon: _buildOfflineCallIcon(),
                title: 'Offline voice call',
                titleColor: Colors.black87,
                onTap: () {
                  Navigator.pop(context);
                  onOfflineCall();
                },
              ),
              
              //const SizedBox(height: 16),
              
              // Emergency call option
              _buildCallOption(
                icon: _buildEmergencyCallIcon(),
                title: 'Emergency call',
                titleColor: const Color(0xFFE53E3E),
                onTap: () {
                  Navigator.pop(context);
                  onEmergencyCall();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallOption({
    required Widget icon,
    required String title,
    required Color titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInAppCallIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1B5A96).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.phone,
        color: Color(0xFF1B5A96),
        size: 24,
      ),
    );
  }

  Widget _buildOfflineCallIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: Colors.black54,
            size: 24,
          ),
         
        ],
      ),
    );
  }

  Widget _buildEmergencyCallIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE53E3E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.warning,
        color: Color(0xFFE53E3E),
        size: 24,
      ),
    );
  }
}