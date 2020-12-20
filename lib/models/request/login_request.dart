class LoginRequest {
  String email, password;

  LoginRequest({this.email, this.password});

  factory LoginRequest.fromMap(Map<String, dynamic> map) {
    return new LoginRequest(
      email: map['email'] as String,
      password: map['password'] as String
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': this.email,
      'password': this.password,
    } as Map<String, dynamic>;
  }
}