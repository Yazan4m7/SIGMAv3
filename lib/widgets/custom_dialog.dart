import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../screens/account_statement.dart';
import '../screens/cases_screen.dart';
import '../utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;


  const CustomDialogBox({ required this.title, required this.descriptions, required this.text}) : super();

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {


  @override
  void initState() {
    playSound();
    super.initState();
  }
  void playSound() async{
    final AudioPlayer player = AudioPlayer();
    await player.play(AssetSource("sounds/notification.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: dialogPadding,top: dialogAvatarRadius
              + dialogPadding, right: dialogPadding,bottom: dialogPadding
          ),
          margin: const EdgeInsets.only(top: dialogAvatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(dialogPadding),
              boxShadow: const [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.w600),),
              SizedBox(height: 15.h,),
              Text(widget.descriptions,style: TextStyle(fontSize: 16.sp),textAlign: TextAlign.center,),
              SizedBox(height: 22.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [TextButton(
                  onPressed: (){
                    Navigator.of(navigatorKey.currentContext!).pop();
                  },
                  child: Text("Close",style: TextStyle(fontSize: 18.sp),)),TextButton(
                    onPressed: (){
                      if(widget.text =="View Cases"){
                        Navigator.of(navigatorKey.currentContext!).pop();
                      Navigator.of(navigatorKey.currentContext!).push(SwipeablePageRoute(
                        builder: (BuildContext context) => const CasesScreen(),
                      )); }
                        else{
                      Navigator.of(navigatorKey.currentContext!).pop();
                      Navigator.of(navigatorKey.currentContext!).push(SwipeablePageRoute(
                        builder: (BuildContext context) => const AccountStatementScreen(),
                      ));}
                    },
                    child: Text(widget.text,style: TextStyle(fontSize: 18.sp),))],)

            ],
          ),
        ),
        Positioned(
          left: dialogPadding,
          right: dialogPadding,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.5), spreadRadius: 5)],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: dialogAvatarRadius,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(dialogAvatarRadius)),
                  child: Image.asset("assets/images/logo_white_bg.jpg")
              ),
            ),
          ),
        ),
      ],
    );
  }
}