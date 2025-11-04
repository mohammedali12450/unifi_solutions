import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class AddUser {
  final UserRepository repository;

  AddUser(this.repository);

  Future<Either<Failure, void>> call(User user) {
    return repository.addUser(user);
  }
}