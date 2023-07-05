import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonts_and_themes/features/auth/domain/entity/auth_entity.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/auth_remote_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return ref.read(authRemoteRepositoryProvider);
});

abstract class IAuthRepository {
  Future<Either<Failure, bool>> registerUser(UserEntity user);
  Future<Either<Failure, bool>> loginUser(String username, String password);
  // Future<Either<Failure, String>> uploadProfilePicture(File file);
}
