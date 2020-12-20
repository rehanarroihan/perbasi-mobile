import 'package:dio/dio.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/login_model.dart';
import 'package:perbasitlg/models/request/login_request.dart';
import 'package:perbasitlg/models/request/register_request.dart';
import 'package:perbasitlg/models/user_model.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class AuthService {
  Dio _dio = App().dio;

  Future<ApiReturn> userRegistration(RegisterRequest data) async {
    try {
      Response response = await _dio.post(
        UrlConstantHelper.POST_AUTH_REGISTER,
        data: FormData.fromMap(data.toMap())
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
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
      Response response = await _dio.post(
        UrlConstantHelper.POST_AUTH_LOGIN,
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