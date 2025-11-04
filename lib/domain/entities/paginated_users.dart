import 'package:equatable/equatable.dart';
import 'package:unifi_exams/domain/entities/user.dart';

class PaginatedUsers extends Equatable {
  final List<User> users;
  final int totalPages;

  const PaginatedUsers({
    required this.users,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [users, totalPages];
}