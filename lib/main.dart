// import 'package:flutter/material.dart';

// import 'theme/app_theme.dart';
// import 'features/splish/view/dashboard.dart';
// import 'features/splish/view/login.dart';
// import 'features/splish/view/register.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:hive_and_api_for_class/core/app.dart';
// import 'package:hive_and_api_for_class/core/network/local/hive_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // HiveService().init();
  // HiveService().deleteHive();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}