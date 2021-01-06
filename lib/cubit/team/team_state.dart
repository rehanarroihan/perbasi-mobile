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
