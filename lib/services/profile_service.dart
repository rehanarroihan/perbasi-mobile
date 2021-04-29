import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Dio _dio = App().dio;

  Future<ApiReturn> updatePlayerProfile({ProfilePlayerRequest data, ValueChanged<double> onSendProgress}) async {
    try {
      /*final uploader = FlutterUploader();

      final taskId = uploader.enqueue(
        url: App().apiBaseURL +  UrlConstantHelper.POST_CHANGE_PLAYER_PROFILE,
        method: UploadMethod.POST,
        headers: {
          "Authorization": "Bearer ${App().prefs.getString(ConstantHelper.PREFS_TOKEN_KEY)}"
        },
        files: [
          FileItem(
            filename: data.foto.path.split('/').last,
            savedDir: data.foto.path,
            fieldname: 'foto'
          ),
          FileItem(
            filename: data.kk.path.split('/').last,
            savedDir: data.kk.path,
            fieldname: 'kk'
          )
        ],
        data: {
          'email': data.email,
          'nik': data.nik,
          'name': data.name,
          'birthPlace': data.birthPlace,
          'birthDate': data.birthDate,
          'phone': data.phone,
          'address': data.address,
          'positionId': data.positionId
        },
        showNotification: false,
        tag: "upload1"
      );

      uploader.result.listen((result) {
        return ApiReturn(
          success: true,
          message: 'haha',
        );
      }, onError: (ex, stacktrace) {
        // ... code to handle error
      });*/

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

      return ApiReturn(success: false);
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
      /*Response response = await _dio.post(
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
      }*/

      String url = role == ConstantHelper.ROLE_PELATIH
          ? UrlConstantHelper.POST_CHANGE_COACH_PROFILE
          : UrlConstantHelper.POST_CHANGE_REFEREE_PROFILE;

      var request = http.MultipartRequest(
        'POST', Uri.parse(
        App().apiBaseURL + url
      ));
      request.fields['email'] = data.email;
      request.fields['nik'] = data.nik;
      request.fields['name'] = data.name;
      request.fields['birth_place'] = data.birthPlace;
      request.fields['birth_date'] = data.birthDate;
      request.fields['phone'] = data.phone;
      request.fields['gender'] = data.gender;
      request.fields['address'] = data.address;
      request.fields['licence'] = data.licence;
      request.fields['licence_number'] = data.licenceNumber;
      request.fields['licence_from'] = data.licenceFrom;
      request.fields['licence_active_date'] = data.licenceActiveDate;
      if (role == ConstantHelper.ROLE_PELATIH) {
        request.fields['type_id'] = data.typeId;
      }
      request.files.add(
        http.MultipartFile.fromBytes(
          'licence_file',
          data.licenceFile.readAsBytesSync(),
          filename: data.licenceFile.path.split("/").last
        )
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'foto',
          data.foto.readAsBytesSync(),
          filename: data.foto.path.split("/").last
        )
      );
      request.headers['Authorization'] = 'Bearer ${App().prefs.getString(ConstantHelper.PREFS_TOKEN_KEY)}';

      var res = await request.send();
      var responseData = await res.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var d = jsonDecode(responseString);

      if (d['success'] == true) {
        return ApiReturn(
          success: true,
          message: d['message'],
        );
      }

      return ApiReturn(success: false, message: 'Something went wrong');
    } catch (e, stackTrace) {
      print(e);
      return ApiReturn(
        success: false,
        message: 'Something went wrong'
      );
    }
  }

  Future<ApiReturn> scanQRCode(String code) async {
    try {
      Response response = await _dio.post(
        UrlConstantHelper.POST_SCAN_QR_CODE,
        data: { 'qrcode': code },
      );
      if (response.statusCode == 200) {
        return ApiReturn(
          success: response.data['success'],
          message: response.data['message'],
        );
      }

      return ApiReturn(
        success: false,
        message: 'Gagal mengirim code, silahkan coba lagi',
      );
    } catch (e) {
      return ApiReturn(
        success: false,
        message: 'Gagal mengirim code, silahkan coba lagi',
      );
    }
  }
}