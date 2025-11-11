import 'package:json_annotation/json_annotation.dart';
import 'service_request.dart';
import 'service_provider.dart';

part 'dashboard_data.g.dart';

/// Model representing dashboard data for the home screen
/// 
/// This model encapsulates all data needed for the dashboard
/// including user info, recent orders, wallet balance, and available services.
@JsonSerializable()
class DashboardData {
  /// User information
  final UserInfo user;
  
  /// Wallet balance information
  final WalletInfo wallet;
  
  /// Recent service requests/orders
  final List<ServiceRequest> recentOrders;
  
  /// Available service providers nearby
  final List<ServiceProvider> nearbyProviders;
  
  /// Active/ongoing requests
  final List<ServiceRequest> activeRequests;
  
  /// Dashboard statistics
  final DashboardStats stats;
  
  /// Promotional offers or announcements
  final List<Promotion>? promotions;
  
  /// Service availability status
  final ServiceAvailability serviceAvailability;

  const DashboardData({
    required this.user,
    required this.wallet,
    required this.recentOrders,
    required this.nearbyProviders,
    required this.activeRequests,
    required this.stats,
    this.promotions,
    required this.serviceAvailability,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);
}

/// User information model
@JsonSerializable()
class UserInfo {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime? lastLoginAt;
  final bool isVerified;

  const UserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.lastLoginAt,
    required this.isVerified,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

/// Wallet information model
@JsonSerializable()
class WalletInfo {
  final double balance;
  final String currency;
  final List<Transaction> recentTransactions;
  final bool isActive;

  const WalletInfo({
    required this.balance,
    required this.currency,
    required this.recentTransactions,
    required this.isActive,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WalletInfoToJson(this);
}

/// Transaction model
@JsonSerializable()
class Transaction {
  final String id;
  final double amount;
  final String type; // credit, debit
  final String description;
  final DateTime createdAt;
  final String? referenceId;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
    this.referenceId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

/// Dashboard statistics model
@JsonSerializable()
class DashboardStats {
  final int totalOrders;
  final int completedOrders;
  final int activeOrders;
  final double totalSpent;
  final String currency;
  final int favoriteProviders;

  const DashboardStats({
    required this.totalOrders,
    required this.completedOrders,
    required this.activeOrders,
    required this.totalSpent,
    required this.currency,
    required this.favoriteProviders,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}

/// Promotion model
@JsonSerializable()
class Promotion {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String? discountCode;
  final double? discountPercentage;
  final bool isActive;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.startDate,
    required this.endDate,
    this.discountCode,
    this.discountPercentage,
    required this.isActive,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) =>
      _$PromotionFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);
}

/// Service availability model
@JsonSerializable()
class ServiceAvailability {
  final bool towingAvailable;
  final bool waterDeliveryAvailable;
  final String? maintenanceMessage;
  final Map<String, int> estimatedWaitTimes; // service type -> minutes

  const ServiceAvailability({
    required this.towingAvailable,
    required this.waterDeliveryAvailable,
    this.maintenanceMessage,
    required this.estimatedWaitTimes,
  });

  factory ServiceAvailability.fromJson(Map<String, dynamic> json) =>
      _$ServiceAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAvailabilityToJson(this);
}