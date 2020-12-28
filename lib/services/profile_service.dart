import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/login_model.dart';
import 'package:perbasitlg/models/request/login_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/models/request/register_request.dart';
import 'package:perbasitlg/models/user_model.dart';
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
          print(progress.toString() + ' persen cok');
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

  Future<LoginModel> userLogin(LoginRequest data) async {
    try {
      Response response = await _dio.post(
        UrlConstantHelper.POST_AUTH_LOGIN,
        data: FormData.fromMap(data.toMap())
      );
      if (response.statusCode == 200) {
        return LoginModel.fromJson(response.data);
      }

      return LoginModel.fromJson(response.data);
    } catch (e, stackTrace) {
      return LoginModel(
        success: false,
      );
    }
  }

  Future<ApiReturn<UserModel>> getUserDetail() async {
    try {
      Response response = await _dio.get(
        UrlConstantHelper.GET_PROFILE,
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
          data: UserModel.fromJson(response.data['data'])
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