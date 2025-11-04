import 'package:dio/dio.dart';

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
    final response = await dio.post('/users', data: user.toJson());
    if (response.statusCode != 201) {
      throw ServerException();
    }
  }
}

class ServerException implements Exception {}