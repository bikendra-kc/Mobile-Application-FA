import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonts_and_themes/config/router/app_route.dart';
import 'package:fonts_and_themes/features/auth/domain/use_case/auth_usecase.dart';
import 'package:fonts_and_themes/features/auth/presentation/viewmodel/auth_view_model.dart';
import "package:integration_test/integration_test.dart";
import 'package:mockito/mockito.dart';

import '../test/unit_testing/auth_test.mocks.dart';



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AuthUseCase mockAuthUsecase;

  //we are doing this for dashboard

  late bool isLogin;

  setUpAll(() async {
    mockAuthUsecase = MockAuthUseCase();
    isLogin = true;
  });

  testWidgets('login test with username and password and open dashboard',
      (WidgetTester tester) async {
    when(mockAuthUsecase.loginUser('manjesh', 'silwal'))
        .thenAnswer((_) async => Right(isLogin));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider
              .overrideWith((ref) => AuthViewModel(mockAuthUsecase)),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.loginRoute,
          routes: AppRoute.getApplicationRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'manjesh');

    await tester.enterText(find.byType(TextFormField).at(1), 'silwal');

    await tester.tap(
      find.widgetWithText(
        ElevatedButton,
        'Login',
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text( 'Dashboard'), findsOneWidget);
  });
}