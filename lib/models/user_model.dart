class UserModel {
  int id;
  String nik;
  String email;
  Role role;
  Position positionId;
  bool verified;
  String qrcode;
  String coachId;
  String name;
  String birthPlace;
  String birthDate;
  String address;
  String phone;
  String licence;
  String licenceNumber;
  String licenceFrom;
  String licenceActiveDate;
  String licenseFile;
  String foto;
  String kk;
  Position typeId;

  UserModel(
      {this.id,
        this.nik,
        this.email,
        this.role,
        this.positionId,
        this.verified,
        this.qrcode,
        this.coachId,
        this.name,
        this.birthPlace,
        this.birthDate,
        this.address,
        this.phone,
        this.licence,
        this.licenceNumber,
        this.licenceFrom,
        this.licenceActiveDate,
        this.licenseFile,
        this.foto,
        this.kk,
        this.typeId
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nik = json['nik'];
    email = json['email'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    positionId = json['position_id'] != null ? new Position.fromJson(json['position_id']) : null;
    typeId = json['type_id'] != null ? new Position.fromJson(json['type_id']) : null;
    verified = json['verified'];
    coachId = json['coach_id'];
    qrcode = json['qrcode'];
    name = json['name'];
    birthPlace = json['birth_place'];
    birthDate = json['birth_date'];
    address = json['address'];
    phone = json['phone'];
    licence = json['licence'];
    licenceNumber = json['licence_number'];
    licenceFrom = json['licence_from'];
    licenceActiveDate = json['licence_active_date'];
    licenseFile = json['licence_file'];
    foto = json['foto'];
    kk = json['kk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nik'] = this.nik;
    data['email'] = this.email;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    if (this.positionId != null) {
      data['position_id'] = this.positionId.toJson();
    }
    data['verified'] = this.verified;
    data['coach_id'] = this.coachId;
    data['qrcode'] = this.qrcode;
    data['name'] = this.name;
    data['type_id'] = this.typeId;
    data['birth_place'] = this.birthPlace;
    data['birth_date'] = this.birthDate;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['licence'] = this.licence;
    data['licence_number'] = this.licenceNumber;
    data['licence_from'] = this.licenceFrom;
    data['licence_active_date'] = this.licenceActiveDate;
    data['licence_file'] = this.licenseFile;
    data['foto'] = this.foto;
    data['kk'] = this.kk;
    return data;
  }
}

class Role {
  String id;
  String name;

  Role({this.id, this.name});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Position {
  int id;
  String name;

  Position({this.id, this.name});

  Position.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}