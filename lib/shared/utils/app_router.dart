import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:protz/customer/screens/towing_services_dashboard_screen/towing_services_dashboard.dart';
import 'package:protz/service_provider/screens/TW_dashboard/sp_towing_home.dart';
import 'package:protz/service_provider/screens/TW_dashboard/sp_order_request_details.dart';
import 'package:protz/service_provider/screens/WD_dashboard/sp_water_home.dart';
import 'package:protz/service_provider/screens/WD_dashboard/sp_water_order_status.dart';
import 'package:protz/service_provider/screens/sp_order_requests.dart';
import 'package:protz/service_provider/screens/TW_dashboard/sp_towing_order_status.dart';
import 'package:protz/service_provider/screens/sp_finances_screen.dart';
import '../../customer/screens/water_delivery_dashboard_screen/water_delivery_dashboard_screen.dart';
import '../../customer/screens/acount_screens/account_screen.dart';
import '../../customer/screens/acount_screens/delete_account_screen.dart';
import '../models/service_request.dart';
import '../../auth/screens/new_password_screen.dart';

import '../../customer/screens/water_delivery_dashboard_screen/water_delivery_screen_1.dart';
import '../../customer/screens/water_delivery_dashboard_screen/water_delivery_screen_2.dart';
import 'pages.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation:AppRoutes.providerHome,
    debugLogDiagnostics: true,
    routes: [
      // Splash/Initial Route
      GoRoute(
        path: '/',
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding Routes
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRouteNames.onboarding,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const OnboardingScreen(),
          state: state,
        ),
      ),
      
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const LoginScreen(),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.signupSelection,
        name: AppRouteNames.signupSelection,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const SignupSelectionScreen(),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.signup,
        name: AppRouteNames.signup,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: SignUpScreen(
            userType: state.uri.queryParameters['userType'] ?? 'user',
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.otpVerification,
        name: AppRouteNames.otpVerification,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: OtpVerificationScreen(
            // userId: state.uri.queryParameters['userId'] ?? '',
            phoneNumber: state.uri.queryParameters['phone'] ?? '',
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRouteNames.forgotPassword,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const ForgotPasswordScreen(),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.forgotPasswordOtp,
        name: AppRouteNames.forgotPasswordOtp,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: OtpVerificationScreen(
            phoneNumber: state.uri.queryParameters['phone'] ?? '',
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.newPassword,
        name: AppRouteNames.newPassword,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: NewPasswordScreen(
            phoneNumber: state.uri.queryParameters['phone'] ?? '',
            otpCode: state.uri.queryParameters['otp'] ?? '',
          ),
          state: state,
        ),
      ),
      
      // Customer Routes
      GoRoute(
        path: AppRoutes.customerHome,
        name: AppRouteNames.customerHome,
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          child: TowingServicesDashboardScreen(), // Default customer home screen
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.waterDeliveryDashboard,
        name: AppRouteNames.waterDeliveryDashboard,
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          child: const WaterDeliveryDashboard(),
          state: state,
        ),
      ),

      // Provider Routes
      // Moved provider documents under nested providerHome route below to avoid duplicate path definitions

      // Account & Settings Screens
      GoRoute(
        path: AppRoutes.accountSettings,
        name: AppRouteNames.accountSettings,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const AccountScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.history,
        name: AppRouteNames.history,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const OrderHistoryScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.customerProfile,
        name: AppRouteNames.customerProfile,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const ProfileScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.wallet,
        name: AppRouteNames.wallet,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const WalletScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.addMobileMoney,
        name: AppRouteNames.addMobileMoney,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const AddMobileMoneyScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.addCard,
        name: AppRouteNames.addCard,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const AddCardScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/customer/security',
        name: 'customer-security',
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const SecurityPasswordScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.deleteAccount,
        name: AppRouteNames.deleteAccount,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const DeleteAccountScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRouteNames.notifications,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const NotificationsScreen(),
          state: state,
        ),
      ),
      
      // Towing Service Screens
      GoRoute(
        path: AppRoutes.towingServicesScreen1,
        name: AppRouteNames.towingServicesScreen1,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: TowingServicesScreen1(),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.towingServicesScreen2,
        name: AppRouteNames.towingServicesScreen2,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: TowingServicesScreen2(
            pickupLocation: state.uri.queryParameters['pickupLocation'] ?? '',
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.towingServicesScreen3,
        name: AppRouteNames.towingServicesScreen3,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: TowingServicesScreen3(
            pickupLocation: state.uri.queryParameters['pickupLocation'] ?? '',
            destination: state.uri.queryParameters['destination'] ?? '',
          ),
          state: state,
        ),
      ),

      // Towing Checkout Screen
      GoRoute(
        path: AppRoutes.towingCheckout,
        name: AppRouteNames.towingCheckout,
        pageBuilder: (context, state) {
          final extra = state.extra;
          return CustomTransitions.slideTransition(
            child: TowingCheckout(
              towingData: extra is Map<String, dynamic> ? extra : null,
            ),
            state: state,
          );
        },
      ),
      
      //water delivery screens
      GoRoute(
        path: AppRoutes.waterDeliveryScreen1,
        name: AppRouteNames.waterDeliveryScreen1,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: WaterDeliveryScreen1(
            destination: state.uri.queryParameters['destination'] ?? '',
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.waterDeliveryScreen2,
        name: AppRouteNames.waterDeliveryScreen2,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: WaterDeliveryScreen2(
            destination: state.uri.queryParameters['destination'] ?? '',
          ),
          state: state,
        ),
      ),



      // Provider Routes
      GoRoute(
        path: AppRoutes.providerHome,
        name: AppRouteNames.providerHome,
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          child: const SpTowingHome(),
          state: state,
        ),
        routes: [
          GoRoute(
            path: 'request-details',
            name: AppRouteNames.providerOrderRequestDetails,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: SPOrderRequestDetails(
                request: state.extra as ServiceRequest,
              ),
              state: state,
            ),
          ),
          GoRoute(
            path: 'active-job',
            name: AppRouteNames.activeJob,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const SPTowingOrderStatus(),
              state: state,
            ),
          ),
          GoRoute(
            path: 'active-water-job',
            name: AppRouteNames.activeWaterJob,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const SPWaterOrderStatus(),
              state: state,
            ),
          ),
          GoRoute(
            path: 'earnings',
            name: AppRouteNames.earnings,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const SPFinancesScreen(),
              state: state,
            ),
          ),
          GoRoute(
            path: 'profile',
            name: AppRouteNames.providerProfile,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const Scaffold(
                body: Center(
                  child: Text('Provider Profile - Coming Soon'),
                ),
              ),
              state: state,
            ),
          ),
          GoRoute(
            path: 'documents',
            name: AppRouteNames.documents,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const DocumentVerificationScreen(),
              state: state,
            ),
          ),
          GoRoute(
            path: 'wallet/setup',
            name: AppRouteNames.providerWalletSetup,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const ProtzWalletSetupScreen(),
              state: state,
            ),
          ),
          GoRoute(
            path: 'availability',
            name: AppRouteNames.availability,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const Scaffold(
                body: Center(
                  child: Text('Availability - Coming Soon'),
                ),
              ),
              state: state,
            ),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.jobRequests,
        name: AppRouteNames.jobRequests,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const SPOrderRequests(),
          state: state,
        ),
      ),

      GoRoute(
        path: AppRoutes.providerWaterHome,
        name: AppRouteNames.providerWaterHome,
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          child: const SpWaterHome(),
          state: state,
        ),
      ),
      
      // Admin Routes
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: AppRouteNames.adminDashboard,
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Admin Dashboard - Coming Soon'),
            ),
          ),
          state: state,
        ),
        routes: [
          GoRoute(
            path: 'users',
            name: AppRouteNames.userManagement,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const Scaffold(
                body: Center(
                  child: Text('User Management - Coming Soon'),
                ),
              ),
              state: state,
            ),
          ),
          GoRoute(
            path: 'bookings',
            name: AppRouteNames.bookingManagement,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const Scaffold(
                body: Center(
                  child: Text('Booking Management - Coming Soon'),
                ),
              ),
              state: state,
            ),
          ),
          GoRoute(
            path: 'reports',
            name: AppRouteNames.financialReports,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const Scaffold(
                body: Center(
                  child: Text('Financial Reports - Coming Soon'),
                ),
              ),
              state: state,
            ),
          ),
          GoRoute(
            path: 'analytics',
            name: AppRouteNames.analytics,
            pageBuilder: (context, state) => CustomTransitions.slideTransition(
              child: const Scaffold(
                body: Center(
                  child: Text('Analytics - Coming Soon'),
                ),
              ),
              state: state,
            ),
          ),
        ],
      ),
      
      // Shared Routes
      GoRoute(
        path: AppRoutes.settings,
        name: AppRouteNames.settings,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Settings - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.help,
        name: AppRouteNames.help,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const HelpSupportScreen(),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.chat,
        name: AppRouteNames.chat,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const CustomerServiceChatScreen(),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.chatInbox,
        name: AppRouteNames.chatInbox,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const ChatInboxScreen(),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.chatThread,
        name: AppRouteNames.chatThread,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: ChatThreadScreen(
            contactName: state.uri.queryParameters['contactName'] ?? 'Unknown',
            contactSubtitle: state.uri.queryParameters['contactSubtitle'] ?? '',
            contactAvatar: state.uri.queryParameters['contactAvatar'] ?? '',
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.about,
        name: AppRouteNames.about,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('About - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.terms,
        name: AppRouteNames.terms,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Terms & Conditions - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.privacy,
        name: AppRouteNames.privacy,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Privacy Policy - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.contact,
        name: AppRouteNames.contact,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Contact Us - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      // Service Specific Routes
      GoRoute(
        path: AppRoutes.towingRequest,
        name: AppRouteNames.towingRequest,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Towing Request - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.vehicleDetails,
        name: AppRouteNames.vehicleDetails,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Vehicle Details - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.waterOrder,
        name: AppRouteNames.waterOrder,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Water Order - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.deliveryDetails,
        name: AppRouteNames.deliveryDetails,
        pageBuilder: (context, state) => CustomTransitions.slideTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Delivery Details - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      // Emergency Routes
      GoRoute(
        path: AppRoutes.emergency,
        name: AppRouteNames.emergency,
        pageBuilder: (context, state) => CustomTransitions.scaleTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Emergency - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.emergencyTowing,
        name: AppRouteNames.emergencyTowing,
        pageBuilder: (context, state) => CustomTransitions.scaleTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Emergency Towing - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      // Utility Routes
      GoRoute(
        path: AppRoutes.maintenance,
        name: AppRouteNames.maintenance,
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          child: const Scaffold(
            body: Center(
              child: Text('Maintenance Mode - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
      
      GoRoute(
        path: AppRoutes.noInternet,
        name: AppRouteNames.noInternet,
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          child: const Scaffold(
            body: Center(
              child: Text('No Internet Connection - Coming Soon'),
            ),
          ),
          state: state,
        ),
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri}" could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.onboarding),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    
    // Redirect logic (optional)
    /*redirect: (context, state) async {
      final authService = AuthService();
      final isAuthenticated = await authService.isAuthenticated();
      final currentPath = state.uri.path;
      
      // Define public routes that don't require authentication
      final publicRoutes = [
        AppRoutes.login,
        AppRoutes.signup,
        AppRoutes.otpVerification,
        AppRoutes.forgotPassword,
        '/', // splash
      ];
      
      // If user is not authenticated and trying to access protected route
      if (!isAuthenticated && !publicRoutes.contains(currentPath)) {
        return AppRoutes.login;
      }
      
      // If user is authenticated and trying to access auth routes, redirect to appropriate home
      if (isAuthenticated && (currentPath == AppRoutes.login || currentPath == AppRoutes.signup)) {
        final user = authService.currentUser;
        if (user != null) {
          switch (user.role) {
            case UserRole.customer:
              return AppRoutes.customerHome;
            case UserRole.serviceProvider:
              return AppRoutes.providerHome;
            case UserRole.administrator:
              return AppRoutes.adminDashboard;
          }
        }
        return AppRoutes.customerHome; // Fallback
      }
      
      return null; // No redirect
    },*/
  );

  static GoRouter get router => _router;
}