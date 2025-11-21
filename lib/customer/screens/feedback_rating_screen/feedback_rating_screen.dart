import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../customer/theme/theme_helper.dart';

class FeedbackRatingScreen extends StatefulWidget {
  final String providerName;
  final double providerRating;
  final String serviceType;
  final String? providerAvatarUrl;
  final String? serviceRequestId;

  const FeedbackRatingScreen({
    super.key,
    required this.providerName,
    required this.providerRating,
    required this.serviceType,
    this.providerAvatarUrl,
    this.serviceRequestId,
  });

  @override
  State<FeedbackRatingScreen> createState() => _FeedbackRatingScreenState();
}

class _FeedbackRatingScreenState extends State<FeedbackRatingScreen> {
  int rating = 0;
  final TextEditingController additionalFeedbackCtrl = TextEditingController();
  final TextEditingController improvementCtrl = TextEditingController();
  String? appExperience;

  @override
  void dispose() {
    additionalFeedbackCtrl.dispose();
    improvementCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'Feedback & Rating',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF086788),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0x33909090)),
                foregroundColor: const Color(0xFF909090),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.pop(),
              child: const Text('Skip', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help us improve by giving feedback on your experience.',
              style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF4F4F4), height: 1),
            const SizedBox(height: 20),
            const Text(
              'Rate this service provider',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E1E1E)),
            ),
            const SizedBox(height: 12),
            _Stars(
              value: rating,
              onChanged: (v) => setState(() => rating = v),
            ),
            const SizedBox(height: 20),
            _ProviderCard(
              name: widget.providerName,
              rating: widget.providerRating,
              serviceType: widget.serviceType,
              avatarUrl: widget.providerAvatarUrl,
            ),
            const SizedBox(height: 24),
            const Text(
              'Do you want to say anything else?',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E1E1E)),
            ),
            const SizedBox(height: 8),
            _InputBox(
              controller: additionalFeedbackCtrl,
              hint: 'Give additional feedback',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFF4F4F4), height: 1),
            const SizedBox(height: 20),
            const Text(
              'How do you feel about the overall app experience?',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E1E1E)),
            ),
            const SizedBox(height: 8),
            _DropdownBox(
              value: appExperience,
              hint: 'Select an option',
              items: const [
                'Excellent',
                'Good',
                'Average',
                'Poor',
              ],
              onChanged: (v) => setState(() => appExperience = v),
            ),
            const SizedBox(height: 20),
            const Text(
              'What can we do to improve the experience for you?',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E1E1E)),
            ),
            const SizedBox(height: 8),
            _InputBox(
              controller: improvementCtrl,
              hint: 'Give us your thoughts',
              maxLines: 3,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: _SubmitBar(
          onPressed: _submit,
        ),
      ),
    );
  }

  void _submit() {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a rating'),
          backgroundColor: appTheme.light_blue_900,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final payload = {
      'serviceRequestId': widget.serviceRequestId,
      'providerName': widget.providerName,
      'providerRating': widget.providerRating,
      'serviceType': widget.serviceType,
      'rating': rating,
      'additionalFeedback': additionalFeedbackCtrl.text.trim(),
      'appExperience': appExperience,
      'improvement': improvementCtrl.text.trim(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Feedback submitted'),
        backgroundColor: appTheme.light_blue_900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    context.pop(payload);
  }
}

class _Stars extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _Stars({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final filled = index < value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onChanged(index + 1),
            child: Icon(
              filled ? Icons.star : Icons.star_border,
              size: 32,
              color: appTheme.light_blue_900,
            ),
          ),
        );
      }),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final String name;
  final double rating;
  final String serviceType;
  final String? avatarUrl;

  const _ProviderCard({
    required this.name,
    required this.rating,
    required this.serviceType,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appTheme.light_blue_900,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: appTheme.light_blue_50,
                  blurRadius: 0,
                  spreadRadius: 0,
                )
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(avatarUrl!, fit: BoxFit.cover)
                : const Icon(Icons.person, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.white, size: 18),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: appTheme.light_blue_50,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.black87),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: appTheme.light_blue_50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        serviceType,
                        style: TextStyle(
                          color: appTheme.light_blue_900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _InputBox({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x80909090)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF505050)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownBox({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x80909090)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 12, color: Color(0xFF505050)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  final VoidCallback onPressed;
  const _SubmitBar({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Material(
        color: appTheme.light_blue_900,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const Spacer(),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1A02000B),
                        blurRadius: 23,
                        offset: const Offset(3, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.send, size: 20, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}