class ChangePasswordRequest {
  String old_password, password, password_confirmation;

  ChangePasswordRequest(
      {this.old_password,
        this.password,
        this.password_confirmation,
      });

  factory ChangePasswordRequest.fromMap(Map<String, dynamic> map) {
    return new ChangePasswordRequest(
      old_password: map['old_password'] as String,
      password: map['password'] as String,
      password_confirmation: map['password_confirmation'] as String,
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    // ignore: unnecessary_cast
    return {
      'old_password': this.old_password,
      'password': this.password,
      'password_confirmation': this.password_confirmation,
    } as Map<String, dynamic>;
  }
}