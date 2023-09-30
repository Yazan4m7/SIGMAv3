import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../controllers/remote_services_controller.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.put(AuthController());
  final remoteServices = Get.put(RemoteServicesController());
  var receivedID = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: kBlack,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                _buildLogo(),
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 300.w,
                    height: 500.h,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: kWhite,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _greetingText(),
                        SizedBox(
                          height: 45.h,
                        ),
                        _phoneTextField(),
                        SizedBox(
                          height: 45.h,
                        ),
                        _sendCodeBtn()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Image.asset(
          "assets/images/logo.png",
        ),
      ),
    );
  }

  Widget _greetingText() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 25.h),
        Text(
          "Hello",
          style: GoogleFonts.raleway(fontSize: 35.sp),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            ()=> Text(
              authController.welcomeMsg.value,
              style: GoogleFonts.raleway(fontSize: 15.sp,color: authController.welcomeMsgColor),
            ),
          ),
        )

      ],
    );
  }

  Widget _phoneTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              blurRadius: 10.0,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
        child: TextField(
          style: TextStyle(fontFamily: fontFamily),
          controller: authController.phoneTextFieldController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(

            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  '+962 ',
                  style: TextStyle(fontSize: 16.sp),
                )),
            hintText: "78 xxx xxxx",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 32.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 32.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sendCodeBtn() {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.transparent)))),
        onPressed: () async{
          if(validateMobile(authController.phoneTextFieldController.text.trim())){
            if(await phoneExistsInSystem(authController.phoneTextFieldController.text.trim())){
        AuthController.instance.sendOtp("+962${authController.phoneTextFieldController.text.trim()}");
        Get.to(()=> const OtpScreen());
            }
            else{
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("Alert"),
                      content: Text("Phone number not associated with an account, contact SIGMA."),
                    );});
            }

          }
          else{
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                      title: Text("Alert"),
                    content: Text("Invalid Phone Number"),
                  );});
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "SEND CODE",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  bool validateMobile(String value) {
    if(value.substring(0,1)=="0")
      value = value.substring(1,value.length);
    if(value.substring(0,2) != "78" && value.substring(0,2) != "79" && value.substring(0,2) != "79" ) {
      print(value.substring(0,2) + " No Carrier Number");
      return false;
    }
    if(value.length != 9) {
      print("${value} length less than 9");
      return false;
    }
    return true;
  }

  phoneExistsInSystem(String value) async{
    var response = await http.post(Uri.parse(checkIfPhoneExistsAddress),
        body: {'phoneNum': value});
    print(response.body);
    return response.body == "1" ? true : false;
  }
}
