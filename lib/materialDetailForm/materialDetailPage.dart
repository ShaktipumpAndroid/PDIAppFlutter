import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:pdi_app/materialDetailForm/model/materialDetailRespModel.dart';
import 'package:pdi_app/materialDetailForm/model/submitMaterialDetailModel.dart';
import 'package:pdi_app/theme/color.dart';
import 'package:pdi_app/uiwidget/robotoTextWidget.dart';
import 'package:pdi_app/webservice/Constant.dart';
import 'package:pdi_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../materialList/model/MaterialListModel.dart';
import '../theme/string.dart';
import '../webservice/APIDirectory.dart';

class MaterialDetailPage extends StatefulWidget {
  MaterialDetailPage({Key? key, required this.materialDetail})
      : super(key: key);

  MaterialDetail materialDetail;

  @override
  State<MaterialDetailPage> createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage> {
  bool isLoading = false;
  TextEditingController matCodeController = TextEditingController();
  TextEditingController matDescController = TextEditingController();
  TextEditingController offerQtyController = TextEditingController();
  TextEditingController okQtyController = TextEditingController();
  TextEditingController reworkQtyController = TextEditingController();
  TextEditingController rejectController = TextEditingController();
  TextEditingController processController = TextEditingController();
  TextEditingController designController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController qaRemarkController = TextEditingController();

  List<SubmitMaterialDetailModel> submitDataList = [];
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: robotoTextWidget(
            textval: materialDetails,
            colorval: AppColor.whiteColor,
            sizeval: 14,
            fontWeight: FontWeight.w800),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                textInputWidget(matCodeTxt, matCode, TextInputType.text,
                    matCodeController, false),
                textInputWidget(matDescTxt, matDesc, TextInputType.text,
                    matDescController, false),
                textInputWidget(offerQtyTxt, offerQty, TextInputType.number,
                    offerQtyController, false),
                textInputWidget(okQtyTxt, okQty, TextInputType.number,
                    okQtyController, true),
                textInputWidget(reworkQtyTxt, reworkQty, TextInputType.number,
                    reworkQtyController, true),
                textInputWidget(rejectTxt, rejectQty, TextInputType.number,
                    rejectController, true),
                textInputWidget(processTxt, processQty, TextInputType.number,
                    processController, true),
                textInputWidget(designTxt, designQty, TextInputType.number,
                    designController, true),
                textInputWidget(observationTxt, observation, TextInputType.text,
                    observationController, true),
                textInputWidget(qaRemarkTxt, qaRemark, TextInputType.text,
                    qaRemarkController, true),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: submitWidget(),
        )
      ]),
    );
  }

  textInputWidget(String hint, String heading, TextInputType inputType,
      TextEditingController textEditingController, bool isEnable) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        margin: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            robotoTextWidget(
                textval: heading,
                colorval: AppColor.themeColor,
                sizeval: 12,
                fontWeight: FontWeight.bold),
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.themeColor),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                  enabled: isEnable,
                  controller: textEditingController,
                  style: const TextStyle(
                      color: AppColor.themeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.edit_note,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(
                        color: AppColor.themeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  keyboardType: inputType,
                  textInputAction: hint == qaRemarkTxt
                      ? TextInputAction.done
                      : TextInputAction.next),
            )
          ],
        ));
  }

  submitWidget() {
    return GestureDetector(
        onTap: () {
          validation();
        },
        child: Container(
          margin: const EdgeInsets.all(7.0),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColor.themeColor),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: AppColor.whiteColor,
                    ),
                  )
                : robotoTextWidget(
                    textval: submit,
                    colorval: Colors.white,
                    sizeval: 14,
                    fontWeight: FontWeight.bold),
          ),
        ));
  }

  void validation() {
    if (matCodeController.text.toString().isEmpty) {
      Utility().showToast(matCodeTxt);
    } else if (matDescController.text.toString().isEmpty) {
      Utility().showToast(matDescTxt);
    } else if (offerQtyController.text.toString().isEmpty) {
      Utility().showToast(offerQtyTxt);
    } else if (okQtyController.text.toString().isEmpty) {
      Utility().showToast(okQtyTxt);
    } else if (reworkQtyController.text.toString().isEmpty) {
      Utility().showToast(reworkQtyTxt);
    } else if (rejectController.text.toString().isEmpty) {
      Utility().showToast(rejectTxt);
    } else if (processController.text.toString().isEmpty) {
      Utility().showToast(processTxt);
    } else if (designController.text.toString().isEmpty) {
      Utility().showToast(designTxt);
    } else if (observationController.text.toString().isEmpty) {
      Utility().showToast(observationTxt);
    } else if (qaRemarkController.text.toString().isEmpty) {
      Utility().showToast(qaRemarkTxt);
    } else {
      submitData();
    }
  }

  Future<void> submitData() async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    submitDataList.clear();
    submitDataList.add(SubmitMaterialDetailModel(
        matCode: matCodeController.text.toString().trim(),
        matDes: matDescController.text.toString().trim(),
        design: designController.text.toString().trim(),
        okQty: okQtyController.text.toString().trim(),
        offQty: offerQtyController.text.toString().trim(),
        rejQty: rejectController.text.toString().trim(),
        observation: observationController.text.toString().trim(),
        qaRemarks: qaRemarkController.text.toString().trim(),
        plant: widget.materialDetail.werks.toString().trim(),
        reworkQty: reworkQtyController.text.toString().trim(),
        lgort: widget.materialDetail.lgort.toString().trim(),
        pernr: sharedPreferences.getString(userID).toString().trim()));

    String value = convert.jsonEncode(submitDataList).toString();
    print("value======>$value");
    dynamic response = await HTTP.get(submitMaterialData(value));
    if (response != null && response.statusCode == 200) {
      print('response=====>${response.body}');
      var jsonData = convert.jsonDecode(response.body);
      MaterialDetailRespModel materialDetailRespModel =
          MaterialDetailRespModel.fromJson(jsonData);
      if (materialDetailRespModel.status == "True") {
        Utility().showToast(materialDetailRespModel.message);
        Navigator.pop(context);
      } else {
        Utility().showToast(materialDetailRespModel.message);
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setData() {
    matCodeController.text =
        widget.materialDetail.matnr.replaceFirst(RegExp(r'^0+(?!$)'), '');
    matDescController.text = widget.materialDetail.maktx;
    offerQtyController.text = widget.materialDetail.insme;
    setState(() {});
  }
}
