import 'package:bookit/core/app_theme/app_theme.dart';
import 'package:bookit/view/dashboard.dart';
import 'package:bookit/view/login_page.dart';
import 'package:bookit/view/register_page.dart';
import 'package:bookit/view/splash_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: "/",
        theme: getApplicationTheme(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          "/register": (context) => const RegisterPage(),
          "/dashboard": (context) => const Dashboard(),
        });
  }
}
