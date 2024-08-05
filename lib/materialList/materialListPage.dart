import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdi_app/materialList/model/MaterialListModel.dart';
import 'package:pdi_app/materialList/model/PlantListModel.dart';
import 'package:pdi_app/materialDetailForm/materialDetailPage.dart';
import 'package:pdi_app/theme/string.dart';
import 'package:pdi_app/uiwidget/robotoTextWidget.dart';
import 'package:pdi_app/webservice/APIDirectory.dart';
import 'package:pdi_app/webservice/HTTP.dart' as HTTP;

import '../Util/utility.dart';
import '../theme/color.dart';

class MaterialListPage extends StatefulWidget {

  MaterialListPage({Key? key,required this.isSemiFinished}) : super(key: key);
  bool isSemiFinished;

  @override
  State<MaterialListPage> createState() => _MaterialListPageState();
}

class _MaterialListPageState extends State<MaterialListPage> {
  String? selectedPlant;
  bool isLoading = false;
  List<PlantDetail> plantList = [];
  List<MaterialDetail> materialList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        getPlant();
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.themeColor,
          elevation: 5,
          title: robotoTextWidget(
              textval: materialListPage,
              colorval: Colors.white,
              sizeval: 14,
              fontWeight: FontWeight.w800),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
            onPressed: () { Navigator.pop(context); },
          ),
        ),
        body:
          Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                plantList.isNotEmpty ? dayTypeSpinnerWidget() : Container(),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          child: _buildPosts(context)),
                ),
              ]))
        );
  }

  dayTypeSpinnerWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.themeColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
            hintText: selectPlantList,
            fillColor: Colors.white),
        value: selectedPlant,
        validator: (value) => value == null ? selectPlantList : "",
        items: plantList
            .map((plants) => DropdownMenuItem(
                value: plants.werks,
                child: robotoTextWidget(
                    textval: plants.name1! + " (" + plants.werks! + ")",
                    colorval: AppColor.themeColor,
                    sizeval: 12,
                    fontWeight: FontWeight.bold)))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            selectedPlant = value.toString();
            Utility().checkInternetConnection().then((connectionResult) {
              if (connectionResult) {
                if(widget.isSemiFinished) {
                  getMaterialList(getMaterial(selectedPlant!));
                }else{
                  getMaterialList(getMaterialFinishedList(selectedPlant!)!);
                }
              } else {
                Utility().showInSnackBar(
                    value: checkInternetConnection, context: context);
              }
            });
          });
        },
      ),
    );
  }

  Future<void> getPlant() async {
    var jsonData;
    plantList = [];
    dynamic response = await HTTP.get(getPlantList());
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      print('jsonData======>${jsonData}');
      PlantListModel plantListModel = PlantListModel.fromJson(jsonData);
      if (mounted) {
        setState(() {
          plantList = plantListModel.plantDetails;
        });
      }
    }
  }

  Future<void> getMaterialList(Uri url) async {
    setState(() {
      isLoading = true;
    });
    var jsonData;
    materialList = [];
    dynamic response = await HTTP.get(url);
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      print('jsonData======>${jsonData}');
      MaterialListModel materialListModel =
          MaterialListModel.fromJson(jsonData);
      if (materialListModel.status == "True") {
        if (mounted) {
          setState(() {
            isLoading = false;
            materialList = materialListModel.materialDetails;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  _buildPosts(BuildContext context) {
    if (materialList.isEmpty) {
      return Center(
          child: robotoTextWidget(
              textval: noDataAvailable,
              colorval: Colors.black,
              sizeval: 14,
              fontWeight: FontWeight.w600,
            ));
    }
    return ListView.builder(
          itemBuilder: (context, index) {
            return ListItem(index);
          },
          itemCount: materialList.length,
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 20),
        );
  }

  ListItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MaterialDetailPage(materialDetail: materialList[index]),),
                (route) => true);

      },
       child:  Card(
          elevation: 2,
          color: Colors.white,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                itemsWiget(
                    materialCode, materialList[index].matnr.toString().trim()),
                itemsWiget(
                    materialQuantity, materialList[index].insme.toString().trim()),
                itemsWiget(
                    materialDesc, materialList[index].maktx.toString().trim()),
              ],
            ),
          ),
        )
    );
  }

  itemsWiget(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: robotoTextWidget(
                  textval: title,
                  colorval: AppColor.themeColor,
                  sizeval: 14,
                  fontWeight: FontWeight.w800)),
          robotoTextWidget(
              textval: value,
              colorval: AppColor.blackColor,
              sizeval: 12,
              fontWeight: FontWeight.w600)
        ],
      ),
    );
  }
}
