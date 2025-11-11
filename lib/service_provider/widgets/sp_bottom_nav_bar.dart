import 'package:flutter/material.dart';

class SPBottomNavItem {
  final Widget icon;
  final Widget? activeIcon;
  final String label;

  const SPBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

typedef SPNavTap = void Function(int index);

class SPBottomNavBar extends StatelessWidget {
  final List<SPBottomNavItem> items;
  final int currentIndex;
  final SPNavTap onItemSelected;

  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final double elevation;

  const SPBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.selectedColor = const Color(0xFF086788), // Protz Primary
    this.unselectedColor = const Color(0xFF909090), // Light Grey
    this.elevation = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: elevation,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 16, 28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < items.length; i++) _buildItem(context, items[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, SPBottomNavItem item, int index) {
    final bool isActive = index == currentIndex;
    final Widget iconWidget = isActive && item.activeIcon != null ? item.activeIcon! : item.icon;

    final Color labelColor = isActive ? selectedColor : const Color(0xFF909090);
    final Color iconColor = isActive ? selectedColor : unselectedColor;

    final BoxDecoration activeDecoration = BoxDecoration(
      color: selectedColor.withOpacity(0.10), // rgba(8,103,136,0.1)
      borderRadius: BorderRadius.circular(12),
    );

    final BoxDecoration defaultDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    );

    final Widget content = Container(
      width: 68,
      height: 60,
      decoration: isActive ? activeDecoration : defaultDecoration,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              color: iconColor,
              size: 24,
            ),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Center(child: iconWidget),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: labelColor,
              height: 1.0,
            ),
          ),
        ],
      ),
    );

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onItemSelected(index),
        child: isActive ? content : Opacity(opacity: 0.5, child: content),
      ),
    );
  }
}