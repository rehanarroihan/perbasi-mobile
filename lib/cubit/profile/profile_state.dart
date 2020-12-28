part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class UpdateProfileInit extends ProfileState {}

class UpdateProfileProgressChangeInit extends ProfileState {}

class UpdateProfileProgressChanged extends ProfileState {}

class UpdateProfileSuccessful extends ProfileState {}

class UpdateProfileFailed extends ProfileState {}