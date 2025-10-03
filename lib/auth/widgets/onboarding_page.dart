import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget illustration;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final String buttonText;
  final bool isLastPage;
  final int currentPage;
  final int totalPages;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    this.onNext,
    this.onSkip,
    this.buttonText = 'Next',
    this.isLastPage = false,
    this.currentPage = 0,
    this.totalPages = 3,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 3.0, // very large radius for maximum blur
                focalRadius: 0.0, // no focal point
                colors: [
                  Color.fromARGB(150, 8, 104, 136), // Very light blue-white
                  Color(0xFFECF6F9), // Slightly lighter
                  Color(0xFFF0F8FA), // Even lighter
                  Color(0xFFF4FAFB), // Almost white with hint of blue
                  Color(0xFFF8FCFD), // Nearly white
                  Color(0xFFFBFDFE), // Almost pure white
                  Color(0xFFFEFFFF), // Almost pure white
                  Color(0xFFFFFFFF), // Pure white
                ],
                stops: [
                  0.0,
                  0.2,
                  0.35,
                  0.5,
                  0.65,
                  0.8,
                  0.9,
                  1.0
                ], // Gradual transitions
              ),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Top navigation with status bar padding
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: statusBarHeight + 16,
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Back button
                      
                      // Skip button
                      if (!isLastPage)
                        TextButton(
                          onPressed: onSkip,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Illustration area
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: illustration,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                    Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(200),
                          topRight: Radius.circular(200),
                        ),
                        border: Border(
                          top: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color(0xFF086688),
                            width: 5,
                          ),
                          left: BorderSide(
                            color: const Color(0xFF086688),
                            width: 5,
                          ),
                          right: BorderSide(
                            color: const Color(0xFF086688),
                            width: 5,
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 3, left: 3, right: 3),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(200),
                            topRight: Radius.circular(200),
                          ),
                          border: const Border(
                            top: BorderSide(
                              color: Color(0xFF086688),
                              width: 5,
                            ),
                            left: BorderSide(
                              color: Color(0xFF086688),
                              width: 5,
                            ),
                            right: BorderSide(
                              color: Color(0xFF086688),
                              width: 5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 40),
                          child: Container(
                              height: screenHeight * 0.45,
                              padding: const EdgeInsets.fromLTRB(32, 80, 32, 40),
                              child: Column(
                                children: [
                                  // Title
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  
                                  const SizedBox(height: 15),
                                  
                                  // Description
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 40),
                                  Container(
                                        width: isLastPage? 200:120,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF086788), // Dark teal from color scheme
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: onNext,
                                            borderRadius: BorderRadius.circular(24),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  buttonText,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                isLastPage
                                                    ? const SizedBox()
                                                    : 
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color(0xFF086788),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.arrow_forward,
                                                    size: 14,
                                                    color: Color(0xFF086788),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  
                                  const Spacer(),
                                  
                                  // Bottom navigation
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Page indicators
                                      Row(
                                        children: List.generate(
                                          totalPages,
                                          (index) => Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            width: index == currentPage ? 24 : 8,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: index == currentPage
                                                  ? const  Color(0xFF086788)// Tea
                                                  : const Color(0xFFE0E0E0),
                                                width: 1.5,
                                              ),
                                              color: index == currentPage
                                                  ? const Color(0xFFFFFFFF) // Teal
                                                  : const Color(0xFFE0E0E0),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      // Next button
                                      
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                        ),
                      ),
                    ),
                  ),
                    
        
                    
                        ],
                      ),
                    ]),
                ),
            
            );  
  }
}
class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFEBFBFE)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = const Color(0xFF086788) // Dark teal outline to match the color scheme
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final path = Path();
    
    // Create semicircle arc path
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height * 0.5);
    
    // Start from left edge at the center height
    path.moveTo(0, size.height * 0.5);
    
    // Create perfect semicircle using arcTo
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start angle (180 degrees)
      math.pi, // Sweep angle (180 degrees)
      false,
    );
    
    // Complete the shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw filled arc
    canvas.drawPath(path, paint);
    
    // Draw outer border around the entire shape
    canvas.drawPath(path, strokePaint);
    
    // Draw inner border with reduced spacing
    
    final innerPath = Path();
    innerPath.moveTo(0, size.height * 0.5);
    innerPath.arcTo(
      Rect.fromCircle(center: center, radius: radius - 7),
      math.pi,
      math.pi,
      false,
    );
    innerPath.lineTo(size.width - 7, size.height);
    innerPath.lineTo(7, size.height);
    innerPath.close();
    
    canvas.drawPath(innerPath, strokePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}