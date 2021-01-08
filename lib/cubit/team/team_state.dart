part of 'team_cubit.dart';

abstract class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object> get props => [];
}

class TeamInitial extends TeamState {}

class GetMyTeamPageInit extends TeamState {}

class GetMyTeamPageSuccessfulState extends TeamState {}

class GetMyTeamPageFailedState extends TeamState {}

class GetTeamDetailInit extends TeamState {}

class GetTeamDetailSuccessfulState extends TeamState {}

class GetTeamDetailFailedState extends TeamState {}

class RegisterToTeamInit extends TeamState {}

class RegisterToTeamSuccessfulState extends TeamState {}

class RegisterToTeamFailedState extends TeamState {
  final String message;

  RegisterToTeamFailedState({this.message});
}

class ExitTeamInit extends TeamState {}

class ExitTeamSuccessfulState extends TeamState {}

class ExitTeamFailedState extends TeamState {}

class PlayerVerificationInitState extends TeamState {}

class PlayerVerificationSuccessfulState extends TeamState {}

class PlayerVerificationFailedState extends TeamState {}