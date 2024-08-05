import 'package:flutter/material.dart';


const productionUrl = 'https://spprdsrvr1.shaktipumps.com:8423/sap/bc/bsp/sap/';

userLogin(String sapCode, String password) {
  return Uri.parse('${productionUrl}zpdi_app/login_pdi.htm?pernr=${sapCode}&pass=${password}');
}

getPlantList() {
  return Uri.parse('${productionUrl}zpdi_app/plant_list.htm');
}

getMaterial(String plantId){
  return Uri.parse('${productionUrl}zpdi_app/material_list.htm?post=$plantId');
}

getMaterialFinishedList(String plantId){
  return Uri.parse('${productionUrl}zpdi_app/finish_list.htm?post=$plantId');
}

submitMaterialData(String value){
  return Uri.parse('${productionUrl}zpdi_app/pdi_data.htm?post=$value');
}
