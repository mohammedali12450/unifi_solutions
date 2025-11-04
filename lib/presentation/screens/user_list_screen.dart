import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.developer_mode),
            tooltip: 'Native Features',
            onPressed: () {
              // Use GoRouter to navigate to the new screen
              context.push('/native');
            },
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserInitial ||
              (state is UserLoading && state is! UserLoaded)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserError) {
            return Center(child: Text(state.message));
          }
          if (state is UserLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<UserCubit>().refreshUsers(),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.users.length
                    : state.users.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.users.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final user = state.users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Text(user.status),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-user'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<UserCubit>().fetchUsers();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
