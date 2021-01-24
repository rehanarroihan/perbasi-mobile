import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/models/news_model.dart';
import 'package:perbasitlg/models/schedule_model.dart';
import 'package:perbasitlg/services/home_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  HomeService _homeService = HomeService();

  bool homePageLoading = false;
  List<NewsModel> newsList = List<NewsModel>();
  CompetitionModel highlightCompetition = CompetitionModel();
  List<CompetitionModel> competitions = List<CompetitionModel>();

  bool scheduleListLoading = false;
  List<ScheduleModel> schedule = List<ScheduleModel>();

  bool allScheduleListLoading = false;
  List<ScheduleModel> allSchedule = List<ScheduleModel>();

  void getHomePageData() async {
    this.homePageLoading = true;
    emit(GetHomePageDatasInit());

    try {
      ApiReturn<List<NewsModel>> newsResult = await _homeService.getNewsList();
      this.newsList = newsResult.data;

      ApiReturn<List<CompetitionModel>> apiResult = await _homeService.getCompetitionList();
      this.competitions = apiResult.data;
      if (this.competitions.length >= 1) {
        this.highlightCompetition = this.competitions[0];
      }

      this.homePageLoading = false;
      emit(GetHomePageDatasSuccess());
    } catch(e) {
      this.homePageLoading = false;
      emit(GetHomePageDatasFailed());
    }
  }

  void getCompetitionScheduleList(String competitionId) async {
    this.scheduleListLoading = true;
    emit(GetCompetitionScheduleInit());

    ApiReturn<List<ScheduleModel>> apiResult = await _homeService.getCompetitionScheduleList(competitionId);
    this.scheduleListLoading = false;
    if (apiResult.success) {
      this.schedule = apiResult.data;
      emit(GetCompetitionScheduleSuccess());
    } else {
      emit(GetCompetitionScheduleFailed());
    }
  }

  void getAllCompetitionScheduleList() async {
    this.allScheduleListLoading = true;
    emit(GetCompetitionScheduleInit()); // State should be replaced with the new one

    ApiReturn<List<ScheduleModel>> apiResult = await _homeService.getAllCompetitionScheduleList();
    this.allScheduleListLoading = false;
    if (apiResult.success) {
      this.allSchedule = apiResult.data;
      emit(GetCompetitionScheduleSuccess()); // State should be replaced with the new one
    } else {
      emit(GetCompetitionScheduleFailed()); // State should be replaced with the new one
    }
  }
}
