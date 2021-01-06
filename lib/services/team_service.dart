import 'package:dio/dio.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/my_team_model.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class TeamService {
  Dio _dio = App().dio;

  Future<ApiReturn<MyTeamModel>> getMyTeam() async {
    try {
      Response response = await _dio.get(UrlConstantHelper.GET_MY_TEAM);
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: MyTeamModel.fromJson(response.data['data'])
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      print(e);
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }

  Future<ApiReturn<List<ClubModel>>> getTeamList() async {
    try {
      Response response = await _dio.get(UrlConstantHelper.GET_TEAMS);
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: (response.data['data'] as Iterable)
              .map((e) => ClubModel.fromJson(e))
              .toList(),
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      print(e);
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }

  Future<ApiReturn<ClubDetail>> getTeamDetail(String id) async {
    try {
      Response response = await _dio.get(UrlConstantHelper.GET_TEAM_DETAIL + id);
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: ClubDetail.fromJson(response.data['data']),
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      print(e);
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }
}