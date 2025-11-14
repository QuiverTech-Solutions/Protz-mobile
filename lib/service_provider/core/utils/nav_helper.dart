import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/utils/pages.dart';

class ProviderNav {
  static String currentLocation(BuildContext context) {
    final router = GoRouter.of(context);
    try {
      return router.routeInformationProvider.value.location ?? '/';
    } catch (_) {
      return '/';
    }
  }

  static int indexForLocation(String location) {
    if (location.startsWith(AppRoutes.providerHome) || location.startsWith(AppRoutes.providerWaterHome)) {
      return 0;
    }
    if (location.startsWith(AppRoutes.jobRequests)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.chatInbox) || location.startsWith(AppRoutes.chat)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.earnings)) {
      return 3;
    }
    if (location.startsWith(AppRoutes.providerProfile)) {
      return 4;
    }
    return 0;
  }

  static void goToIndex(BuildContext context, int index, {bool isWaterHome = false}) {
    switch (index) {
      case 0:
        context.go(isWaterHome ? AppRoutes.providerWaterHome : AppRoutes.providerHome);
        break;
      case 1:
        context.go(AppRoutes.jobRequests);
        break;
      case 2:
        context.go(AppRoutes.chatInbox);
        break;
      case 3:
        context.go(AppRoutes.earnings);
        break;
      case 4:
        context.go(AppRoutes.providerProfile);
        break;
      default:
        context.go(AppRoutes.providerHome);
        break;
    }
  }
}