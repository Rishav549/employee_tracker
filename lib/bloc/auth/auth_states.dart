part of 'auth_bloc.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthLoadedState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final ErrorModel error;

  AuthErrorState({required this.error});
}
