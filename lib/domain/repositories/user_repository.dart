import 'package:dartz/dartz.dart'; // Add dartz for functional error handling
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers(int page, int perPage);
  Future<Either<Failure, void>> addUser(User user);
}