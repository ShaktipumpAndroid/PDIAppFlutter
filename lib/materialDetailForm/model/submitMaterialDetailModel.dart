// To parse this JSON data, do
//
//     final submitMaterialDetailModel = submitMaterialDetailModelFromJson(jsonString);

import 'dart:convert';

List<SubmitMaterialDetailModel> submitMaterialDetailModelFromJson(String str) => List<SubmitMaterialDetailModel>.from(json.decode(str).map((x) => SubmitMaterialDetailModel.fromJson(x)));

String submitMaterialDetailModelToJson(List<SubmitMaterialDetailModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubmitMaterialDetailModel {
  String matCode;
  String matDes;
  String design;
  String okQty;
  String offQty;
  String rejQty;
  String observation;
  String qaRemarks;
  String plant;
  String reworkQty;
  String lgort;
  String pernr;

  SubmitMaterialDetailModel({
    required this.matCode,
    required this.matDes,
    required this.design,
    required this.okQty,
    required this.offQty,
    required this.rejQty,
    required this.observation,
    required this.qaRemarks,
    required this.plant,
    required this.reworkQty,
    required this.lgort,
    required this.pernr,
  });

  factory SubmitMaterialDetailModel.fromJson(Map<String, dynamic> json) => SubmitMaterialDetailModel(
    matCode: json["mat_code"],
    matDes: json["mat_des"],
    design: json["design"],
    okQty: json["ok_qty"],
    offQty: json["off_qty"],
    rejQty: json["rej_qty"],
    observation: json["observation"],
    qaRemarks: json["qa_remarks"],
    plant: json["plant"],
    reworkQty: json["rework_qty"],
    lgort: json["lgort"],
    pernr: json["PERNR"],
  );

  Map<String, dynamic> toJson() => {
    "mat_code": matCode,
    "mat_des": matDes,
    "design": design,
    "ok_qty": okQty,
    "off_qty": offQty,
    "rej_qty": rejQty,
    "observation": observation,
    "qa_remarks": qaRemarks,
    "plant": plant,
    "rework_qty": reworkQty,
    "lgort": lgort,
    "PERNR": pernr,
  };
}
