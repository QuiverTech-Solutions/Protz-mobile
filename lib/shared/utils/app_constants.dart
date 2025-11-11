class AppConstants {
  // App Information
  static const String appName = 'Protz';
  static const String appVersion = '1.0.0';
  static const String appDescription = '24/7 towing and water delivery services';

  // Color Scheme
  // Primary Colors
  static const int primaryColorValue = 0xFF086788;
  static const int primaryLightColorValue = 0xFF40A4C4;
  static const int primaryDarkColorValue = 0xFF064B5C;
  static const int primaryVariantColorValue = 0xFF0A7A96;
  
  // Secondary Colors
  static const int secondaryColorValue = 0xFF40E0D0;
  static const int secondaryLightColorValue = 0xFF7FEBE0;
  static const int secondaryDarkColorValue = 0xFF2DB5A8;
  static const int secondaryVariantColorValue = 0xFF36C9B8;
  
  // Background Colors
  static const int backgroundColorValue = 0xFFE8F4F8;
  static const int backgroundLightColorValue = 0xFFF8FCFD;
  static const int backgroundDarkColorValue = 0xFFD4E8ED;
  static const int surfaceColorValue = 0xFFFFFFFF;
  static const int surfaceVariantColorValue = 0xFFF4FAFB;
  
  // Text Colors
  static const int textPrimaryColorValue = 0xFF2B2930;
  static const int textSecondaryColorValue = 0xFF605D64;
  static const int textTertiaryColorValue = 0xFF9CA3AF;
  static const int textOnPrimaryColorValue = 0xFFFFFFFF;
  static const int textOnSecondaryColorValue = 0xFF2B2930;
  static const int textDisabledColorValue = 0xFFBDBDBD;
  
  // Status Colors
  static const int errorColorValue = 0xFFE74C3C;
  static const int errorLightColorValue = 0xFFFFEBEE;
  static const int errorDarkColorValue = 0xFFC62828;
  static const int successColorValue = 0xFF27AE60;
  static const int successLightColorValue = 0xFFE8F5E8;
  static const int successDarkColorValue = 0xFF1B5E20;
  static const int warningColorValue = 0xFFF39C12;
  static const int warningLightColorValue = 0xFFFFF3E0;
  static const int warningDarkColorValue = 0xFFE65100;
  static const int infoColorValue = 0xFF2196F3;
  static const int infoLightColorValue = 0xFFE3F2FD;
  static const int infoDarkColorValue = 0xFF0D47A1;
  
  // Border Colors
  static const int borderColorValue = 0xFFD1D5DB;
  static const int borderLightColorValue = 0xFFE5E7EB;
  static const int borderDarkColorValue = 0xFF9CA3AF;
  static const int dividerColorValue = 0xFFE0E0E0;
  
  // Shadow Colors
  static const int shadowColorValue = 0x1A000000;
  static const int shadowLightColorValue = 0x0D000000;
  static const int shadowDarkColorValue = 0x33000000;
  
  // Overlay Colors
  static const int overlayColorValue = 0x80000000;
  static const int overlayLightColorValue = 0x40000000;
  static const int overlayDarkColorValue = 0xB3000000;
  
  // Gradient Colors
  static const List<int> primaryGradientColors = [0xFF086788, 0xFF40A4C4];
  static const List<int> secondaryGradientColors = [0xFF40E0D0, 0xFF7FEBE0];
  static const List<int> backgroundGradientColors = [0xFFE8F4F8, 0xFFF8FCFD];
  
  // Service-specific Colors
  static const int towingServiceColorValue = 0xFFFF6B35;
  static const int waterDeliveryServiceColorValue = 0xFF4ECDC4;
  static const int emergencyColorValue = 0xFFFF4757;
  
  // Rating Colors
  static const int ratingStarColorValue = 0xFFFFD700;
  static const int ratingEmptyStarColorValue = 0xFFE0E0E0;
  
  // Map Colors
  static const int mapPrimaryColorValue = 0xFF086788;
  static const int mapSecondaryColorValue = 0xFF40E0D0;
  static const int mapRouteColorValue = 0xFF2196F3;
  static const int mapMarkerColorValue = 0xFFFF4757;

  // API Configuration
  static const String baseUrl = 'https://protz-d3f3c6008874.herokuapp.com/api/v1';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Authentication
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
  static const Duration tokenExpiryDuration = Duration(hours: 24);

  // User Roles
  static const String customerRole = 'user';
  static const String providerRole = 'service_provider';
  static const String adminRole = 'admin';

  // Service Types
  static const String towingService = 'towing';
  static const String waterDeliveryService = 'water_delivery';

  // Booking Status
  static const String bookingPending = 'pending';
  static const String bookingAccepted = 'accepted';
  static const String bookingInProgress = 'in_progress';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';

  // Payment Methods
  static const String mtnMoney = 'mtn_money';
  static const String vodafoneCash = 'vodafone_cash';
  static const String airtelTigo = 'airteltigo_money';
  static const String bankCard = 'bank_card';
  static const String inAppWallet = 'in_app_wallet';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const String phoneRegex = r'^\+233[0-9]{9}$';
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Map Configuration
  static const double defaultLatitude = 5.6037;
  static const double defaultLongitude = -0.1870;
  static const double defaultZoom = 15.0;
  static const double trackingZoom = 18.0;

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);

  // Notification Types
  static const String bookingNotification = 'booking';
  static const String paymentNotification = 'payment';
  static const String systemNotification = 'system';
  static const String promotionNotification = 'promotion';

  // Error Messages
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
  static const String validationError = 'Please check your input and try again.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String registrationSuccess = 'Registration successful!';
  static const String bookingSuccess = 'Booking created successfully!';
  static const String paymentSuccess = 'Payment completed successfully!';

  // Timeouts and Delays
  static const Duration splashScreenDuration = Duration(seconds: 3);
  static const Duration otpTimeout = Duration(minutes: 5);
  static const Duration locationUpdateInterval = Duration(seconds: 10);
  static const Duration autoLogoutDuration = Duration(minutes: 30);

  // Rating System
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double defaultRating = 0.0;

  // Commission Rates (in percentage)
  static const double towingCommissionRate = 15.0;
  static const double waterDeliveryCommissionRate = 10.0;

  // Distance and Pricing
  static const double maxServiceRadius = 50.0; // kilometers
  static const double baseFare = 10.0; // GHS
  static const double perKmRate = 2.0; // GHS per km

  // Emergency Settings
  static const String emergencyNumber = '191';
  static const Duration emergencyResponseTime = Duration(minutes: 15);

  // App Store Links
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.protz.app';
  static const String appStoreUrl = 'https://apps.apple.com/app/protz/id123456789';

  // Social Media
  static const String facebookUrl = 'https://facebook.com/protzapp';
  static const String twitterUrl = 'https://twitter.com/protzapp';
  static const String instagramUrl = 'https://instagram.com/protzapp';

  // Support
  static const String supportEmail = 'support@protz.com';
  static const String supportPhone = '+233123456789';
  static const String privacyPolicyUrl = 'https://protz.com/privacy';
  static const String termsOfServiceUrl = 'https://protz.com/terms';
}