import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/services/new_auth_service.dart';
import '../../shared/models/user.dart';
import '../../shared/utils/pages.dart';

/// AuthWrapper handles authentication state and navigation
/// It listens to the AuthService user stream and redirects users based on their authentication status
class AuthWrapper extends StatefulWidget {
  final Widget child;
  
  const AuthWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await _authService.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle initialization error
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF086788),
          ),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: _authService.userStream,
      builder: (context, snapshot) {
        // Show loading while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF086788),
              ),
            ),
          );
        }

        final user = snapshot.data;
        final currentLocation = GoRouterState.of(context).uri.path;

        // Define public routes that don't require authentication
        final publicRoutes = [
          AppRoutes.onboarding,
          AppRoutes.login,
          AppRoutes.signup,
          AppRoutes.otpVerification,
          AppRoutes.forgotPassword,
          AppRoutes.splash,
        ];

        // Check if current route is public
        final isPublicRoute = publicRoutes.any((route) => 
          currentLocation.startsWith(route) || currentLocation == '/');

        if (user == null) {
          // User is not authenticated
          if (!isPublicRoute) {
            // Redirect to login if trying to access protected route
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.go(AppRoutes.login);
              }
            });
          }
          return widget.child;
        } else {
          // User is authenticated
          if (isPublicRoute && currentLocation != AppRoutes.otpVerification) {
            // Redirect authenticated user to appropriate home based on user type
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _redirectToHome(user);
              }
            });
          }
          return widget.child;
        }
      },
    );
  }

  void _redirectToHome(User user) {
    // Redirect based on user type
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
  void dispose() {
    super.dispose();
  }
}