import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/document_model.dart';

class ClubDetail {
  ClubModel detailTeam;
  List<TeamPlayer> teamPlayer;
  List<TeamCoach> teamCoach;
  bool canVerification;
  List<PlayerVerification> playerVerification;

  ClubDetail(
      {this.detailTeam,
        this.teamPlayer,
        this.teamCoach,
        this.canVerification,
        this.playerVerification});

  ClubDetail.fromJson(Map<String, dynamic> json) {
    detailTeam = json['detailTeam'] != null
        ? new ClubModel.fromJson(json['detailTeam'])
        : null;
    if (json['teamPlayer'] != null) {
      teamPlayer = new List<TeamPlayer>();
      json['teamPlayer'].forEach((v) {
        teamPlayer.add(new TeamPlayer.fromJson(v));
      });
    }
    if (json['teamCoach'] != null) {
      teamCoach = new List<TeamCoach>();
      json['teamCoach'].forEach((v) {
        teamCoach.add(new TeamCoach.fromJson(v));
      });
    }
    canVerification = json['canVerification'];
    if (json['playerVerification'] != null) {
      playerVerification = new List<PlayerVerification>();
      json['playerVerification'].forEach((v) {
        playerVerification.add(new PlayerVerification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detailTeam != null) {
      data['detailTeam'] = this.detailTeam.toJson();
    }
    if (this.teamPlayer != null) {
      data['teamPlayer'] = this.teamPlayer.map((v) => v.toJson()).toList();
    }
    if (this.teamCoach != null) {
      data['teamCoach'] = this.teamCoach.map((v) => v.toJson()).toList();
    }
    data['canVerification'] = this.canVerification;
    if (this.playerVerification != null) {
      data['playerVerification'] =
          this.playerVerification.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamCoach {
  int id;
  String teamId;
  String coachId;
  String status;
  String createdAt;
  String updatedAt;
  String createdBy;
  Detail detail;
  List<DocumentModel> document;

  TeamCoach(
      {this.id,
        this.teamId,
        this.coachId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.detail,
        this.document});

  TeamCoach.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    coachId = json['coach_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    detail =
    json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    if (json['document'] != null) {
      document = new List<DocumentModel>();
      json['document'].forEach((v) {
        document.add(new DocumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_id'] = this.teamId;
    data['coach_id'] = this.coachId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    if (this.document != null) {
      data['document'] = this.document.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamPlayer {
  int id;
  String teamId;
  String playerId;
  String status;
  String createdAt;
  String updatedAt;
  Null createdBy;
  Detail detail;
  List<DocumentModel> document;

  TeamPlayer(
      {this.id,
        this.teamId,
        this.playerId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.detail,
        this.document});

  TeamPlayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    playerId = json['player_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    detail =
    json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    if (json['document'] != null) {
      document = new List<DocumentModel>();
      json['document'].forEach((v) {
        document.add(new DocumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_id'] = this.teamId;
    data['player_id'] = this.playerId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    if (this.document != null) {
      data['document'] = this.document.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerVerification {
  int id;
  String teamId;
  String playerId;
  String status;
  String createdAt;
  String updatedAt;
  String createdBy;
  Detail detail;
  List<DocumentModel> document;

  PlayerVerification(
      {this.id,
        this.teamId,
        this.playerId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.detail,
        this.document});

  PlayerVerification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    playerId = json['player_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    detail =
    json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    if (json['document'] != null) {
      document = new List<DocumentModel>();
      json['document'].forEach((v) {
        document.add(new DocumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_id'] = this.teamId;
    data['player_id'] = this.playerId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    if (this.document != null) {
      data['document'] = this.document.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  int id;
  String userId;
  String positionId;
  String name;
  String birthPlace;
  String birthDate;
  String address;
  String phone;
  String createdAt;
  String updatedAt;
  String createdBy;
  String status;

  Detail(
      {this.id,
        this.userId,
        this.positionId,
        this.name,
        this.birthPlace,
        this.birthDate,
        this.address,
        this.phone,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    positionId = json['position_id'];
    name = json['name'];
    birthPlace = json['birth_place'];
    birthDate = json['birth_date'];
    address = json['address'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['position_id'] = this.positionId;
    data['name'] = this.name;
    data['birth_place'] = this.birthPlace;
    data['birth_date'] = this.birthDate;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    return data;
  }
}