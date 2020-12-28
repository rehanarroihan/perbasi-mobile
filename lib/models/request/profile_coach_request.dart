import 'dart:io';

import 'package:dio/dio.dart';

class ProfileCoachRequest {
  String email, nik, name, birthPlace, birthDate, phone, address, licence, licenceNumber, licenceFrom, licenceActiveDate;
  File licenceFile, foto;

  ProfileCoachRequest(
      {this.email,
      this.nik,
      this.name,
      this.birthPlace,
      this.birthDate,
      this.phone,
      this.address,
      this.licence,
      this.licenceNumber,
      this.licenceFrom,
      this.licenceActiveDate,
      this.licenceFile,
      this.foto});

  factory ProfileCoachRequest.fromMap(Map<String, dynamic> map) {
    return new ProfileCoachRequest(
      email: map['email'] as String,
      nik: map['nik'] as String,
      name: map['name'] as String,
      birthPlace: map['birth_place'] as String,
      birthDate: map['birth_date'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      licence: map['licence'] as String,
      licenceNumber: map['licence_number'] as String,
      licenceFrom: map['licence_from'] as String,
      licenceActiveDate: map['licence_active_date'] as String,
      licenceFile: map['licence_file'] as File,
      foto: map['foto'] as File,
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
      'address': this.address,
      'licence': this.licence,
      'licence_number': this.licenceNumber,
      'licence_from': this.licenceFrom,
      'licence_active_date': this.licenceActiveDate,
      'licence_file': await MultipartFile.fromFile(
        this.licenceFile.path, filename: this.licenceFile.path.split('/').last
      ),
      'foto': await MultipartFile.fromFile(
        this.licenceFile.path, filename: this.licenceFile.path.split('/').last
      ),
    } as Map<String, dynamic>;
  }
}