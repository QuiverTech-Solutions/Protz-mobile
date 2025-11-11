import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/utils/pages.dart';
import '../services/new_auth_service.dart';
import '../../shared/models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize auth service
      await _authService.initialize();
      
      // Wait for a brief moment to show splash
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Check authentication status
        final isAuthenticated = await _authService.isAuthenticated();
        
        if (isAuthenticated) {
          // Get current user and redirect to appropriate home
          final user = _authService.currentUser;
          if (user != null) {
            _redirectToHome(user);
          } else {
            // User is authenticated but no user data, go to login
            context.go(AppRoutes.login);
          }
        } else {
          // User is not authenticated, go to onboarding
          context.go(AppRoutes.onboarding);
        }
      }
    } catch (e) {
      // If there's an error, go to onboarding
      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  void _redirectToHome(User user) {
    switch (user.role) {
      case UserRole.customer:
        context.go(AppRoutes.customerHome);
        break;
      case UserRole.serviceProvider:
        context.go(AppRoutes.providerHome);
        break;
      case UserRole.administrator:
        context.go(AppRoutes.adminDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.5),
            radius: 3.0,
            focalRadius: 0.0,
            colors: [
              Color.fromARGB(255, 153, 228, 253),
              Color(0xFFECF6F9),
              Color(0xFFF0F8FA),
              Color(0xFFF4FAFB),
              Color(0xFFF8FCFD),
              Color(0xFFFBFDFE),
              Color(0xFFFEFFFF),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.2, 0.35, 0.5, 0.65, 0.8, 0.9, 1.0],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Icon(
                Icons.local_shipping,
                size: 80,
                color: Color(0xFF086788),
              ),
              SizedBox(height: 24),
              Text(
                'Protz',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF086788),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Towing & Water Delivery',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF086788),
                ),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(
                color: Color(0xFF086788),
              ),
            ],
          ),
        ),
      ),
    );
  }
}