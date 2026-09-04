class UploadDocumentModel {
  bool success;
  UploadDocumentModel({required this.success});

  factory UploadDocumentModel.fromJson(Map<String, dynamic> json) {
    return UploadDocumentModel(
      success: json["success"],
    );
  }
}
