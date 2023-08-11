import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_managent/core/failure/failure.dart';

import 'package:flutter_library_managent/core/network/remote/http_service.dart';
import 'package:flutter_library_managent/core/shared_prefs/user_shared_prefs.dart';
import 'package:flutter_library_managent/features/Home/data/datasource/remote_data_source.dart'
    as HomeDataSource;
import 'package:flutter_library_managent/features/auth/data/datasource/remote_data_source.dart'
    as AuthDataSource;
import 'package:flutter_library_managent/features/auth/data/model/user_model.dart';
import 'package:flutter_library_managent/features/profile/data/datasource/remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Auth Remote Data Source tests', () {
    late AuthDataSource.AuthRemoteDataSource dataSource;
    late ProfileRemoteDataSource psource;
    late Dio dio;
    late HttpService httpService;
    late UserSharedPrefs userSharedPrefs;

    setUp(() async {
      dio = Dio();
      httpService = HttpService(dio);
      userSharedPrefs = UserSharedPrefs();
      dataSource = AuthDataSource.AuthRemoteDataSource(
        dio: dio,
        userSharedPrefs: userSharedPrefs,
      );
      psource = ProfileRemoteDataSource(
        dio: dio,
        userSharedPrefs: userSharedPrefs,
      );
    });

    test('loginStudent returns a Right bool if successful', () async {
      String username = 'kcbikey7@gmail.com';
      String password = 'manjeshD36#';
      Either<AppException, bool> result =
          await dataSource.loginStudent(username, password);
      expect(result.isRight(), true);
    });

    test('loginStudent returns a Left AppException if unsuccessful', () async {
      Either<AppException, bool> result =
          await dataSource.loginStudent('invalid', 'password');

      expect(result.isLeft(), true);
      expect(result.fold((left) => left, (right) => null), isA<AppException>());
    });

    test('registerStudent returns a Right bool if successful', () async {
      UserModel user = UserModel(
        email: 'fffyy@gmail.com',
        password: 'test123456@',
        name: 'Test Register',
      );
      Either<AppException, bool> result =
          await dataSource.registerStudent(user);

      expect(result.isRight(), true);
    });

    test('registerStudent returns a Left AppException if unsuccessful',
        () async {
      UserModel user = UserModel(
        email: '',
        password: 'password',
        name: 'name',
      );
      Either<AppException, bool> result =
          await dataSource.registerStudent(user);

      expect(result.isLeft(), true);
      expect(result.fold((left) => left, (right) => null), isA<AppException>());
    });

    test('update userprofile returns a Left AppException if unsuccessful',
        () async {
      UserModel user = UserModel(
        email: 'test@gmailcom',
        name: 'test123',
      );
      Either<AppException, bool> result = await psource.updateUserProfile(user);
      expect(result.isLeft(), true);
    });

    test('change password returns a Left AppException if unsuccessful',
        () async {
      String oldpassword = 'test123456@';
      String newpassword = 'test1234567@';
      String confirmPassword = 'test1234567@';
      Either<AppException, bool> result = await psource.changePassword(
          oldpassword, newpassword, confirmPassword);

      expect(result.isLeft(), true);
    });
  });
}
