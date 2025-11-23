import 'dart:async';
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
  int _stage = 1;
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();
    _startStages();
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

  void _startStages() {
    _stageTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _stage = 2);
      }
      _stageTimer = Timer(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _stage = 3);
        }
      });
    });
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
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

  Widget _buildSplashStage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        const dw = 393.0;
        const dh = 852.0;
        final s = (w / dw < h / dh) ? w / dw : h / dh;
        Widget spot(double size) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.65),
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          );
        }
        switch (_stage) {
          case 1:
            return Container(color: const Color(0xFF086788));
          case 2:
            return Container(
              color: const Color(0xFF086788),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: -36 * (h / dh),
                    left: -106 * (w / dw),
                    child: spot(212 * s),
                  ),
                  Positioned(
                    bottom: -36 * (h / dh),
                    right: -106 * (w / dw),
                    child: spot(212 * s),
                  ),
                ],
              ),
            );
          default:
            return Container(
              color: const Color(0xFF086788),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: -36 * (h / dh),
                    left: -106 * (w / dw),
                    child: spot(212 * s),
                  ),
                  Positioned(
                    bottom: -36 * (h / dh),
                    right: -106 * (w / dw),
                    child: spot(212 * s),
                  ),
                  Center(
                    child: Text(
                      'WATO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60 * s,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: KeyedSubtree(
          key: ValueKey(_stage),
          child: _buildSplashStage(),
        ),
      ),
    );
  }
}
