
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';


class Utility {

  bool isActiveConnection = false;
   Future<bool> checkInternetConnection() async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isActiveConnection = true;
      return  Future<bool>.value(isActiveConnection);
      }
    } on SocketException catch (_) {
      isActiveConnection = false;
      return  Future<bool>.value(isActiveConnection);
    }
    return  Future<bool>.value(isActiveConnection);
  }

 void showInSnackBar({required String value,required context}) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(value),
       duration: const Duration(milliseconds: 3000),
     ),
   );
 }



  void showToast(String toast_msg) {
    Fluttertoast.showToast(
        msg: toast_msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 9);
  }



  setSharedPreference(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  clearSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  String formatAddress(String address) {
    var formated = address
        .replaceAllMapped(
        new RegExp(r'[A-Za-z0-9]+\+[A-Za-z0-9]+,(.*)', caseSensitive: false),
            (Match m) => "${m[1]}")
        .replaceAllMapped(
        new RegExp(r'(^.*).*karnataka[+ \n\t\r\f]*,*.*',
            caseSensitive: false),
            (Match m) => "${m[1]}")
        .replaceAllMapped(
        new RegExp(r'(^.*).*india[ \n\t\r\f]*,*.*', caseSensitive: false),
            (Match m) => "${m[1]}")
        .replaceAll(new RegExp("[0-9]{6}"), '') //pincode
        .replaceAll(new RegExp("[+ \n\t\r\f],"), '')
        .replaceAll(new RegExp("[+ \n\t\r\f,]\$"), '')
        .replaceAll(new RegExp("[+ \n\t\r\f]"), ' ')
        .replaceAll(new RegExp("^[,]"), '')
        .replaceAll(new RegExp("[,]\$"), '');

    return formated;
  }


  static String getBase64FormateFile(String path) {
    File file = File(path);
    print('File is = ' + file.toString());
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }

  static String convertDateFormat(String dateTimeString, String oldFormat, String
  newFormat) {
    print('dateTimeString$dateTimeString');
    DateFormat newDateFormat = DateFormat(newFormat);
    DateTime dateTime = DateFormat(oldFormat).parse(dateTimeString);
    String selectedDate = newDateFormat.format(dateTime);
    return selectedDate;
  }
  double calculateDistance(lat1, lon1, lat2, lon2){

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    var Km = 12742 * asin(sqrt(a));
    return Km * 1000;
  }



 }