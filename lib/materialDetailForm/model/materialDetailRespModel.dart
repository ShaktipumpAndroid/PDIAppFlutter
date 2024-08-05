// To parse this JSON data, do
//
//     final materialDetailRespModel = materialDetailRespModelFromJson(jsonString);

import 'dart:convert';

MaterialDetailRespModel materialDetailRespModelFromJson(String str) => MaterialDetailRespModel.fromJson(json.decode(str));

String materialDetailRespModelToJson(MaterialDetailRespModel data) => json.encode(data.toJson());

class MaterialDetailRespModel {
  String status;
  String message;

  MaterialDetailRespModel({
    required this.status,
    required this.message,
  });

  factory MaterialDetailRespModel.fromJson(Map<String, dynamic> json) => MaterialDetailRespModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
