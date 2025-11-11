# Riverpod Providers Documentation

This directory contains all the Riverpod providers used for state management in the Protz application.

## Provider Files

### 1. api_service_provider.dart
**Purpose**: Provides a singleton instance of the ApiService for making HTTP requests.

**Providers**:
- `apiService`: Returns a singleton ApiService instance configured with base URL and interceptors.

**Usage**:
```dart
final apiService = ref.read(apiServiceProvider);
final response = await apiService.getDashboardData();
```

### 2. dashboard_provider.dart
**Purpose**: Manages the home screen dashboard state including user info, wallet, and recent orders.

**Providers**:
- `dashboardProvider`: Main provider that fetches and manages dashboard data
- `userInfoProvider`: Extracts user information from dashboard data
- `walletInfoProvider`: Extracts wallet information from dashboard data
- `recentOrdersProvider`: Extracts recent orders from dashboard data
- `serviceAvailabilityProvider`: Extracts service availability from dashboard data

**State Management**:
- Uses `DashboardState` to handle loading, success, and error states
- Automatically loads data when first accessed
- Provides refresh functionality
- Handles API errors gracefully

**Usage**:
```dart
// Watch dashboard state
final dashboardState = ref.watch(dashboardProvider);

// Handle different states
dashboardState.when(
  data: (dashboardData) => YourWidget(data: dashboardData),
  loading: () => CircularProgressIndicator(),
  error: (error, stackTrace) => ErrorWidget(error),
);

// Refresh data
ref.refresh(dashboardProvider);

// Access specific data
final userInfo = ref.watch(userInfoProvider);
final walletInfo = ref.watch(walletInfoProvider);
```

### 3. service_providers_provider.dart
**Purpose**: Manages service provider data with location-based filtering capabilities.

**Providers**:
- `serviceProvidersProvider`: Main provider for fetching service providers with parameters
- `towingProvidersProvider`: Convenience provider for towing service providers
- `waterDeliveryProvidersProvider`: Convenience provider for water delivery providers

**Parameters**:
- `ServiceProvidersParams`: Contains service type, location coordinates, and radius for filtering

**State Management**:
- Uses `ServiceProvidersState` to handle loading, success, and error states
- Supports location-based filtering
- Provides refresh and reload functionality

**Usage**:
```dart
// Fetch providers with parameters
final params = ServiceProvidersParams(
  serviceType: 'towing',
  latitude: 5.6037,
  longitude: -0.1870,
  radius: 10.0,
);
final providersState = ref.watch(serviceProvidersProvider(params));

// Use convenience providers
final towingProviders = ref.watch(towingProvidersProvider);
final waterProviders = ref.watch(waterDeliveryProvidersProvider);

// Refresh providers
ref.refresh(serviceProvidersProvider(params));
```

## Best Practices

1. **Error Handling**: All providers include proper error handling and return meaningful error states.

2. **Loading States**: Use the `.when()` method to handle loading, data, and error states appropriately.

3. **Data Refresh**: Use `ref.refresh()` to manually refresh provider data when needed.

4. **Memory Management**: Providers automatically dispose of resources when no longer needed.

5. **Type Safety**: All providers are strongly typed with proper model classes.

## Integration with UI

The providers are designed to work seamlessly with Flutter widgets:

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    
    return dashboardState.when(
      data: (data) => YourSuccessWidget(data),
      loading: () => YourLoadingWidget(),
      error: (error, stack) => YourErrorWidget(error),
    );
  }
}
```

## Dependencies

- `flutter_riverpod`: State management framework
- `riverpod_annotation`: Code generation for providers
- Custom models: `DashboardData`, `ServiceProvider`, `ServiceRequest`
- Custom services: `ApiService`