import 'package:flutter/material.dart';

enum IllustrationType {
  welcome,
  towing,
  waterDelivery,
}

class OnboardingIllustration extends StatelessWidget {
  final IllustrationType type;

  const OnboardingIllustration({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (type) {
      case IllustrationType.welcome:
        imagePath = 'assets/images/welcome.png';
        break;
      case IllustrationType.towing:
        imagePath = 'assets/images/towing.png';
        break;
      case IllustrationType.waterDelivery:
        imagePath = 'assets/images/water_delivery.png';
        break;
    }

    return Container(
      padding: EdgeInsets.only(top: 20),
      width: 300,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 300,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Image not found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

 