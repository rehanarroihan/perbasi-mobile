class CompetitionModel {
  int id;
  String name;
  String description;
  String fileRequirement;
  String foto;
  String createdAt;
  String updatedAt;
  String createdBy;
  String status;
  List<Teams> teams;

  CompetitionModel(
      {this.id,
        this.name,
        this.description,
        this.fileRequirement,
        this.foto,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status,
        this.teams});

  CompetitionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    fileRequirement = json['file_requirement'];
    foto = json['foto'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    status = json['status'];
    if (json['teams'] != null) {
      teams = new List<Teams>();
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['file_requirement'] = this.fileRequirement;
    data['foto'] = this.foto;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teams {
  int id;
  String status;
  Team team;

  Teams({this.id, this.status, this.team});

  Teams.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.team != null) {
      data['team'] = this.team.toJson();
    }
    return data;
  }
}

class Team {
  int id;
  String name;
  String type;
  String logo;

  Team({this.id, this.name, this.type, this.logo});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['logo'] = this.logo;
    return data;
  }
}