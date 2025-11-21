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
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
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
                                
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                // Bottom navigation
                                Container(
                                      width: double.infinity,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF086788), // Dark teal from color scheme
                                        borderRadius: BorderRadius.circular(12),
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
            
            );  
  }
}
