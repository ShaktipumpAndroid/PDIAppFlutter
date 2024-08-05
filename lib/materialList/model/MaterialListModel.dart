// To parse this JSON data, do
//
//     final materialListModel = materialListModelFromJson(jsonString);

import 'dart:convert';

MaterialListModel materialListModelFromJson(String str) => MaterialListModel.fromJson(json.decode(str));

String materialListModelToJson(MaterialListModel data) => json.encode(data.toJson());

class MaterialListModel {
  String status;
  String message;
  List<MaterialDetail> materialDetails;

  MaterialListModel({
    required this.status,
    required this.message,
    required this.materialDetails,
  });

  factory MaterialListModel.fromJson(Map<String, dynamic> json) => MaterialListModel(
    status: json["status"],
    message: json["message"],
    materialDetails: List<MaterialDetail>.from(json["Material Details"].map((x) => MaterialDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "Material Details": List<dynamic>.from(materialDetails.map((x) => x.toJson())),
  };
}

class MaterialDetail {
  String werks;
  String qaStock;
  String matnr;
  String lgort;
  String insme;
  String mtart;
  String maktx;

  MaterialDetail({
    required this.werks,
    required this.qaStock,
    required this.matnr,
    required this.lgort,
    required this.insme,
    required this.mtart,
    required this.maktx,
  });

  factory MaterialDetail.fromJson(Map<String, dynamic> json) => MaterialDetail(
    werks: json["werks"],
    qaStock: json["qa_stock"],
    matnr: json["matnr"],
    lgort: json["lgort"],
    insme: json["insme"],
    mtart: json["mtart"],
    maktx: json["maktx"],
  );

  Map<String, dynamic> toJson() => {
    "werks": werks,
    "qa_stock": qaStock,
    "matnr": matnr,
    "lgort": lgort,
    "insme": insme,
    "mtart": mtart,
    "maktx": maktx,
  };
}
