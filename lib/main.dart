import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdi_app/login/LoginRespModel.dart';
import 'package:pdi_app/theme/color.dart';
import 'package:pdi_app/theme/string.dart';
import 'package:pdi_app/uiwidget/robotoTextWidget.dart';
import 'package:pdi_app/webservice/APIDirectory.dart';
import 'package:pdi_app/webservice/Constant.dart';
import 'package:pdi_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'Util/utility.dart';
import 'home/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print("userid==>${sharedPreferences.getString(userID)}");
  String? isLoggedIn =
      (sharedPreferences.getString(userID) == null) ? False : True;
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  String? isLoggedIn;

  MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: UpgradeAlert(
            dialogStyle: UpgradeDialogStyle.cupertino,
            showIgnore: false,
            showLater: false,
            child: isLoggedIn == True ? HomePage() : LoginPage()));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false, isPasswordVisible = false;
  TextEditingController sapCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColor.whiteColor),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svg/applogo.svg",
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          robotoTextWidget(
                              textval: Login,
                              colorval: AppColor.themeColor,
                              sizeval: 30,
                              fontWeight: FontWeight.bold),
                          const SizedBox(
                            height: 10,
                          ),
                          emailPasswordWidget(),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              signIn();
                            },
                            child: Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
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
                                        textval: Login,
                                        colorval: Colors.white,
                                        sizeval: 14,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: sapCodeController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(8),
            ],
            style: const TextStyle(color: AppColor.themeColor),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person,
                color: AppColor.themeColor,
              ),
              border: InputBorder.none,
              hintText: loginId,
              hintStyle: const TextStyle(color: AppColor.themeColor),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: passwordController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            style: const TextStyle(
              color: AppColor.themeColor,
            ),
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: password,
              hintStyle: const TextStyle(color: AppColor.themeColor),
              prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.lock,
                    color: AppColor.themeColor,
                  )),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.themeColor,
                ),
                onPressed: () {
                  setState(
                    () {
                      isPasswordVisible = !isPasswordVisible;
                    },
                  );
                },
              ),
              alignLabelWithHint: false,
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }

  Future<void> signIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        if (sapCodeController.text.toString().isEmpty) {
          Utility().showInSnackBar(value: sapcodeempty, context: context);
        } else if (passwordController.text.toString().isEmpty) {
          Utility().showInSnackBar(value: passwordMessage, context: context);
        } else {

          if (sharedPreferences.getString(accountDeleteId) != null &&
              sharedPreferences.getString(accountDeleteId).toString().isNotEmpty
              && sharedPreferences.getString(accountDeleteId).toString()== sapCodeController.text.toString()) {

            Utility().showInSnackBar(value: accountIsDeactivated,context: context);
          }else{
            loginAPI();
          }
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Future<void> loginAPI() async {
    setState(() {
      isLoading = true;
    });

    dynamic response = await HTTP.get(userLogin(
        sapCodeController.text.toString(),
        passwordController.text.toString().toUpperCase()));

    if (response != null && response.statusCode == 200) {
      print('response======>${response.body}');
      Iterable l = json.decode(response.body);
      List<LoginRespModel> loginResponse = List<LoginRespModel>.from(
          l.map((model) => LoginRespModel.fromJson(model)));
      if (loginResponse[0].name.isNotEmpty) {
        Utility().showToast(welcome + loginResponse[0].name);
        Utility().setSharedPreference(userName, loginResponse[0].name.trim());
        Utility().setSharedPreference(
            userID, sapCodeController.text.toString().trim());

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);

        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showToast(wrongIdPassword);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Utility().showToast(somethingWentWrong);
      setState(() {
        isLoading = false;
      });
    }
  }
}
