import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/user_model.dart';

class ClubDetail {
  ClubModel detailTeam;
  List<UserModel> teamPlayer;
  List<TeamCoach> teamCoach;

  ClubDetail({this.detailTeam, this.teamPlayer, this.teamCoach});

  ClubDetail.fromJson(Map<String, dynamic> json) {
    detailTeam = json['detailTeam'] != null
        ? new ClubModel.fromJson(json['detailTeam'])
        : null;
    if (json['teamPlayer'] != null) {
      teamPlayer = new List<Null>();
      json['teamPlayer'].forEach((v) {
        teamPlayer.add(new UserModel.fromJson(v));
      });
    }
    if (json['teamCoach'] != null) {
      teamCoach = new List<TeamCoach>();
      json['teamCoach'].forEach((v) {
        teamCoach.add(new TeamCoach.fromJson(v));
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
  UserModel detail;
  List<Document> document;

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