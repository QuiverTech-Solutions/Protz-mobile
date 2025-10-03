import 'package:flutter/material.dart';
import 'shared/utils/app_router.dart';
import 'auth/services/new_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AuthService
  //await AuthService().initialize();
  
  runApp(const ProtzApp());
}

class ProtzApp extends StatelessWidget {
  const ProtzApp({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
