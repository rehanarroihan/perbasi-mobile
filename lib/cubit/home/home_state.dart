part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class GetHomePageDatasInit extends HomeState {}

class GetHomePageDatasSuccess extends HomeState {}

class GetHomePageDatasFailed extends HomeState {}

class GetCompetitionScheduleInit extends HomeState {}

class GetCompetitionScheduleSuccess extends HomeState {}

class GetCompetitionScheduleFailed extends HomeState {}

class ChangeMainPageInit extends HomeState {}

class ChangedMainPage extends HomeState {}

class GetCompetitionDetailInit extends HomeState {}

class GetCompetitionDetailResult extends HomeState {}

class GetCompetitionDetailForScheduleListInit extends HomeState {}

class GetCompetitionDetailForScheduleListResult extends HomeState {
  final CompetitionModel result;

  GetCompetitionDetailForScheduleListResult({this.result});
}