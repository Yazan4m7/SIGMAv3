import 'package:app/controllers/auth_controller.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/show_up_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/remote_services_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}



class _WelcomeScreenState extends State<WelcomeScreen> {
  final authController = Get.find<AuthController>();
  bool clientInfoLoaded = false;
  @override
  void initState() {
    super.initState();
    authController.getClient().then((value) {
      Future.delayed(const Duration(milliseconds: 6000), () {
        Get.offAll (() =>  HomeScreen());
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(body:  Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(children: [ Positioned.fill(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShowUp(child: LoadingAnimationWidget.dotsTriangle(
                 color: kGreen,
                 size: 90,
               ), delay: 900),
          SizedBox(height: 230.h,),
          ShowUp(child: Text("Welcome",style: TextStyle(fontSize: 29.sp,color: kGreen,fontWeight: FontWeight.w700),), delay: 1500),
          SizedBox(height: 15.h,),
          Obx(() => ShowUp(child: Text(authController.client.value.name != null ?   " د. "+ authController.client.value.name! : "",style: TextStyle(fontSize: 25.sp,color: kGreen,fontWeight: FontWeight.w400,fontFamily: 'Quest'),), delay: 1900))],),
      ),
      ]),
    )
    );
  }
}
