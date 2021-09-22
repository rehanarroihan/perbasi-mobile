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

class ChangePasswordInitialState extends AuthState {}

class ChangePasswordSuccessfulState extends AuthState {
  final String message;

  ChangePasswordSuccessfulState(this.message);
}

class ChangePasswordFailedState extends AuthState {
  final String message;

  ChangePasswordFailedState(this.message);
}

class PostTokenInitialState extends AuthState {}

class PostTokenSuccessfulState extends AuthState {}

class PostTokenFailedState extends AuthState {}


class DeleteTokenInitialState extends AuthState {}

class DeleteTokenSuccessfulState extends AuthState {}

class DeleteTokenFailedState extends AuthState {}




