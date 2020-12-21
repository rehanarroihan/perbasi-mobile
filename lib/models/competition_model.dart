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

  CompetitionModel(
      {this.id,
        this.name,
        this.description,
        this.fileRequirement,
        this.foto,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status});

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
    return data;
  }
}