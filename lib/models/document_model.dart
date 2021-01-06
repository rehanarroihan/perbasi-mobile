class DocumentModel {
  int id;
  String coachId;
  String documentType;
  String file;
  String fileType;
  String createdAt;
  String updatedAt;
  Null createdBy;

  DocumentModel(
      {this.id,
        this.coachId,
        this.documentType,
        this.file,
        this.fileType,
        this.createdAt,
        this.updatedAt,
        this.createdBy});

  DocumentModel.fromJson(Map<String, dynamic> json) {
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