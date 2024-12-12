library auth_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackme/model/error.dart';
import 'package:trackme/repo/auth.dart';
import 'package:trackme/utilities/logger.dart';

part 'auth_event.dart';

part 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStates> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthenticateUser>(_login);
  }

  Future<void> _login(AuthenticateUser event, emit) async {
    emit(AuthLoadingState());
    try {
      await logIn(event.email, event.password);
      emit(AuthLoadedState());
    } catch (e) {
      CustomLogger.error(e);
      emit(
          AuthErrorState(error: ErrorModel(message: "Error Logging In", e: e)));
    }
  }
}
