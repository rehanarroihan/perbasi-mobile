part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class RegisterInitialState extends AuthState {}

class RegisterSuccessfulState extends AuthState {}

class RegisterFailedState extends AuthState {
  final String message;

  RegisterFailedState(this.message);
}

class LoginInitialState extends AuthState {}

class LoginSuccessfulState extends AuthState {}

class LoginFailedState extends AuthState {}

class GetUserDataInitialState extends AuthState {}

class GetUserDataSuccessfulState extends AuthState {}

class GetUserDataFailedState extends AuthState {}