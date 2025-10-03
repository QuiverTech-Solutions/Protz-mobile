import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/utils/pages.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_illustration.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to Protz',
      description: '24/7 towing and water delivery. Help is always just a tap away!',
      illustrationType: IllustrationType.welcome,
    ),
    OnboardingData(
      title: 'Emergency Towing',
      description: 'Fast, reliable roadside assistance. Professional drivers ready to help when you\'re stuck.',
      illustrationType: IllustrationType.towing,
    ),
    OnboardingData(
      title: 'Water Delivery',
      description: 'Clean water to your location. Perfect for homes, events, or construction sites,\nEverywhere!',
      illustrationType: IllustrationType.waterDelivery,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _getStarted() {
    // Navigate to login screen after onboarding
    context.go(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[50],
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final page = _pages[index];
          final isLastPage = index == _pages.length - 1;
          
          return OnboardingPage(
            title: page.title,
            description: page.description,
            illustration: OnboardingIllustration(
              type: page.illustrationType,
            ),
            onNext: _nextPage,
             onSkip: _skipToEnd,
             buttonText: isLastPage ? 'Get Started' : 'Next',
             isLastPage: isLastPage,
             currentPage: _currentPage,
             totalPages: _pages.length,
            // onGetStarted: _getStarted, // removed undefined parameter
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IllustrationType illustrationType;

  OnboardingData({
    required this.title,
    required this.description,
    required this.illustrationType,
  });
}