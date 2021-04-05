class VerifyPlayerRequest {
  String registerId, status;

  VerifyPlayerRequest({this.registerId, this.status});

  factory VerifyPlayerRequest.fromMap(Map<String, dynamic> map) {
    return new VerifyPlayerRequest(
      registerId: map['register_id'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'register_id': this.registerId,
      'status': this.status,
    } as Map<String, dynamic>;
  }
}