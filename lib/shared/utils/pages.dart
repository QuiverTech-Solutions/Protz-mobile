import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Authentication Screens
export '../../auth/screens/splash_screen.dart';
export '../../auth/screens/onboarding_screen.dart';
export '../../auth/screens/login_screen.dart';
export '../../auth/screens/signup_selection_screen.dart';
export '../../auth/screens/signup_screen.dart';
export '../../auth/screens/otp_verification_screen.dart';
export '../../auth/screens/forgot_password_screen.dart';

// Customer Screens
//export '../../customer/screens/towing_services_dashboard.dart';
export '../../customer/screens/towing_services_dashboard_screen/towing_services_screen_1.dart';
export '../../customer/screens/towing_services_dashboard_screen/towing_services_screen_2.dart';
export '../../customer/screens/towing_services_dashboard_screen/towing_services_screen_3.dart';
export '../../customer/screens/towing_services_dashboard_screen/towing_checkout.dart';

// export '../../customer/screens/booking_screen.dart';
// export '../../customer/screens/tracking_screen.dart';
// export '../../customer/screens/payment_screen.dart';
// export '../../customer/screens/history_screen.dart';
// export '../../customer/screens/profile_screen.dart';
export '../../customer/screens/acount_screens/profile_screen.dart';
export '../../customer/screens/acount_screens/security_password_screen.dart';
export '../../customer/screens/notifications_screen.dart';
export '../../customer/screens/acount_screens/wallet_screen.dart';
export '../../customer/screens/acount_screens/add_mobile_money_screen.dart';
export '../../customer/screens/acount_screens/add_card_screen.dart';
// export '../../customer/screens/chat_screen.dart';

// Provider Screens
// Service Provider Screens
export '../../service_provider/screens/document_verification_screen.dart';
export '../../service_provider/screens/wallet_setup_screen.dart';

// Admin Screens
// TODO: Add admin screens when created
// export '../../admin/screens/admin_dashboard_screen.dart';
// export '../../admin/screens/user_management_screen.dart';
// export '../../admin/screens/booking_management_screen.dart';
// export '../../admin/screens/financial_reports_screen.dart';
// export '../../admin/screens/analytics_screen.dart';

// Shared Screens
// TODO: Add shared screens when created
// export '../../shared/screens/settings_screen.dart';
// export '../../shared/screens/help_screen.dart';
// export '../../shared/screens/about_screen.dart';
// export '../../shared/screens/terms_screen.dart';
// export '../../shared/screens/privacy_screen.dart';
// export '../../shared/screens/contact_screen.dart';

// Service Specific Screens
// TODO: Add service specific screens when created
// export '../../services/towing/screens/towing_request_screen.dart';
// export '../../services/towing/screens/vehicle_details_screen.dart';
// export '../../services/water_delivery/screens/water_order_screen.dart';
// export '../../services/water_delivery/screens/delivery_details_screen.dart';

// GoRouter Route Names and Paths
class AppRoutes {
  // Authentication Routes
  static const String login = '/login';
  static const String signupSelection = '/signup-selection';
  static const String signup = '/signup';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordOtp = '/forgot-password-otp';
  static const String newPassword = '/new-password';
  
  // Onboarding Routes
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  
  // Customer Routes
  static const String customerHome = '/customer';
  static const String booking = '/customer/booking';
  static const String tracking = '/customer/tracking';
  static const String payment = '/customer/payment';
  static const String history = '/customer/history';
  static const String accountSettings = '/customer/account';
  static const String customerProfile = '/customer/profile';
  static const String wallet = '/customer/wallet';
  static const String addMobileMoney = '/customer/add-mobile-money';
  static const String addCard = '/customer/add-card';
  static const String chat = '/customer/chat';
  static const String chatInbox = '/customer/chat-inbox';
  static const String chatThread = '/customer/chat-thread';
  static const String notifications = '/customer/notifications';
  static const String deleteAccount = '/customer/delete-account';
  
  // Provider Routes
  static const String providerHome = '/provider';
  static const String jobRequests = '/provider/job-requests';
  static const String activeJob = '/provider/active-job';
  static const String earnings = '/provider/earnings';
  static const String providerProfile = '/provider/profile';
  static const String documents = '/provider/documents';
  static const String availability = '/provider/availability';
  static const String providerWalletSetup = '/provider/wallet/setup';
  
  // Admin Routes
  static const String adminDashboard = '/admin';
  static const String userManagement = '/admin/users';
  static const String bookingManagement = '/admin/bookings';
  static const String financialReports = '/admin/reports';
  static const String analytics = '/admin/analytics';
  
  // Shared Routes
  static const String settings = '/settings';
  static const String help = '/help';
  static const String about = '/about';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String contact = '/contact';
  
  // Service Specific Routes
  static const String towingRequest = '/services/towing/request';
  static const String vehicleDetails = '/services/towing/vehicle-details';
  static const String towingServicesScreen1 = '/towing-services/screen1';
  static const String towingServicesScreen2 = '/towing-services/screen2';
  static const String towingServicesScreen3 = '/towing-services/screen3';
  static const String towingCheckout = '/towing-services/checkout';
  static const String waterOrder = '/services/water/order';
  static const String deliveryDetails = '/services/water/delivery-details';
  
  // Emergency Routes
  static const String emergency = '/emergency';
  static const String emergencyTowing = '/emergency/towing';
  
  // Utility Routes
  static const String splash = '/';
  static const String maintenance = '/maintenance';
  static const String noInternet = '/no-internet';

  static const String waterDeliveryScreen2 = '/water-delivery-screen2';

  static const String waterDeliveryScreen1 = '/water-delivery-screen1';
}

// GoRouter Route Names (for named navigation)
class AppRouteNames {
  // Authentication Route Names
  static const String login = 'login';
  static const String signupSelection = 'signup-selection';
  static const String signup = 'signup';
  static const String otpVerification = 'otp-verification';
  static const String forgotPassword = 'forgot-password';
  static const String forgotPasswordOtp = 'forgot-password-otp';
  static const String newPassword = 'new-password';
  
  // Onboarding Route Names
  static const String onboarding = 'onboarding';
  static const String welcome = 'welcome';
  
  // Customer Route Names
  static const String customerHome = 'customer-home';
  static const String booking = 'booking';
  static const String tracking = 'tracking';
  static const String payment = 'payment';
  static const String history = 'history';
  static const String accountSettings = 'account-settings';
  static const String customerProfile = 'customer-profile';
  static const String wallet = 'wallet';
  static const String addMobileMoney = 'add-mobile-money';
  static const String addCard = 'add-card';
  static const String chat = 'chat';
  static const String chatInbox = 'chat-inbox';
  static const String chatThread = 'chat-thread';
  static const String notifications = 'notifications';
  static const String deleteAccount = 'delete-account';
  
  // Provider Route Names
  static const String providerHome = 'provider-home';
  static const String jobRequests = 'job-requests';
  static const String activeJob = 'active-job';
  static const String earnings = 'earnings';
  static const String providerProfile = 'provider-profile';
  static const String documents = 'documents';
  static const String availability = 'availability';
  static const String providerWalletSetup = 'provider-wallet-setup';
  
  // Admin Route Names
  static const String adminDashboard = 'admin-dashboard';
  static const String userManagement = 'user-management';
  static const String bookingManagement = 'booking-management';
  static const String financialReports = 'financial-reports';
  static const String analytics = 'analytics';
  
  // Shared Route Names
  static const String settings = 'settings';
  static const String help = 'help';
  static const String about = 'about';
  static const String terms = 'terms';
  static const String privacy = 'privacy';
  static const String contact = 'contact';
  
  // Service Specific Route Names
  static const String towingRequest = 'towing-request';
  static const String vehicleDetails = 'vehicle-details';
  static const String towingServicesScreen1 = 'towing-services-screen1';
  static const String towingServicesScreen2 = 'towing-services-screen2';
  static const String towingServicesScreen3 = 'towing-services-screen3';
  static const String towingCheckout = 'towing-services-checkout';
  static const String waterOrder = 'water-order';
  static const String deliveryDetails = 'delivery-details';
  
  // Emergency Route Names
  static const String emergency = 'emergency';
  static const String emergencyTowing = 'emergency-towing';
  
  // Utility Route Names
  static const String splash = 'splash';
  static const String maintenance = 'maintenance';
  static const String noInternet = 'no-internet';

  static const String waterDeliveryScreen2 = 'water-delivery-screen2';

  static const String waterDeliveryScreen1 = 'water-delivery-screen1';
}

// GoRouter Navigation Helper Class
class GoRouterHelper {
  static const Duration defaultTransitionDuration = Duration(milliseconds: 300);
  
  // Navigation methods using GoRouter
  static void go(BuildContext context, String location) {
    context.go(location);
  }
  
  static Future<T?> push<T extends Object?>(BuildContext context, String location) {
    return context.push<T>(location);
  }
  
  static void goNamed(BuildContext context, String name, {Map<String, String> pathParameters = const {}, Map<String, dynamic> queryParameters = const {}}) {
    context.goNamed(name, pathParameters: pathParameters, queryParameters: queryParameters);
  }
  
  static Future<T?> pushNamed<T extends Object?>(BuildContext context, String name, {Map<String, String> pathParameters = const {}, Map<String, dynamic> queryParameters = const {}}) {
    return context.pushNamed<T>(name, pathParameters: pathParameters, queryParameters: queryParameters);
  }
  
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    context.pop<T>(result);
  }
  
  static bool canPop(BuildContext context) {
    return context.canPop();
  }
  
  static void pushReplacement(BuildContext context, String location) {
    context.pushReplacement(location);
  }
  
  static void pushReplacementNamed(BuildContext context, String name, {Map<String, String> pathParameters = const {}, Map<String, dynamic> queryParameters = const {}}) {
    context.pushReplacementNamed(name, pathParameters: pathParameters, queryParameters: queryParameters);
  }
}

// Custom Page Transitions for GoRouter
class CustomTransitions {
  static CustomTransitionPage slideTransition({
    required Widget child,
    required GoRouterState state,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: begin, end: end).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        );
      },
    );
  }
  
  static CustomTransitionPage fadeTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(
            CurveTween(curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
    );
  }
  
  static CustomTransitionPage scaleTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        );
      },
    );
  }
}