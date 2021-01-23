import 'package:dio/dio.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/models/news_model.dart';
import 'package:perbasitlg/models/schedule_model.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class HomeService {
  Dio _dio = App().dio;

  Future<ApiReturn<List<NewsModel>>> getNewsList() async {
    try {
      Response response = await _dio.get(
        UrlConstantHelper.GET_NEWS,
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: (response.data['data'] as Iterable)
              .map((e) => NewsModel.fromJson(e))
              .toList(),
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      return ApiReturn(
          success: false,
          message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }

  Future<ApiReturn<List<CompetitionModel>>> getCompetitionList() async {
    try {
      Response response = await _dio.get(
        UrlConstantHelper.GET_COMPETITIONS,
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: (response.data['data'] as Iterable)
              .map((e) => CompetitionModel.fromJson(e))
              .toList(),
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }

  Future<ApiReturn<List<ScheduleModel>>> getCompetitionScheduleList(String competitionId) async {
    try {
      Response response = await _dio.get(
        UrlConstantHelper.GET_COMPETITION_SCHEDULE_DETAIL + competitionId,
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: (response.data['data'] as Iterable)
              .map((e) => ScheduleModel.fromJson(e))
              .toList(),
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }

  Future<ApiReturn<List<ScheduleModel>>> getAllCompetitionScheduleList() async {
    try {
      Response response = await _dio.get(
        UrlConstantHelper.GET_ALL_COMPETITION_SCHEDULE,
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: (response.data['data'] as Iterable)
              .map((e) => ScheduleModel.fromJson(e))
              .toList(),
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }
}