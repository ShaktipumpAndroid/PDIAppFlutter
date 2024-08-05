// To parse this JSON data, do
//
//     final plantListModel = plantListModelFromJson(jsonString);

import 'dart:convert';

PlantListModel plantListModelFromJson(String str) => PlantListModel.fromJson(json.decode(str));

String plantListModelToJson(PlantListModel data) => json.encode(data.toJson());

class PlantListModel {
  List<PlantDetail> plantDetails;

  PlantListModel({
    required this.plantDetails,
  });

  factory PlantListModel.fromJson(Map<String, dynamic> json) => PlantListModel(
    plantDetails: List<PlantDetail>.from(json["Plant Details"].map((x) => PlantDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Plant Details": List<dynamic>.from(plantDetails.map((x) => x.toJson())),
  };
}

class PlantDetail {
  String? werks;
  String? name1;

  PlantDetail({
    required this.werks,
    required this.name1,
  });

  factory PlantDetail.fromJson(Map<String, dynamic> json) => PlantDetail(
    werks: json["werks"].toString(),
    name1: json["name1"].toString().contains('1203')?json["name1"].toString().replaceAll("1203", "india"):json["name1"],
  );

  Map<String, dynamic> toJson() => {
    "werks": werks,
    "name1": name1,
  };

  @override
  String toString() {
    return 'PlantDetail{werks: $werks, name1: $name1}';
  }
}
