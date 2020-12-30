class ClubModel {
  int id;
  String name;
  String type;
  String sejarah;
  String logo;
  String createdAt;
  String updatedAt;
  String createdBy;
  String status;

  ClubModel(
      {this.id,
        this.name,
        this.type,
        this.sejarah,
        this.logo,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status});

  ClubModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    sejarah = json['sejarah'];
    logo = json['logo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['sejarah'] = this.sejarah;
    data['logo'] = this.logo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    return data;
  }
}