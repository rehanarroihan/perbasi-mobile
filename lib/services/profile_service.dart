import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/login_model.dart';
import 'package:perbasitlg/models/request/login_request.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/models/request/register_request.dart';
import 'package:perbasitlg/models/user_model.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class ProfileService {
  Dio _dio = App().dio;

  Future<ApiReturn> updatePlayerProfile({ProfilePlayerRequest data, ValueChanged<double> onSendProgress}) async {
    try {
      Response response = await _dio.post(
        UrlConstantHelper.POST_CHANGE_PLAYER_PROFILE,
        data: FormData.fromMap(await data.toMap()),
        onSendProgress: (int sent, int total) {
          double progress = (sent / total) * 100;
          onSendProgress(progress);
        }
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
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

  Future<ApiReturn> updateCoachProfile({
    ProfileCoachRequest data,
    ValueChanged<double> onSendProgress,
    String role
  }) async {
    try {
      Response response = await _dio.post(
        role == ConstantHelper.ROLE_PELATIH
          ? UrlConstantHelper.POST_CHANGE_COACH_PROFILE
          : UrlConstantHelper.POST_CHANGE_REFEREE_PROFILE,
        data: FormData.fromMap(await data.toMap()),
        onSendProgress: (int sent, int total) {
          double progress = (sent / total) * 100;
          onSendProgress(progress);
        }
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
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