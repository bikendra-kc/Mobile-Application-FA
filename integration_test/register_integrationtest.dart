import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonts_and_themes/config/router/app_route.dart';
import 'package:fonts_and_themes/features/auth/domain/entity/auth_entity.dart';
import 'package:fonts_and_themes/features/auth/domain/use_case/auth_usecase.dart';
import 'package:fonts_and_themes/features/auth/presentation/viewmodel/auth_view_model.dart';

import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test/unit_testing/auth_test.mocks.dart';



@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthUseCase mockAuthUsecase;

  late UserEntity authEntity;

  setUpAll(
    () async {
      mockAuthUsecase = MockAuthUseCase();

      authEntity = const UserEntity(
      firstName: 'anjal',
      lastName: 'anjal',
      username: 'anjal',
      phoneNumber: "anjal",
        password: 'anjal'
      );
    },
  );

  testWidgets('register view ...', (tester) async {
    when(mockAuthUsecase.registerUser(authEntity))
        .thenAnswer((_) async => const Right(true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(mockAuthUsecase),
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.registerRoute,
          routes: AppRoute.getApplicationRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Enter mnajesh in first textform field

    await tester.enterText(find.byType(TextFormField).at(0), 'anjal');

    // Enter manjesh in second textform field

    await tester.enterText(find.byType(TextFormField).at(1), 'anjal');

    await tester.enterText(find.byType(TextFormField).at(2), 'anjal');

    // Enter phone no

    await tester.enterText(find.byType(TextFormField).at(3), 'anjal');

    // Enter username

    await tester.enterText(
        find.byType(TextFormField).at(4), 'anjal');

  

    //=========================== Find the dropdownformfield===========================

    //=========================== Find the register button===========================

    final registerButtonFinder =
        find.widgetWithText(ElevatedButton, 'Register');

    await tester.tap(registerButtonFinder);

    await tester.pump();

    // Check weather the snackbar is displayed or not

    expect(find.widgetWithText(SnackBar, 'Registered successfully'),
        findsOneWidget);

    // expect(find.text('SIGN IN'), findsOneWidget);
  });
}

// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:harmo_futsal/config/router/app_route.dart';
// import 'package:harmo_futsal/features/auth/domain/entity/student_entity.dart';
// import 'package:harmo_futsal/features/auth/domain/use_case/auth_usecase.dart';
// import 'package:harmo_futsal/features/auth/presentation/viewmodel/auth_view_model.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import '../test/unit_testing/auth_test.mocks.dart';

// @GenerateNiceMocks([
//   MockSpec<AuthUseCase>(),
// ])
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   TestWidgetsFlutterBinding.ensureInitialized();

//   late AuthUseCase mockAuthUsecase;
//   late UserEntity authEntity;

//   setUpAll(
//     () async {
//       mockAuthUsecase = MockAuthUseCase();

//       authEntity = const UserEntity(
//           fname: 'manjesh',
//           lname: 'manjesh',
//           email: 'manjesh@123gmail.com',
//           password: 'manjesh',
//           userName: 'manjesh',
//           phoneNum: 9999999);
//     },
//   );

//   testWidgets('register view ...', (tester) async {
//     when(mockAuthUsecase.registerUser(authEntity))
//         .thenAnswer((_) async => const Right(true));

//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           authViewModelProvider.overrideWith(
//             (ref) => AuthViewModel(mockAuthUsecase),
//           ),
//         ],
//         child: MaterialApp(
//           initialRoute: AppRoute.registerRoute,
//           routes: AppRoute.getApplicationRoute(),
//         ),
//       ),
//     );

//     await tester.pumpAndSettle();

//     await tester.pumpAndSettle();

//     // Enter mnajesh in first textform field

//     await tester.enterText(find.byType(TextFormField).at(0), 'manjesh');

//     // Enter manjesh in second textform field

//     await tester.enterText(find.byType(TextFormField).at(1), 'manjesh');

//     await tester.enterText(find.byType(TextFormField).at(2), 'manjesh');

//     // Enter phone no

//     await tester.enterText(find.byType(TextFormField).at(3), '9999999');

//     // Enter username

//     await tester.enterText(
//         find.byType(TextFormField).at(4), 'manjesh@123gmail.com');

//     // Enter password

//     await tester.enterText(find.byType(TextFormField).at(5), 'manjesh');

//     await tester.enterText(find.byType(TextFormField).at(6), 'manjesh');

//     //=========================== Find the dropdownformfield===========================

//     // Use this because the menu items are not visible
//     await tester.pumpAndSettle();

//     //tap on the first item in the dropdown

//     //=========================== Find the MultiSelectDialogField===========================

//     //=========================== Find the register button===========================
//     final registerButtonFinder =
//         find.widgetWithText(ElevatedButton, 'Register');

//     await tester.tap(registerButtonFinder);

//     await tester.pumpAndSettle();

//     // Check weather the snackbar is displayed or not
//     expect(find.widgetWithText(SnackBar, 'Successfully registered'),
//         findsOneWidget);
//   });
// }
