import 'package:fonts_and_themes/features/auth/presentation/view/login_view.dart';
import 'package:fonts_and_themes/features/auth/presentation/view/register_view.dart';
import 'package:fonts_and_themes/features/home/presentation/view/home_view.dart';
import 'package:fonts_and_themes/features/splash/presentation/view/splash_view.dart';

import '../../features/auth/presentation/view/dashboard_view.dart';

class AppRoute{
  AppRoute._();
  static const String splashRoute = '/splash';
  static const String loginRoute = '/signIn';
  static const String registerRoute = '/signUp';
  static const String homeRoute = '/home';

  static getApplicationRoute(){
    return{
      splashRoute: (context) => const SplashView(),
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      homeRoute: (context) => const DashboardView(),
      
    };
  }
}