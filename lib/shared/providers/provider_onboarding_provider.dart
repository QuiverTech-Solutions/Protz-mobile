import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderOnboardingState {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? password;
  final String? serviceTypeCode;
  final String? businessName;
  final String? licenseType;
  final String? licenseNumber;
  final String? vehicleRegistration;
  final String? insurancePolicy;
  final String? city;
  final String? state;
  final int licenseUploadCount;
  final int registrationUploadCount;
  final int photosUploadCount;
  final int insuranceUploadCount;
  final String? walletPin;

  const ProviderOnboardingState({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.password,
    this.serviceTypeCode,
    this.businessName,
    this.licenseType,
    this.licenseNumber,
    this.vehicleRegistration,
    this.insurancePolicy,
    this.city,
    this.state,
    this.licenseUploadCount = 0,
    this.registrationUploadCount = 0,
    this.photosUploadCount = 0,
    this.insuranceUploadCount = 0,
    this.walletPin,
  });

  ProviderOnboardingState copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? password,
    String? serviceTypeCode,
    String? businessName,
    String? licenseType,
    String? licenseNumber,
    String? vehicleRegistration,
    String? insurancePolicy,
    String? city,
    String? state,
    int? licenseUploadCount,
    int? registrationUploadCount,
    int? photosUploadCount,
    int? insuranceUploadCount,
    String? walletPin,
  }) {
    return ProviderOnboardingState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      serviceTypeCode: serviceTypeCode ?? this.serviceTypeCode,
      businessName: businessName ?? this.businessName,
      licenseType: licenseType ?? this.licenseType,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      vehicleRegistration: vehicleRegistration ?? this.vehicleRegistration,
      insurancePolicy: insurancePolicy ?? this.insurancePolicy,
      city: city ?? this.city,
      state: state ?? this.state,
      licenseUploadCount: licenseUploadCount ?? this.licenseUploadCount,
      registrationUploadCount:
          registrationUploadCount ?? this.registrationUploadCount,
      photosUploadCount: photosUploadCount ?? this.photosUploadCount,
      insuranceUploadCount: insuranceUploadCount ?? this.insuranceUploadCount,
      walletPin: walletPin ?? this.walletPin,
    );
  }
}

class ProviderOnboardingNotifier extends StateNotifier<ProviderOnboardingState> {
  ProviderOnboardingNotifier() : super(const ProviderOnboardingState());

  void setUserBasics({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );
  }

  void setServiceSelection(String code) {
    state = state.copyWith(serviceTypeCode: code);
  }

  void setUploads({
    required int licenseCount,
    required int registrationCount,
    required int photosCount,
    required int insuranceCount,
  }) {
    state = state.copyWith(
      licenseUploadCount: licenseCount,
      registrationUploadCount: registrationCount,
      photosUploadCount: photosCount,
      insuranceUploadCount: insuranceCount,
    );
  }

  void setBusinessName(String name) {
    state = state.copyWith(businessName: name);
  }

  void setDocumentFields({
    String? licenseType,
    String? licenseNumber,
    String? vehicleRegistration,
    String? insurancePolicy,
    String? city,
    String? spState,
  }) {
    state = state.copyWith(
      licenseType: licenseType,
      licenseNumber: licenseNumber,
      vehicleRegistration: vehicleRegistration,
      insurancePolicy: insurancePolicy,
      city: city,
      state: spState,
    );
  }

  void setWalletPin(String pin) {
    state = state.copyWith(walletPin: pin);
  }

  void reset() {
    state = const ProviderOnboardingState();
  }
}

final providerOnboardingProvider =
    StateNotifierProvider<ProviderOnboardingNotifier, ProviderOnboardingState>(
        (ref) => ProviderOnboardingNotifier());