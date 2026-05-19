import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'viewmodels/app_viewmodel.dart';
import 'views/screens/main_navigation_screen.dart';
import 'views/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppViewModel()),
      ],
      child: const SiluetApp(),
    ),
  );
}

class SiluetApp extends StatelessWidget {
  const SiluetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siluet Attire',
      theme: AppTheme.premiumDarkTheme,
      home: Consumer<AppViewModel>(
        builder: (context, vm, child) {
          if (vm.currentUser == null) {
            return const AuthScreen();
          }
          return const MainNavigationScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

