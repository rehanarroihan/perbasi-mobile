class NewsModel {
  int id;
  String title;
  String description;
  List<String> foto;
  String createdAt;
  String updatedAt;
  String createdBy;
  String status;

  NewsModel(
      {this.id,
        this.title,
        this.description,
        this.foto,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    foto = json['foto'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['foto'] = this.foto;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    return data;
  }
}