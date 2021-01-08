import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/request/exit_club_request.dart';
import 'package:perbasitlg/services/team_service.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamInitial());

  TeamService _teamService = TeamService();

  bool teamPageLoading = false;

  bool userHaveTeam = false;
  ClubDetail myClubDetail = ClubDetail();
  bool userCanVerif = false;
  List<ClubModel> teamList = List<ClubModel>();

  bool teamDetailPageLoading = false;
  ClubDetail clubDetail = ClubDetail();

  void getMyTeamPage() async {
    this.teamPageLoading = true;
    this.userHaveTeam = false;
    this.userCanVerif = false;
    emit(GetMyTeamPageInit());

    ApiReturn<ClubDetail> apiResult = await _teamService.getMyTeam();
    this.teamPageLoading = false;
    if (apiResult.success) {
      this.userHaveTeam = true;
      this.myClubDetail = apiResult.data;
      if (this.myClubDetail.canVerification) {
        this.userCanVerif = true;
      }
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

  void registerToTeam(String teamId) async {
    emit(RegisterToTeamInit());

    ApiReturn apiResult = await _teamService.registerToTeam(teamId);
    if (apiResult.success) {
      emit(RegisterToTeamSuccessfulState());
    } else {
      if (apiResult.message.toLowerCase() == 'Kamu sudah mendaftar diteam ini'.toLowerCase()) {
        emit(RegisterToTeamFailedState(message: 'Anda sudah mendaftar ke team ini'));
      } else {
        emit(RegisterToTeamFailedState(message: 'Gagal mendaftar ke team ini'));
      }
    }
  }

  void exitFromTeam(ExitClubRequest data) async {
    emit(ExitTeamInit());

    ApiReturn apiResult = await _teamService.exitFromTeam(data);
    if (apiResult.success) {
      emit(ExitTeamSuccessfulState());
    } else {
      emit(ExitTeamFailedState());
    }
  }
}
