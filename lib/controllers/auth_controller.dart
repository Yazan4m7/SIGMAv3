import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:app/models/client.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/constants.dart';
import 'package:app/screens/welcome_screen.dart';
import 'package:app/utils/encrypt.dart';
import 'package:app/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final LocalAuthentication localAuth = LocalAuthentication();
  //late BiometricType _biometricType;
  bool isAuthinticated = true;
  late final AppLifecycleListener _listener;
  Rx<bool> isDoctorAccount = false.obs;
  Rx<String> errorMsg = "Unknown Error".obs;
  Color errorMsgColor = Colors.red;
  Rx<bool> isLoggedIn = false.obs;
  Rx<Client> client = Client().obs;


  @override
  void onReady() {
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
    isLoggedIn.listen((value) {

      if (value) {
        Get.offAll(() => const WelcomeScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  Future<bool> login(String phoneNum, String password) async {
    var response = await http.post(Uri.parse(loginAddress),
        body: {"phoneNum": encrypt(phoneNum), "password": password});

    if (response.statusCode == 200) {
      client.value = Client.fromJson(jsonDecode(response.body));
      setAccessLevel(phoneNum);
      isLoggedIn.value = true;
      setData("isLoggedIn", true);
      setData("phoneNum", phoneNum);
      setData("password", password);
      setData("loginTime",DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()));
      remoteServices.registerLogin();
      Get.offAll(WelcomeScreen());
      return true;
    } else {
      errorMsg.value = jsonDecode(response.body)["msg"];
      logout();
      setData("isLoggedIn", false);
      return false;
    }
  }

  Future<void> logout() async {

    setData("isLoggedIn", false);
    AuthController.instance.isLoggedIn.value == false;
  }

  void setAccessLevel(String phoneNumberEntered) {
   
    if (client.value.phone!.contains(phoneNumberEntered.substring(phoneNumberEntered.length - 7)))
      isDoctorAccount.value = true;
    else
      isDoctorAccount.value = false;

    setData("accountType", isDoctorAccount.value);
  }

  Future<void> removeNotificationToken(int accountType) async {
    int? docId = getInt("doctorId");
    if (docId == null) docId = client.value.id;
    if (docId != null) {
      var response = await http.post(Uri.parse(removeTokenAddress), body: {
        'docId': docId.toString(),
        "accountType": accountType.toString()
      });
      print(
          "removed notification token, doc id  : $docId, response :${response.body} ");
    }
  }

  Future<String> getClient() async {
    var phoneNum = getData("phoneNum");
    var response = await http.post(Uri.parse(clientInfoAddress),
        body: {'phoneNum': encrypt(phoneNum)});
    if (response.statusCode == 403) {
      print("account not found, logging out..");
      logout();
      return "null";
    }
    client.value = Client.fromJson(jsonDecode(response.body));

    remoteServices.fetchData();
    setAccessLevel(phoneNum);
    setData("doctorId", client.value.id);
    return "null";
  }

  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        {print("Lifecycle detached");
          break;}
      case AppLifecycleState.resumed:
        {
        if(DateTime.now().millisecondsSinceEpoch - (getData("backgroundTime")??0) >= 3600000 && !isAuthinticated)
        biometricCheck();break;}
      case AppLifecycleState.inactive:
        {print("Lifecycle inactive");break;}
      case AppLifecycleState.hidden:
        {print("Lifecycle hidden");break;}
      case AppLifecycleState.paused:
        {setData("backgroundTime", DateTime.now().millisecondsSinceEpoch);
        isAuthinticated = false;
          print("Lifecycle paused");break;}
    }
  }

  Future<bool> biometricCheck() async {

    try {
      final bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions(biometricOnly: true));
      isAuthinticated = didAuthenticate;
      return didAuthenticate;
    }catch(e){
      print("No phone auth method found ");
    }
    return false;
  }

  Future<void> logSignInAction()async {}
}
