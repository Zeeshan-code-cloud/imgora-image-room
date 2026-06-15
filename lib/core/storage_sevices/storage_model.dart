import 'dart:convert';

class StorageModel {
  String imageName;
  String imageFormat;
  String imagePath;
  String? operationType;
  String? date;

  StorageModel({
    required this.imageName,
    required this.imageFormat,
    required this.imagePath,
    this.operationType,
    this.date,
  });

  Map<String, dynamic> ToJson() {
    return {
      "imageName": imageName,
      "imageFormat": imageFormat,
      "imagePath": imagePath,
      "operationType": operationType,
      "date": date,
    };
  }

  factory StorageModel.fromJson(Map<String, dynamic> map) {
    return StorageModel(
      imageName: map["imageName"],
      imageFormat: map["imageFormat"],
      imagePath: map["imagePath"],
      operationType: map["operationType"],
      date: map["date"],
    );
  }

  String toJson() => jsonEncode(ToJson());

  factory StorageModel.FromJson(String source) {
    return StorageModel.fromJson(jsonDecode(source));
  }
}
