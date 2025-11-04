import 'package:go_router/go_router.dart';
import '../../presentation/screens/add_user_screen.dart';
import '../../presentation/screens/native_integration_screen.dart';
import '../../presentation/screens/user_list_screen.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: '/add-user',
        builder: (context, state) => const AddUserScreen(),
      ),
      GoRoute(
        path: '/native',
        builder: (context, state) => const NativeIntegrationScreen(),
      ),
    ],
  );
}