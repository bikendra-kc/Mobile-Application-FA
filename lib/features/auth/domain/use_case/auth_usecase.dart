import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonts_and_themes/features/auth/domain/entity/auth_entity.dart';


import '../../../../core/failure/failure.dart';
import '../repository/auth_repository copy.dart';


final authUseCaseProvider = Provider((ref) {
  return AuthUseCase(
    ref.read(authRepositoryProvider),
  );
});

class AuthUseCase {
  final IAuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    return await _authRepository.registerUser(user);
  }

  Future<Either<Failure, bool>> loginUser(
      String username, String password) async {
    return await _authRepository.loginUser(username, password);
  }

  // Future<Either<Failure, String>> uploadProfilePicture(File file) async {
  //   return await _authRepository.uploadProfilePicture(file);
  // }
}
