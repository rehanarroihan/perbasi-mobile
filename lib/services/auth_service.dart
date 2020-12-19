import 'package:dio/dio.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/request/register_request.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class AuthService {
  Dio _dio = App().dio;

  Future<ApiReturn> userRegistration(RegisterRequest data) async {
    try {
      Response response = await _dio.post(
        UrlConstantHelper.POST_AUTH_REGISTER,
        data: data
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          status: response.data['status'],
          message: response.data['message'],
        );
      }

      return ApiReturn(status: false, message: response.data['message']);
    } catch (e, stackTrace) {
      return ApiReturn(
        status: false,
        message: e.response.data['message'] ?? 'Something went wrong'
      );
    }
  }
}