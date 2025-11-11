import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/utils/app_router.dart';
import 'auth/services/new_auth_service.dart';
import 'shared/services/api_service.dart';
import 'customer/core/utils/size_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await AuthService().initialize();
  ApiService().initialize();
  
  runApp(const ProviderScope(child: ProtzApp()));
}

class ProtzApp extends StatelessWidget {
  const ProtzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: 'Protz',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF086788),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            fontFamily: 'SF Pro Display', // You can change this to your preferred font
          ),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
