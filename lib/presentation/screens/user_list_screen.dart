import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unifi_exams/presentation/cubit/user_cubit.dart';
import 'package:unifi_exams/presentation/cubit/user_state.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the initial fetch for the first page of users.
    context.read<UserCubit>().initialFetch();
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
              // Navigate to the screen for Section 2 tasks.
              context.push('/native');
            },
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        // The listener is for side effects like showing SnackBars.
        // It does not rebuild the UI.
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          // Bonus Task: Offline caching feedback.
          // If the state is loaded and we suspect we might be offline
          // (totalPages == 1 is our clue from the repository),
          // we check the actual connectivity.
          if (state is UserLoaded && state.totalPages == 1) {
            Connectivity().checkConnectivity().then((result) {
              if (result == ConnectivityResult.none) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You are offline. Displaying cached users.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            });
          }
        },
        // The builder is responsible for building the widget tree based on the state.
        builder: (context, state) {
          // While loading, show a centered spinner.
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // When data is loaded successfully, build the list and pagination.
          if (state is UserLoaded) {
            return Column(
              children: [
                Expanded(
                  // Implement pull-to-refresh by wrapping the list in a RefreshIndicator.
                  child: RefreshIndicator(
                    onRefresh: () => context.read<UserCubit>().refreshUsers(),
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text(user.name[0])),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: Text(
                            user.status,
                            style: TextStyle(
                              color: user.status == 'active'
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Display the pagination controls at the bottom.
                PaginationControls(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  onPageChanged: (page) {
                    context.read<UserCubit>().fetchPage(page);
                  },
                ),
              ],
            );
          }

          // If there's an error state (and not loading), show the error message.
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<UserCubit>().initialFetch(),
                    child: const Text('Try Again'),
                  )
                ],
              ),
            );
          }

          // For the initial state before any loading has begun.
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-user'),
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// A reusable widget for displaying pagination controls.
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If there's only one page, no need to show controls.
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            // Disable the button if on the first page.
            onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Page $currentPage of $totalPages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            // Disable the button if on the last page.
            onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}