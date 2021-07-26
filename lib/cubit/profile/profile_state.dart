part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class UpdateProfilePictureInit extends ProfileState {}

class UpdateProfilePictureSuccessful extends ProfileState {}

class UpdateProfilePictureFailed extends ProfileState {}

class UpdateProfileInit extends ProfileState {}

class UpdateProfileProgressChangeInit extends ProfileState {}

class UpdateProfileProgressChanged extends ProfileState {}

class UpdateProfileSuccessful extends ProfileState {}

class UpdateProfileFailed extends ProfileState {}

class ScanQrCodeInit extends ProfileState {}

class ScanQrCodeSuccessful extends ProfileState {
  final String message;

  ScanQrCodeSuccessful(this.message);
}

class ScanQrCodeFailedState extends ProfileState {
  final String message;

  ScanQrCodeFailedState(this.message);
}