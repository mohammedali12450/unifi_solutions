import 'package:dartz/dartz.dart'; // Add dartz for functional error handling
import '../../core/error/failures.dart';
import '../entities/paginated_users.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, PaginatedUsers>> getUsers(int page, int perPage);
  Future<Either<Failure, void>> addUser(User user);
}