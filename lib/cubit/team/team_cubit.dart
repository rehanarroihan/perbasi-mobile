import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/request/exit_club_request.dart';
import 'package:perbasitlg/models/request/verify_player_request.dart';
import 'package:perbasitlg/services/team_service.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamInitial());

  TeamService _teamService = TeamService();

  bool teamPageLoading = false;

  bool userHaveTeam = false;
  List<ClubDetail> myClubList = List<ClubDetail>();
  List<ClubModel> teamList = List<ClubModel>();

  bool teamDetailPageLoading = false;
  ClubDetail clubDetail = ClubDetail();
  MyTeam myTeam = MyTeam();

  // void getMyTeamPage() async {
  //   this.teamPageLoading = true;
  //   this.userHaveTeam = false;
  //   emit(GetMyTeamPageInit());
  //
  //   ApiReturn<List<ClubDetail>> apiResult = await _teamService.getMyTeam();
  //   this.teamPageLoading = false;
  //   if (apiResult.success && apiResult.data.isNotEmpty) {
  //     this.userHaveTeam = true;
  //     this.myClubList = apiResult.data;
  //
  //     emit(GetMyTeamPageSuccessfulState());
  //   } else {
  //     ApiReturn<List<ClubModel>> apiResult = await _teamService.getTeamList();
  //     if (apiResult.success) {
  //       this.teamList = apiResult.data;
  //     }
  //     emit(GetMyTeamPageFailedState());
  //   }
  // }

  void getMyTeamPage() async {
    this.teamPageLoading = true;
    this.userHaveTeam = false;
    emit(GetMyTeamPageInit());

    ApiReturn<MyTeam> apiResult = await _teamService.getMyTeam();
    ApiReturn<List<ClubModel>> apiResultList = await _teamService.getTeamList();
    this.teamPageLoading = false;
    if (apiResult.success && apiResultList.success) {
      this.userHaveTeam = true;
      this.myTeam = apiResult.data;
      this.myClubList = apiResult.data.teams;
      this.teamList = apiResultList.data;
      emit(GetMyTeamPageSuccessfulState());
    } else {
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
      // if (apiResult.message.toLowerCase() == 'Kamu sudah mendaftar diteam ini'.toLowerCase()) {
      //   emit(RegisterToTeamFailedState(message: 'Anda sudah mendaftar ke team ini'));
      // } else {
      //   emit(RegisterToTeamFailedState(message: 'Gagal mendaftar ke team ini'));
      // }
      emit(RegisterToTeamFailedState(message: apiResult.message));
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

  void verifyPlayer(VerifyPlayerRequest data) async {
    emit(PlayerVerificationInitState());

    ApiReturn apiResult = await _teamService.verifyPlayer(data);
    if (apiResult.success) {
      emit(PlayerVerificationSuccessfulState());
    } else {
      emit(PlayerVerificationFailedState());
    }
  }
}
