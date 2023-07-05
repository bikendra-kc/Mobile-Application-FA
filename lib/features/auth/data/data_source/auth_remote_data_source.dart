import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonts_and_themes/features/auth/domain/entity/auth_entity.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';

import '../../../../core/shared_prference/user_shared_prefs.dart';

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  AuthRemoteDataSource({required this.dio, required this.userSharedPrefs});

  Future<Either<Failure, bool>> loginUser(
    String username,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.signIn,
        data: {
          "username": username,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["error"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.signUp,
        data: {
          "firsName": user.firstName,
          
          "lastName": user.lastName,
          "phoneNumber": user.phoneNumber,
          "username": user.username,
          "password": user.password,
        },
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["error"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // Upload image using multipart
  // Future<Either<Failure, String>> uploadProfilePicture(
  //   File image,
  // ) async {
  //   try {
  //     String fileName = image.path.split('/').last;
  //     FormData formData = FormData.fromMap(
  //       {
  //         'profilePicture': await MultipartFile.fromFile(
  //           image.path,
  //           filename: fileName,
  //         ),
  //       },
  //     );

  //     Response response = await dio.post(
  //       ApiEndpoints.uploadImage,
  //       data: formData,
  //     );

  //     return Right(response.data["data"]);
  //   } on DioException catch (e) {
  //     return Left(
  //       Failure(
  //         error: e.error.toString(),
  //         statusCode: e.response?.statusCode.toString() ?? '0',
  //       ),
  //     );
  //   }
  // }
}
