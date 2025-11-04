
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    int? id,
    required String name,
    required String email,
    required String gender,
    required String status,
  }) : super(id: id, name: name, email: email, gender: gender, status: status);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'status': status,
    };
  }
}