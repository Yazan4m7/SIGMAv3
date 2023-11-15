import 'package:app/controllers/remote_services_controller.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/client.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
class AuthController extends GetxController {
static AuthController get instance => Get.find();

final _auth =FirebaseAuth.instance;
late final Rx<User?> firebaseUser;
var verificationId = ''.obs;
var phoneNumber = "null";
Rx<String> welcomeMsg ="Please enter your phone number".obs;
Color welcomeMsgColor = Colors.black87;
bool isLoggingOut = false;
TextEditingController phoneTextFieldController = TextEditingController();
TextEditingController otpTextFieldController = TextEditingController();

@override
void onReady(){
  print("auth controller on ready");
  firebaseUser = Rx<User?>(_auth.currentUser);
  firebaseUser.bindStream(_auth.userChanges());
  phoneNumber = firebaseUser.value?.phoneNumber ?? "null";
  ever(firebaseUser,_setInitialScreen);
}
Future<void> sendOtp( String phoneNo) async{
  phoneNumber = phoneNo;
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNo,
    verificationCompleted: (PhoneAuthCredential credential) async{
      await _auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
        Get.snackbar("", "The provided phone number is not valid");
      }else {
        print(e.code);
        Get.snackbar("", e.code);
      }

      // Handle other errors
    },
    codeSent: (String verificationId, int? resendToken) {
      this.verificationId.value = verificationId;
      print("verif id : ${this.verificationId.value}");
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      this.verificationId.value = verificationId;
    },
  ) ;
}
Future<bool> verifyOtp (String otp) async {
  var credentials;
  try {
     credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));

     if(credentials.user != null){
       setData("phone",phoneNumber);

       if(getString("loginTime") == null)
       setData("loginTime",DateFormat('yMd').format(DateTime.now()));
      }
  } catch(e){
    print("Verification failed $e");
    welcomeMsg.value = "Phone Verification Failed, Please try again.";
    welcomeMsgColor = Colors.red;
  }
  if(credentials ==null){
    welcomeMsg.value = "Phone Verification Failed, Please try again.";
    welcomeMsgColor = Colors.red;
    Get.to(()=>const LoginScreen());
    return false;
  }
  return credentials.user != null ? true : false;
}
_setInitialScreen(User? user) async{
  print("auth controller _setInitialScreen");
  if(isLoggedIn()) {
    print(" is logging out : $isLoggingOut");
    if (!isLoggingOut) {
      await RemoteServicesController.instance.getClient();
    }
    if (RemoteServicesController.instance.client.value.name == null) {
      print("Client name is null logging out.");
      Get.offAll(() => const LoginScreen());
    } else {
      print("Client name is not null.");
      Get.offAll(() => const HomeScreen());
    }
    isLoggingOut = false;
  }
  else{
    Get.offAll(() => const LoginScreen());
    isLoggingOut = false;
  }
}
isLoggedIn(){
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  } else {
    return false;
  }}
Future<void> logout() async {
  isLoggingOut = true;
  welcomeMsg.value ="Please enter your phone number";
  RemoteServicesController.instance.client =Client().obs;
  _auth.signOut();

}

Future<void> removeNotificationToken(int accountType)async {
  int? docId = getInt("doctorId");
  if (docId == null)
    docId = remoteServices.client.value.id;
  if (docId !=null){
    var response =await http.post(Uri.parse(removeTokenAddress),body: {
      'docId' : docId.toString(),
      "accountType" : accountType.toString()
    });
    print("removed notification token, doc id  : $docId, response :${response.body} ");
  }


}


}