import 'package:flutter/material.dart';
import 'package:flutter_app/view/dashboard.dart';

import 'view/login.dart';
import 'view/register.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      '/register': (context) => MyRegister(),
      '/login': (context) => MyLogin(),
      '/dashboard':((context) => MyDashboard())
    },
  ));
}