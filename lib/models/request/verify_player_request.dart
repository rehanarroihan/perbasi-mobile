class VerifyPlayerRequest {
  String teamId, playerId, status;

  VerifyPlayerRequest({this.teamId, this.playerId, this.status});

  factory VerifyPlayerRequest.fromMap(Map<String, dynamic> map) {
    return new VerifyPlayerRequest(
      teamId: map['team_id'] as String,
      playerId: map['player_id'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'team_id': this.teamId,
      'player_id': this.playerId,
      'status': this.status,
    } as Map<String, dynamic>;
  }
}