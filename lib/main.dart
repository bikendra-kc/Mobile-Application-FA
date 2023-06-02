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
    home: MyLogin(),
    routes: {
      '/register': (context) => MyRegister(),
      '/login': (context) => MyLogin(),
      '/dashboard':((context) => MyDashboard())
    },
  ));
}