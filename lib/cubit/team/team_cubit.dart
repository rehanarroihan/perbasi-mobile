import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/my_team_model.dart';
import 'package:perbasitlg/services/team_service.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamInitial());

  TeamService _teamService = TeamService();

  bool teamPageLoading = false;

  bool userHaveTeam = false;
  bool userCanVerif = false;
  List<ClubModel> teamList = List<ClubModel>();

  bool teamDetailPageLoading = false;
  ClubDetail clubDetail = ClubDetail();

  void getMyTeamPage() async {
    this.teamPageLoading = true;
    emit(GetMyTeamPageInit());

    ApiReturn<MyTeamModel> apiResult = await _teamService.getMyTeam();
    this.teamPageLoading = false;
    if (apiResult.success) {
      emit(GetMyTeamPageSuccessfulState());
    } else {
      ApiReturn<List<ClubModel>> apiResult = await _teamService.getTeamList();
      if (apiResult.success) {
        this.teamList = apiResult.data;
      }
      emit(GetMyTeamPageFailedState());
    }
  }

  void getTeamDetail(String id) async {
    this.teamDetailPageLoading = true;
    emit(GetTeamDetailInit());

    ApiReturn<ClubDetail> apiResult = await _teamService.getTeamDetail(id);
    this.teamDetailPageLoading = false;
    if (apiResult.success) {
      this.clubDetail = apiResult.data;
      emit(GetTeamDetailSuccessfulState());
    } else {
      emit(GetTeamDetailFailedState());
    }
  }
}
