import '../../domain/entities/uploaded_file.dart';

class UploadedResponseModel extends UploadedFile {
  UploadedResponseModel({required super.fileName, required super.url});

  factory UploadedResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadedResponseModel(
      fileName: json['file_name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'file_name': fileName, 'url': url};
  }
}
