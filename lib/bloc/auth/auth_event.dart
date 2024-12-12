part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthenticateUser extends AuthEvent {
  final String email;
  final String password;

  AuthenticateUser({required this.email, required this.password});
}
