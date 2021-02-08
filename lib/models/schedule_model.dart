import 'package:perbasitlg/models/club_model.dart';

class ScheduleModel {
  int id;
  String playDate;
  String playTime;
  String teamIdAway;
  String teamIdHome;
  String competitionId;
  Results results;
  ClubModel teamHome;
  ClubModel teamAway;

  ScheduleModel(
      {this.id,
        this.playDate,
        this.playTime,
        this.teamIdAway,
        this.teamIdHome,
        this.competitionId,
        this.results,
        this.teamHome,
        this.teamAway});

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playDate = json['play_date'];
    playTime = json['play_time'];
    teamIdAway = json['team_id_away'];
    teamIdHome = json['team_id_home'];
    competitionId = json['competition_id'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
    teamHome = json['team_home'] != null
        ? new ClubModel.fromJson(json['team_home'])
        : null;
    teamAway = json['team_away'] != null
        ? new ClubModel.fromJson(json['team_away'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['play_date'] = this.playDate;
    data['play_time'] = this.playTime;
    data['team_id_away'] = this.teamIdAway;
    data['team_id_home'] = this.teamIdHome;
    data['competition_id'] = this.competitionId;
    if (this.results != null) {
      data['results'] = this.results.toJson();
    }
    if (this.teamHome != null) {
      data['team_home'] = this.teamHome.toJson();
    }
    if (this.teamAway != null) {
      data['team_away'] = this.teamAway.toJson();
    }
    return data;
  }
}

class Results {
  int home;
  int away;

  Results({this.home, this.away});

  Results.fromJson(Map<String, dynamic> json) {
    try {
      home = json['home'];
      away = json['away'];
    } catch (e) {
      home = int.parse(json['home'].toString());
      away = int.parse(json['away'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['away'] = this.away;
    return data;
  }
}