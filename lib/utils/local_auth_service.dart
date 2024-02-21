import 'package:app/controllers/auth_controller.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'encrypt.dart';
import "package:intl/intl.dart";
final authController = Get.find<AuthController>();

void checkAuthorization() async{
  bool authorized = true;
  String reasonUnAuthorized ="";
  var response =await http.post(Uri.parse(clientInfoAddress),body: {
    'phoneNum' : encrypt(authController.client.value.phone!)
  });

  if(response.statusCode == 403) {
    authorized = false;
    reasonUnAuthorized = "Number not found";
  }
  else {
    authorized = sessionTimedOut();
    reasonUnAuthorized = "24 hours passed";
  }
  if(!authorized) {
    print("Authorization failed,$reasonUnAuthorized, Logging out..");
    bool? accountType =getBool("accountType");
    if (accountType != null) {
      if (accountType == true)
        authController.removeNotificationToken(1);
      else
        authController.removeNotificationToken(0);
    }
    authController.logout();
    authController.errorMsg.value = "Number used is no longer associated with an account, contact SIGMA.";
    authController.errorMsgColor = Colors.red;
    Get.clearRouteTree();
    Get.offAll(()=>LoginScreen());
  }

}
bool sessionTimedOut(){
  String? firstLoginTime = getString("loginTime");
  if (firstLoginTime == null) return true;

  DateTime loginDate =  DateFormat("yyyy-MM-dd hh:mm a").parse(firstLoginTime);
  DateTime now = DateFormat("yyyy-MM-dd hh:mm").parse(DateTime.now().toString());
  Duration minutesPassed = now.difference(loginDate);
  if (minutesPassed.inHours > 24)
    return false;
  else
    return true;
}