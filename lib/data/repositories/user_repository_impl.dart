
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<User>>> getUsers(int page, int perPage) async {
    try {
      final users = await remoteDataSource.getUsers(page, perPage);
      return Right(users);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addUser(User user) async {
    try {
      final userModel = UserModel(
        name: user.name,
        email: user.email,
        gender: user.gender,
        status: user.status,
      );
      await remoteDataSource.addUser(userModel);
      return const Right(null);
    }  on DuplicateEmailFailure {
      // Catch the specific exception and return the specific failure
      return Left(DuplicateEmailFailure());
    } on ServerException {
      // Catch all other server exceptions
      return Left(ServerFailure());
    }
  }
}