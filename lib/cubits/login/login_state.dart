part of 'login_cubit.dart';

abstract class LoginAppState extends Equatable {
  const LoginAppState();
}

class LoginAppInitialState extends LoginAppState {
  @override
  List<Object> get props => [];
}

class LoginInLoadingState extends LoginAppState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends LoginAppState {
  final CredentialModel credential;
  const LoggedInState({
    required this.credential,
  });

  @override
  List<Object> get props => [credential];
}

class LoginErrorState extends LoginAppState {
  final String error;
  const LoginErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
