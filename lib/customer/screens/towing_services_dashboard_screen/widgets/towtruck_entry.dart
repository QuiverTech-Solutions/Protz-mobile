import 'package:flutter/material.dart';

class TowtruckEntry extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String? oldPrice;
  final String imageAsset;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onSelectPressed;

  const TowtruckEntry({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageAsset,
    this.oldPrice,
    this.selected = false,
    this.onTap,
    this.onSelectPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF086788) : Colors.grey.shade300,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(imageAsset, width: 72, height: 72, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subtitle,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ),
                          Icon(
                            selected ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: selected ? const Color(0xFF086788) : Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            price,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF09814A)),
                          ),
                          if (oldPrice != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              oldPrice!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSelectPressed ?? onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F7F90),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Select this service'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}