import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import 'otp_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = Get.put(AuthController());
  var otp = '';
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
                        _otpTextField(),
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
        Text(
          "Please enter the OTP sent your number",
          style: GoogleFonts.raleway(fontSize: 15.sp),
        )
      ],
    );
  }

  Widget _otpTextField() {
    return OtpTextField(
      numberOfFields: 6,

      showFieldAsBox: false,
      borderWidth: 4.0,
      //runs when a code is typed in
      onCodeChanged: (String code) {
        otp = code;
      },
      //runs when every textfield is filled
      onSubmit: (String verificationCode) {
        AuthController.instance.verifyOtp(verificationCode);

      },
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
          AuthController.instance.verifyOtp(otp);

        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "VERIFY",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

}
