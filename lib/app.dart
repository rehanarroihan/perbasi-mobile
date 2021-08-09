import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  static App _instance;
  final String apiBaseURL;
  final String appTitle;

  SharedPreferences prefs;
  Dio dio;
  Directory appDocsDir;

  App.configure({
    this.apiBaseURL,
    this.appTitle
  }) {
    _instance = this;
  }

  factory App() {
    if (_instance == null) {
      throw UnimplementedError("App must be configured first.");
    }

    return _instance;
  }

  Future<Null> init() async {
    Stetho.initialize();
    prefs = await SharedPreferences.getInstance();

    appDocsDir = await getApplicationDocumentsDirectory();

    dio = Dio(BaseOptions(
      baseUrl: apiBaseURL,
      connectTimeout: 10000,
      receiveTimeout: 50000,
      responseType: ResponseType.json
    ));

    dio.options.headers = {
      'Authorization': 'Bearer ${prefs.get(ConstantHelper.PREFS_TOKEN_KEY)}'
    };

    // dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) async {
    //   Map<dynamic, dynamic> data = e.response.data;
    //   if (e.response.statusCode != null) {
    //     if (e.response.statusCode == 400) {
    //     }
    //     // INFO : Kicking out user to login page when !authenticated
    //     if (e.response.statusCode == 401) {
    //       String message = data['message'];
    //       if (!GlobalMethodHelper.isEmpty(message)) {
    //         if (message == 'Unauthorized') {
    //           showFlutterToast('Session expired, please re-login');
    //         }
    //       }
    //     }
    //   }
    //   return e;
    // }));
  }
}