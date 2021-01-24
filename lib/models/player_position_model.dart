class PlayerPositionModel {
  int id;
  String name;
  String createdAt;
  String updatedAt;
  String createdBy;
  String status;

  PlayerPositionModel(
      {this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status});

  PlayerPositionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    return data;
  }
}