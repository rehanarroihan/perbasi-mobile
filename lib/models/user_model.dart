class UserModel {
  int id;
  String email;
  Role role;
  String userId;
  String name;
  String birthPlace;
  String birthDate;
  String address;
  String licence;
  String licenceNumber;
  String licenceFrom;
  Null licenceActiveDate;
  String phone;
  String createdAt;
  String updatedAt;
  Null createdBy;
  Null status;

  UserModel(
      {this.id,
        this.email,
        this.role,
        this.userId,
        this.name,
        this.birthPlace,
        this.birthDate,
        this.address,
        this.licence,
        this.licenceNumber,
        this.licenceFrom,
        this.licenceActiveDate,
        this.phone,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    userId = json['user_id'];
    name = json['name'];
    birthPlace = json['birth_place'];
    birthDate = json['birth_date'];
    address = json['address'];
    licence = json['licence'];
    licenceNumber = json['licence_number'];
    licenceFrom = json['licence_from'];
    licenceActiveDate = json['licence_active_date'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['birth_place'] = this.birthPlace;
    data['birth_date'] = this.birthDate;
    data['address'] = this.address;
    data['licence'] = this.licence;
    data['licence_number'] = this.licenceNumber;
    data['licence_from'] = this.licenceFrom;
    data['licence_active_date'] = this.licenceActiveDate;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
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