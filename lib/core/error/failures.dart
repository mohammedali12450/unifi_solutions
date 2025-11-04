import 'package:equatable/equatable.dart';


// The abstract Failure class
// By extending Equatable, we can compare Failure objects.
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String? message;

  const ServerFailure({this.message});
}

class CacheFailure extends Failure {
  final String? message;

  const CacheFailure({this.message});
}

class NetworkFailure extends Failure {
  final String? message;

  const NetworkFailure({this.message});
}

// You can add more specific failures as needed, for example:
class DuplicateEmailFailure extends Failure {}

class InvalidTokenFailure extends Failure {}
class CacheException implements Exception {}