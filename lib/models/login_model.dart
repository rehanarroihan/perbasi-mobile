class LoginModel {
  bool success;
  int statusCode;
  String accessToken;
  String tokenType;

  LoginModel({this.success, this.statusCode, this.accessToken, this.tokenType});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    return data;
  }
}