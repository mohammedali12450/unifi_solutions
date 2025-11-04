import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final int currentPage;
  final int totalPages;

  const UserLoaded({
    required this.users,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [users, currentPage, totalPages];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserAdded extends UserState {}

class UserSubmitting extends UserState {}

class UserSubmitSuccess extends UserState {}