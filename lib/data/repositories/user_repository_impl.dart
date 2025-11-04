
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/paginated_users.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  final UserLocalDataSource localDataSource; // Add local data source
  final NetworkInfo networkInfo;             // Add network info
  UserRepositoryImpl({required this.remoteDataSource,required this.localDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, PaginatedUsers>> getUsers(int page, int perPage) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.getUsers(page, perPage);
        // If online, fetch from API and cache the first page
        if (page == 1) {
          localDataSource.cacheUsers(remoteResponse.users);
        }
        return Right(PaginatedUsers(users: remoteResponse.users, totalPages: remoteResponse.totalPages));
      } on ServerException {
        return Left(ServerFailure());
      }

    }
    try {
      final localUsers = await localDataSource.getLastUsers();
      // When offline, we don't know the total pages, so we default to 1
      return Right(PaginatedUsers(users: localUsers, totalPages: 1));
    } on CacheException {
      return Left(CacheFailure());
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