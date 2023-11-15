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
  print("Check Auth: ${authController.phoneNumber}");
  var response =await http.post(Uri.parse(clientInfoAddress),body: {
    'phoneNum' : encrypt(authController.phoneNumber)
  });
  print(getBool("accountType"));
  print("doc id  ${getInt("doctorId")}");
  if(response.statusCode == 403) {
    authorized = false;
    reasonUnAuthorized = "Number not found";
  }
  else {
    authorized = sessionTimedOut();
    reasonUnAuthorized = "15 days passed";
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
    authController.welcomeMsg.value = "Number used is no longer associated with an account, contact SIGMA.";
    authController.welcomeMsgColor = Colors.red;
    Get.clearRouteTree();
    Get.offAll(()=>LoginScreen());
  }

}
bool sessionTimedOut(){
  String? firstLoginTime = getString("loginTime");
  print("loginTime $firstLoginTime");
  if (firstLoginTime == null) return true;
  DateTime date =  DateFormat("yMd").parse(firstLoginTime);
  int daysPassed = date.difference(DateTime.now()).inDays;
  print("logged in $daysPassed days ago");
  if (daysPassed > 15)
    return false;
  else
    return true;
}