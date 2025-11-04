import 'package:unifi_exams/data/models/user_model.dart';

/// This is a DATA LAYER model.
/// It holds the raw data fetched from the API, including a List<UserModel>.
class PaginatedUsersResponse {
  final List<UserModel> users;
  final int totalPages;

  PaginatedUsersResponse({
    required this.users,
    required this.totalPages,
  });
}