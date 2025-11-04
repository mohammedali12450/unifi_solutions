import 'package:dio/dio.dart';
import 'package:unifi_exams/core/error/failures.dart';

import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers(int page, int perPage);
  Future<void> addUser(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getUsers(int page, int perPage) async {
    final response = await dio.get(
      '/users',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    if (response.statusCode == 200) {
      final users = (response.data as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
      return users;
    } else {
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