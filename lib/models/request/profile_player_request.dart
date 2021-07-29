import 'dart:io';

import 'package:dio/dio.dart';

class ProfilePlayerRequest {
  String email, nik, name, birthPlace, birthDate, phone, address, positionId, gender, noKK, almaMater, identityAddress;
  File kk, foto, ktp, akta, selfie;

  ProfilePlayerRequest(
      {this.email,
      this.address,
      this.positionId,
      this.nik,
      this.name,
      this.birthPlace,
      this.birthDate,
      this.phone,
      this.gender,
      this.kk,
      this.noKK,
      this.almaMater,
      this.identityAddress,
      this.foto,
      this.ktp,
      this.akta,
      this.selfie});

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
      gender: map['gender'] as String,
      noKK: map['no_kk'] as String,
      almaMater: map['almamater'] as String,
      identityAddress: map['identityAddress'] as String,
      kk: map['kk'] as File,
      foto: map['foto'] as File,
      ktp: map['ktp'] as File,
      akta: map['akta'] as File,
      selfie: map['selfie'] as File,
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
      'gender': this.gender,
      'birth_place': this.birthPlace,
      'birth_date': this.birthDate,
      'phone': this.phone,
      'no_kk': this.noKK,
      'identityAddress': this.identityAddress,
      'almamater': this.almaMater,
      'kk': this.kk != null ? await MultipartFile.fromFile(
        this.kk?.path, filename: this.kk?.path?.split('/')?.last
      ) : null,
      'foto': this.foto != null ? await MultipartFile.fromFile(
        this.foto.path, filename: this.kk?.path?.split('/')?.last
      ) : null,
      'ktp': this.ktp != null ? await MultipartFile.fromFile(
        this.ktp.path, filename: this.ktp?.path?.split('/')?.last
      ) : null,
      'akta': this.akta != null ? await MultipartFile.fromFile(
          this.akta.path, filename: this.akta?.path?.split('/')?.last
      ) : null,
      'selfie': this.selfie != null ? await MultipartFile.fromFile(
        this.selfie.path, filename: this.selfie?.path?.split('/')?.last
      ) : null,
    } as Map<String, dynamic>;
  }
}