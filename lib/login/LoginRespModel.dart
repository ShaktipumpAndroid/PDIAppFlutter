// To parse this JSON data, do
//
//     final loginRespModel = loginRespModelFromJson(jsonString);

import 'dart:convert';

List<LoginRespModel> loginRespModelFromJson(String str) => List<LoginRespModel>.from(json.decode(str).map((x) => LoginRespModel.fromJson(x)));

String loginRespModelToJson(List<LoginRespModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginRespModel {
  String login;
  String name;

  LoginRespModel({
    required this.login,
    required this.name,
  });

  factory LoginRespModel.fromJson(Map<String, dynamic> json) => LoginRespModel(
    login: json["LOGIN"],
    name: json["NAME"],
  );

  Map<String, dynamic> toJson() => {
    "LOGIN": login,
    "NAME": name,
  };
}
