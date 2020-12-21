import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/models/news_model.dart';
import 'package:perbasitlg/services/home_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  HomeService _homeService = HomeService();

  bool homePageLoading = false;
  List<NewsModel> newsList = List<NewsModel>();
  CompetitionModel highlightCompetition = CompetitionModel();
  List<CompetitionModel> competitions = List<CompetitionModel>();

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
        this.competitions.removeAt(0);
      }

      this.homePageLoading = false;
      emit(GetHomePageDatasSuccess());
    } catch(e) {
      this.homePageLoading = false;
      emit(GetHomePageDatasFailed());
    }
  }
}
