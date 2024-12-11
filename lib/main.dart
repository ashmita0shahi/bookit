import 'package:bookit/app.dart';
import 'package:bookit/view/dashboard.dart';
import 'package:bookit/view/login_page.dart';
import 'package:bookit/view/register_page.dart';
import 'package:bookit/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes: {
        '/sp': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        "/": (context) => RegisterPage(),
        "/dashboard": (context) => Dashboard(),
      }));
}
