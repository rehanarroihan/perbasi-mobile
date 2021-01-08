class ExitClubRequest {
  String teamId, playerId;

  ExitClubRequest({this.teamId, this.playerId});

  factory ExitClubRequest.fromMap(Map<String, dynamic> map) {
    return new ExitClubRequest(
      teamId: map['team_id'] as String,
      playerId: map['player_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'team_id': this.teamId,
      'player_id': this.playerId,
    } as Map<String, dynamic>;
  }
}