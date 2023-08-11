import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_library_managent/core/shared_prefs/user_shared_prefs.dart';
import 'package:flutter_library_managent/features/profile/data/model/profileResponse.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';
import '../../../Home/data/model/products.dart';
import '../../../auth/data/model/user_model.dart';
import '../model/OrderResponse.dart';
import '../model/add_product_model.dart';

final profileRemoteDataSourceProvider = Provider(
  (ref) => ProfileRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class ProfileRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  ProfileRemoteDataSource({
    required this.dio,
    required this.userSharedPrefs,
  });

  // get userprofile

  Future<Either<AppException, ProfileResponse>> getUserProfile() async {
    try {
      final token = await userSharedPrefs.getUserToken();

      dio.options.headers['Authorization'] = 'Bearer $token';

      print("print from profile remote data source............");
      print(token);

      Response response = await dio.get(ApiEndpoints.profile);

      if (response.statusCode == 200) {
        final user = ProfileResponse.fromJson(response.data);
        return Right(user);
      } else {
        return Left(
          AppException(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        AppException(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<AppException, List<OrderResponse>>> getUserOrder() async {
    try {
      final token = await userSharedPrefs.getUserToken();

      dio.options.headers['Authorization'] = 'Bearer $token';

      Response response = await dio.get(ApiEndpoints.getOrders);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          final orders = data
              .map((orderData) => OrderResponse.fromJson(orderData))
              .toList();
          return Right(orders);
        } else {
          return Left(AppException(
            error: 'Invalid response format',
            statusCode: response.statusCode.toString(),
          ));
        }
      } else {
        return Left(
          AppException(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        AppException(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<AppException, bool>> updateUserProfile(UserModel user) async {
    try {
      final token = await userSharedPrefs.getUserToken();

      dio.options.headers['Authorization'] = 'Bearer $token';

      Response response =
          await dio.put(ApiEndpoints.updateProfile, data: user.toJson());

      if (response.statusCode == 200) {
        return const Right(true); // Return true to indicate successful update
      } else {
        return Left(
          AppException(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        AppException(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<AppException, bool>> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    try {
      final token = await userSharedPrefs.getUserToken();

      dio.options.headers['Authorization'] = 'Bearer $token';
      Response response = await dio.put(ApiEndpoints.chnagePassword, data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'passwordConfirm': confirmPassword
      });

      if (response.statusCode == 200) {
        // Password change successful
        return const Right(true);
      } else {
        // Password change failed
        return Left(
          AppException(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      // Dio exception occurred
      return Left(
        AppException(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<AppException, bool>> addProduct(AddProduct product) async {
    try {
      final token = await userSharedPrefs.getUserToken();

      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'multipart/form-data';

      FormData formData = FormData();

      final bytes = product.image!.readAsBytesSync();

      String base64Image = "data:image/png;base64," + base64Encode(bytes);

      // Add other product details to the FormData
      formData.fields.addAll([
        MapEntry('name', product.name),
        MapEntry('price', product.price.toString()),
        MapEntry('offerPrice', product.offerPrice.toString()),
        MapEntry('description', product.description),
        MapEntry('category', product.category),
        MapEntry('stock', product.stock.toString()),
        MapEntry('images', base64Image),
      ]);

      // Attach the image file to the FormData
      // if (product.image != null) {
      //   formData.files.add(
      //     MapEntry(
      //       'images',
      //       await MultipartFile.fromFile(
      //         product.image!.path,
      //         filename: product.images!.path.split('/').last,
      //       ),
      //     ),
      //   );
      // }

      Response response =
          await dio.post(ApiEndpoints.createProduct, data: formData);

      if (response.statusCode == 201) {
        // Product added successfully
        return const Right(true);
      } else {
        // Product addition failed
        return Left(
          AppException(
            error: 'Product addition failed',
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      // Dio exception occurred
      return Left(
        AppException(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    } catch (e) {
      // Other exception occurred
      return Left(
        AppException(
          error: e.toString(),
          statusCode: '0',
        ),
      );
    }
  }

  // make add product function
}
