import 'package:dio/dio.dart';
import 'package:unifi_exams/core/error/failures.dart';
import 'package:unifi_exams/domain/entities/paginated_users.dart';

import '../models/paginated_users_response.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<PaginatedUsersResponse> getUsers(int page, int perPage);
  Future<void> addUser(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedUsersResponse> getUsers(int page, int perPage) async {
    // 1. Wrap the entire network operation in a try/catch block.
    try {
      final response = await dio.get(
        '/users',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final userModels = (response.data as List)
          .map((userJson) => UserModel.fromJson(userJson))
          .toList();

      final totalPages = int.tryParse(response.headers.value('x-pagination-pages') ?? '1') ?? 1;

      return PaginatedUsersResponse(
        users: userModels,
        totalPages: totalPages,
      );
    } on DioException catch (e) {
      // 2. Catch the specific DioException.
      // You can add more logic here to inspect e.type or e.response
      // if you want to differentiate between connection errors, timeouts, etc.

      // 3. Throw your custom ServerException. This "translates" the error
      //    into something the repository knows how to handle.
      throw ServerException();
    }
  }

  @override
  Future<void> addUser(UserModel user) async {
    try {
      await dio.post('/users', data: user.toJson());
    } on DioException catch (e) {
      // Check if the error is a 422 Unprocessable Entity
      if (e.response?.statusCode == 422) {
        // Check if the response body indicates a duplicate email
        final responseData = e.response?.data as List?;
        if (responseData != null && responseData.isNotEmpty) {
          final error = responseData.first as Map<String, dynamic>;
          if (error['field'] == 'email' && error['message'].contains('has already been taken')) {
            // If it is, throw our specific exception
            throw DuplicateEmailFailure();
          }
        }
      }
      // For all other errors, throw the generic ServerException
      throw ServerException();
    }
  }
}

class ServerException implements Exception {}