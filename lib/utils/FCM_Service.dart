import 'package:app/firebase_options.dart';
import 'package:app/screens/account_statement.dart';
import 'package:app/screens/cases_screen.dart';
import 'package:app/utils/storage_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import '../controllers/remote_services_controller.dart';
import '../widgets/custom_dialog.dart';
import 'constants.dart';


   initializeFCM () async{
     FirebaseMessaging messaging = FirebaseMessaging.instance;
     await messaging.setAutoInitEnabled(true);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String buttonText = "";
      bool inBox=false;
      if (message.data['title'].toString().contains("box") || message.data['body'].toString().contains("box"))
        inBox=true;
      if (message.data['click_action'] =="openCompletedCases")
        buttonText= "Completed Cases";
      else
        buttonText= "Account Statement";
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (navigatorKey.currentContext != null) {
        showDialog(context: navigatorKey.currentContext!,
            builder: (BuildContext context){
              return CustomDialogBox(
                title: message.data['title'],
                descriptions: message.data['body'],
                text: buttonText,
                inBox: inBox,
              );
      });}
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  }

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
     print("background messaging handler running .. message data : ${message.data}");
     playSound();
}
void _handleMessage(RemoteMessage message) async {
     print("handling from FCM service");
  if (message.data["click_action"] == "openCompletedCases") {
    remoteServices.getCompletedCases();
    remoteServices.getInProgressCases();
    Navigator.of(navigatorKey.currentContext!).push(SwipeablePageRoute(
      builder: (BuildContext context) => const CasesScreen(tabIndex: 1,),
    ));
  }
  if (message.data["click_action"] == "OpenAccountStatement") {
    await remoteServices.getStatement();
    Navigator.of(navigatorKey.currentContext!).push(SwipeablePageRoute(
      builder: (BuildContext context) => const AccountStatementScreen(),
    ));
  }

}

void playSound() async{
  final AudioPlayer player = AudioPlayer();
  await player.play(AssetSource("sounds/notification.mp3"));
}



