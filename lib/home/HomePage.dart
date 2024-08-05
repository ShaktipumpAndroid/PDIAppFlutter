import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdi_app/materialList/materialListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../main.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/Constant.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
          elevation: 5,
          shadowColor: Theme.of(context).shadowColor,
          title: robotoTextWidget(
              textval: appName,
              colorval: Colors.white,
              sizeval: 14,
              fontWeight: FontWeight.w800),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                // PopupMenuItem 1
                PopupMenuItem(
                  value: 1,
                  // row with 2 children
                  child: Row(
                    children: [
                      const Icon(
                        Icons.exit_to_app,
                        color: AppColor.themeColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      robotoTextWidget(
                          textval: logout,
                          colorval: AppColor.themeColor,
                          sizeval: 16,
                          fontWeight: FontWeight.w600)
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  // row with 2 children
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        color: AppColor.themeColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      robotoTextWidget(
                          textval: deleteAccount,
                          colorval: AppColor.themeColor,
                          sizeval: 16,
                          fontWeight: FontWeight.w600)
                    ],
                  ),
                ),
              ],

              color: Colors.white,
              elevation: 2,
              // on selected we show the dialog box
              onSelected: (value) {
                // if value 1 show dialog
                if (value == 1) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => dialogueLogout(context,0),
                  );
                }
                if (value == 2) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => dialogueLogout(context,1),
                  );
                }
              },
            ),
          ]),
      body: Column(
        children: [
          cardWidget('SemiFinished List', 'assets/svg/semi_finished.svg', 0),
          cardWidget('Finished List', 'assets/svg/finished.svg', 1),
        ],
      ),
    );
  }

  cardWidget(String title, String svg, int value) {
    return GestureDetector(
        onTap: () {
          if (value == 0) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => MaterialListPage(
                          isSemiFinished: true,
                        )),
                (route) => true);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => MaterialListPage(
                          isSemiFinished: false,
                        )),
                (route) => true);
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  svg,
                  width: 150,
                  height: 150,
                ),
                robotoTextWidget(
                    textval: title,
                    colorval: AppColor.themeColor,
                    sizeval: 14,
                    fontWeight: FontWeight.w800)
              ],
            ),
          ),
        ));
  }

  Widget dialogueLogout(BuildContext context, int value) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              appName,
              style: const TextStyle(
                  color: AppColor.themeColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value == 0 ? logoutConfirmation : deleteAccountConfirmation,
            style: const TextStyle(
                color: AppColor.themeColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: robotoTextWidget(
                    textval: cancel,
                    colorval: Colors.grey,
                    sizeval: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    confirmLogout(value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: robotoTextWidget(
                    textval: confirm,
                    colorval: AppColor.whiteColor,
                    sizeval: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ]));
  }

  Future<void> confirmLogout(int value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String userid = sharedPreferences.getString(userID).toString().trim();
    if(value == 0) {
      Utility().showToast("Logout SuccessFully");
      sharedPreferences.clear();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage()),
              (Route<dynamic> route) => false);
    }else{
      Utility().showToast("Account Delete SuccessFully");
      sharedPreferences.clear();
      Utility().setSharedPreference(accountDeleteId, userid);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage()),
              (Route<dynamic> route) => false);
    }
  }
}
