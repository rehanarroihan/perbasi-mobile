import 'package:dio/dio.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/request/exit_club_request.dart';
import 'package:perbasitlg/models/request/verify_player_request.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class TeamService {
  Dio _dio = App().dio;

  Future<ApiReturn<List<ClubDetail>>> getMyTeam() async {
    try {
      Response response = await _dio.get(UrlConstantHelper.GET_MY_TEAM);
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: (response.data['data'] as Iterable)
              .map((e) => ClubDetail.fromJson(e))
              .toList(),
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e, stackTrace) {
      return ApiReturn(success: false);
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

  Future<ApiReturn> registerToTeam(String teamId) async {
    try {
      Response response = await _dio.post(UrlConstantHelper.POST_REGISTER_TEAM + teamId);
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'] ?? response.data['status'],
          message: response.data['message'],
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e) {
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }

  Future<ApiReturn> exitFromTeam(ExitClubRequest datas) async {
    try {
      Response response = await _dio.put(
        UrlConstantHelper.PUT_EXIT_FROM_TEAM,
        data: datas.toMap()
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e) {
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }

  Future<ApiReturn> verifyPlayer(VerifyPlayerRequest data) async {
    try {
      Response response = await _dio.put(
        UrlConstantHelper.PUT_VERIF_PLAYER,
        data: data.toMap()
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
        );
      }

      return ApiReturn(success: false, message: response.data['message']);
    } catch (e) {
      return ApiReturn(
        success: false,
        message: e?.response?.data['message'] ?? 'Something went wrong'
      );
    }
  }
}