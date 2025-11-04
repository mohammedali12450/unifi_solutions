import 'package:dartz/dartz.dart';
import 'package:unifi_exams/domain/entities/paginated_users.dart';

import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, PaginatedUsers>> call(int page, int perPage) {
    return repository.getUsers(page, perPage);
  }
}