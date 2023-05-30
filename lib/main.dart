import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'view/dashboard.dart';
import 'view/login.dart';
import 'view/register.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Fonts and Theme',
    theme: AppTheme.getApplicationTheme(),
    home: const MyLogin(),
    routes: {
      '/register': (context) => const MyRegister(),
      '/login': (context) => const MyLogin(),
      '/dashboard':((context) =>  const DashboardView())
    },
  ));
}