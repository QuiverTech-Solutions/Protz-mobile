import 'package:flutter/material.dart';

class AttachmentOptionsPopup {
  static void show(BuildContext context, {
    required VoidCallback onPhotoTap,
    required VoidCallback onVideoTap,
    required VoidCallback onDocumentTap,
    required VoidCallback onAudioTap,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AttachmentOptionsBottomSheet(
        onPhotoTap: onPhotoTap,
        onVideoTap: onVideoTap,
        onDocumentTap: onDocumentTap,
        onAudioTap: onAudioTap,
      ),
    );
  }
}

class AttachmentOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onPhotoTap;
  final VoidCallback onVideoTap;
  final VoidCallback onDocumentTap;
  final VoidCallback onAudioTap;

  const AttachmentOptionsBottomSheet({
    super.key,
    required this.onPhotoTap,
    required this.onVideoTap,
    required this.onDocumentTap,
    required this.onAudioTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Attachment options in a single row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Photo option
                _buildAttachmentOption(
                  icon: Icons.image_outlined,
                  label: 'Photo',
                  color: const Color(0xFF0891B2),
                  onTap: () {
                    Navigator.pop(context);
                    onPhotoTap();
                  },
                ),
                
                // Video option
                _buildAttachmentOption(
                  icon: Icons.videocam_outlined,
                  label: 'Video',
                  color: const Color(0xFF0891B2),
                  onTap: () {
                    Navigator.pop(context);
                    onVideoTap();
                  },
                ),
                
                // Document option
                _buildAttachmentOption(
                  icon: Icons.description_outlined,
                  label: 'Document',
                  color: const Color(0xFF0891B2),
                  onTap: () {
                    Navigator.pop(context);
                    onDocumentTap();
                  },
                ),
                
                // Audio option
                _buildAttachmentOption(
                  icon: Icons.music_note_outlined,
                  label: 'Audio',
                  color: const Color(0xFF0891B2),
                  onTap: () {
                    Navigator.pop(context);
                    onAudioTap();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}