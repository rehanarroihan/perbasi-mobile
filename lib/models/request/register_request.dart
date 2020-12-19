class RegisterRequest {
  String email, password, roleId, nik, name, birthPlace, birthDate;

  RegisterRequest({
    this.email,
    this.password,
    this.roleId,
    this.nik,
    this.name,
    this.birthPlace,
    this.birthDate
  });

  factory RegisterRequest.fromMap(Map<String, dynamic> map) {
    return new RegisterRequest(
      email: map['email'] as String,
      password: map['password'] as String,
      roleId: map['role_id'] as String,
      nik: map['nik'] as String,
      name: map['name'] as String,
      birthPlace: map['birth_place'] as String,
      birthDate: map['birth_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': this.email,
      'password': this.password,
      'role_id': this.roleId,
      'nik': this.nik,
      'name': this.name,
      'birth_place': this.birthPlace,
      'birth_date': this.birthDate,
    } as Map<String, dynamic>;
  }
}