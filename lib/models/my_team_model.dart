import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/user_model.dart';

class MyTeamModel {
  ClubModel detailTeam;
  List<UserModel> teamPlayer;
  List<UserModel> teamCoach;
  bool canVerification;
  List<PlayerVerification> playerVerification;

  MyTeamModel(
      {this.detailTeam,
        this.teamPlayer,
        this.teamCoach,
        this.canVerification,
        this.playerVerification});

  MyTeamModel.fromJson(Map<String, dynamic> json) {
    detailTeam = json['detailTeam'] != null
        ? new ClubModel.fromJson(json['detailTeam'])
        : null;
    if (json['teamPlayer'] != null) {
      teamPlayer = new List<UserModel>();
      json['teamPlayer'].forEach((v) {
        teamPlayer.add(new UserModel.fromJson(v));
      });
    }
    if (json['teamCoach'] != null) {
      teamCoach = new List<UserModel>();
      json['teamCoach'].forEach((v) {
        teamCoach.add(new UserModel.fromJson(v));
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

class PlayerVerification {
  int id;
  String teamId;
  String playerId;
  String status;
  String createdAt;
  String updatedAt;
  Null createdBy;
  UserModel detail;
  List<Document> document;

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
    json['detail'] != null ? new UserModel.fromJson(json['detail']) : null;
    if (json['document'] != null) {
      document = new List<Document>();
      json['document'].forEach((v) {
        document.add(new Document.fromJson(v));
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

class Document {
  int id;
  String coachId;
  String documentType;
  String file;
  String fileType;
  String createdAt;
  String updatedAt;
  Null createdBy;

  Document(
      {this.id,
        this.coachId,
        this.documentType,
        this.file,
        this.fileType,
        this.createdAt,
        this.updatedAt,
        this.createdBy});

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coachId = json['coach_id'];
    documentType = json['document_type'];
    file = json['file'];
    fileType = json['file_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coach_id'] = this.coachId;
    data['document_type'] = this.documentType;
    data['file'] = this.file;
    data['file_type'] = this.fileType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    return data;
  }
}