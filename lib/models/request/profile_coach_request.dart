import 'dart:io';

import 'package:dio/dio.dart';

class ProfileCoachRequest {
  String email, nik, name, birthPlace, birthDate, phone, address, licence, licenceNumber, licenceFrom, licenceActiveDate, licence_active_at, typeId, gender;
  File licenceFile, foto, ktp;

  ProfileCoachRequest(
      {this.email,
      this.nik,
      this.name,
      this.birthPlace,
      this.birthDate,
      this.phone,
      this.address,
      this.gender,
      this.licence,
      this.licenceNumber,
      this.licenceFrom,
      this.licenceActiveDate,
      this.licence_active_at,
      this.licenceFile,
      this.typeId,
      this.foto,
      this.ktp});

  factory ProfileCoachRequest.fromMap(Map<String, dynamic> map) {
    return new ProfileCoachRequest(
      email: map['email'] as String,
      nik: map['nik'] as String,
      name: map['name'] as String,
      birthPlace: map['birth_place'] as String,
      birthDate: map['birth_date'] as String,
      gender: map['gender'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      licence: map['licence'] as String,
      licenceNumber: map['licence_number'] as String,
      licenceFrom: map['licence_from'] as String,
      typeId: map['type_id'] as String,
      licenceActiveDate: map['licence_active_date'] as String,
      licence_active_at: map['licence_active_at'] as String,
      licenceFile: map['licence_file'] as File,
      foto: map['foto'] as File,
      ktp: map['ktp'] as File,
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    // ignore: unnecessary_cast
    return {
      'email': this.email,
      'nik': this.nik,
      'name': this.name,
      'birth_place': this.birthPlace,
      'birth_date': this.birthDate,
      'phone': this.phone,
      'gender': this.gender,
      'address': this.address,
      'licence': this.licence,
      'licence_number': this.licenceNumber,
      'licence_from': this.licenceFrom,
      'licence_active_date': this.licenceActiveDate,
      'licence_active_at': this.licence_active_at,
      'type_id': this.typeId,
      'licence_file': await MultipartFile.fromFile(
        this.licenceFile?.path, filename: this.licenceFile?.path?.split('/')?.last
      ),
      'foto': await MultipartFile.fromFile(
        this.licenceFile?.path, filename: this.licenceFile?.path?.split('/')?.last
      ),
      'ktp': await MultipartFile.fromFile(
          this.ktp?.path, filename: this.ktp?.path?.split('/')?.last
      ),
    } as Map<String, dynamic>;
  }
}