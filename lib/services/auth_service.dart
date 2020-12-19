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
}