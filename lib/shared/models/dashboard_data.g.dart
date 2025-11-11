// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      wallet: WalletInfo.fromJson(json['wallet'] as Map<String, dynamic>),
      recentOrders: (json['recentOrders'] as List<dynamic>)
          .map((e) => ServiceRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyProviders: (json['nearbyProviders'] as List<dynamic>)
          .map((e) => ServiceProvider.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeRequests: (json['activeRequests'] as List<dynamic>)
          .map((e) => ServiceRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((e) => Promotion.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceAvailability: ServiceAvailability.fromJson(
          json['serviceAvailability'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'wallet': instance.wallet,
      'recentOrders': instance.recentOrders,
      'nearbyProviders': instance.nearbyProviders,
      'activeRequests': instance.activeRequests,
      'stats': instance.stats,
      'promotions': instance.promotions,
      'serviceAvailability': instance.serviceAvailability,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      isVerified: json['isVerified'] as bool,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'profileImageUrl': instance.profileImageUrl,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'isVerified': instance.isVerified,
    };

WalletInfo _$WalletInfoFromJson(Map<String, dynamic> json) => WalletInfo(
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      recentTransactions: (json['recentTransactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$WalletInfoToJson(WalletInfo instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'currency': instance.currency,
      'recentTransactions': instance.recentTransactions,
      'isActive': instance.isActive,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      referenceId: json['referenceId'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'referenceId': instance.referenceId,
    };

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalOrders: (json['totalOrders'] as num).toInt(),
      completedOrders: (json['completedOrders'] as num).toInt(),
      activeOrders: (json['activeOrders'] as num).toInt(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      currency: json['currency'] as String,
      favoriteProviders: (json['favoriteProviders'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'totalOrders': instance.totalOrders,
      'completedOrders': instance.completedOrders,
      'activeOrders': instance.activeOrders,
      'totalSpent': instance.totalSpent,
      'currency': instance.currency,
      'favoriteProviders': instance.favoriteProviders,
    };

Promotion _$PromotionFromJson(Map<String, dynamic> json) => Promotion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      discountCode: json['discountCode'] as String?,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'discountCode': instance.discountCode,
      'discountPercentage': instance.discountPercentage,
      'isActive': instance.isActive,
    };

ServiceAvailability _$ServiceAvailabilityFromJson(Map<String, dynamic> json) =>
    ServiceAvailability(
      towingAvailable: json['towingAvailable'] as bool,
      waterDeliveryAvailable: json['waterDeliveryAvailable'] as bool,
      maintenanceMessage: json['maintenanceMessage'] as String?,
      estimatedWaitTimes:
          Map<String, int>.from(json['estimatedWaitTimes'] as Map),
    );

Map<String, dynamic> _$ServiceAvailabilityToJson(
        ServiceAvailability instance) =>
    <String, dynamic>{
      'towingAvailable': instance.towingAvailable,
      'waterDeliveryAvailable': instance.waterDeliveryAvailable,
      'maintenanceMessage': instance.maintenanceMessage,
      'estimatedWaitTimes': instance.estimatedWaitTimes,
    };
