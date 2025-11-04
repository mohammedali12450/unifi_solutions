import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unifi_exams/presentation/cubit/user_state.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/add_user.dart';
import '../../domain/usecases/get_users.dart';

class UserCubit extends Cubit<UserState> {
  final GetUsers getUsers;
  final AddUser addUser;
  int _page = 1;
  final int _perPage = 20;

  UserCubit({required this.getUsers, required this.addUser}) : super(UserInitial());

  Future<void> fetchUsers() async {
    if (state is UserLoading) return;

    final currentState = state;
    List<User> oldUsers = [];
    if (currentState is UserLoaded) {
      oldUsers = currentState.users;
    }

    emit(UserLoading());

    final result = await getUsers(_page, _perPage);
    result.fold(
          (failure) => emit(UserError('Failed to fetch users')),
          (newUsers) {
        _page++;
        final users = oldUsers + newUsers;
        emit(UserLoaded(users: users, hasReachedMax: newUsers.isEmpty));
      },
    );
  }

  Future<void> refreshUsers() async {
    _page = 1;
    emit(UserInitial());
    await fetchUsers();
  }

  Future<void> createUser(User user) async {
    emit(UserLoading());
    final result = await addUser(user);
    result.fold(
          (failure) => emit(UserError('Failed to add user')),
          (_) {
        emit(UserAdded());
        refreshUsers();
      },
    );
  }
}