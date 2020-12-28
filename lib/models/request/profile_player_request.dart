import 'dart:io';

import 'package:dio/dio.dart';

class ProfilePlayerRequest {
  String email, nik, name, birthPlace, birthDate, phone, address, positionId;
  File kk, foto;

  ProfilePlayerRequest(
      {this.email,
      this.address,
      this.positionId,
      this.nik,
      this.name,
      this.birthPlace,
      this.birthDate,
      this.phone,
      this.kk,
      this.foto});

  factory ProfilePlayerRequest.fromMap(Map<String, dynamic> map) {
    return new ProfilePlayerRequest(
      email: map['email'] as String,
      address: map['address'] as String,
      positionId: map['position_id'] as String,
      nik: map['nik'] as String,
      name: map['name'] as String,
      birthPlace: map['birth_place'] as String,
      phone: map['phone'] as String,
      birthDate: map['birth_date'] as String,
      kk: map['kk'] as File,
      foto: map['foto'] as File,
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    // ignore: unnecessary_cast
    return {
      'email': this.email,
      'address': this.address,
      'position_id': this.positionId,
      'nik': this.nik,
      'name': this.name,
      'birth_place': this.birthPlace,
      'birth_date': this.birthDate,
      'phone': this.phone,
      'kk': await MultipartFile.fromFile(
        this.kk.path, filename: this.kk.path.split('/').last
      ),
      'foto': this.foto != null ? await MultipartFile.fromFile(
        this.foto.path, filename: this.kk.path.split('/').last
      ) : null,
    } as Map<String, dynamic>;
  }
}