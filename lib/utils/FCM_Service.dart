import 'package:app/firebase_options.dart';
import 'package:app/screens/account_statement.dart';
import 'package:app/screens/cases_screen.dart';
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
    final fcmToken = await messaging.getToken();
    print("n-token : $fcmToken");
     RemoteServicesController.instance.setNotificationToken(fcmToken!);
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      RemoteServicesController.instance.setNotificationToken(fcmToken!);
    })
        .onError((err) {
      print("Error getting fcm token");
    });
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
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (navigatorKey.currentContext != null) {
        showDialog(context: navigatorKey.currentContext!,
            builder: (BuildContext context){
              return CustomDialogBox(
                title: message.data['title'],
                descriptions: message.data['body'],
                text: message.data['click_action'] =="showInProgressCases" ? "View Cases" : "View Statement",
              );
      });}
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  }

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
     print("background messaging handler running .. message data : ${message.data}");

}
void _handleMessage(RemoteMessage message) {
  print("message opened, data : ${message.data}");
     print("Context ${navigatorKey.currentContext}");
  if (message.data["click_action"] == "openInProgressCases") {
    Navigator.of(navigatorKey.currentContext!).push(SwipeablePageRoute(
      builder: (BuildContext context) => const CasesScreen(),
    ));
  }
  if (message.data["click_action"] == "openNewPaymentDialog") {
    Navigator.of(navigatorKey.currentContext!).push(SwipeablePageRoute(
      builder: (BuildContext context) => const AccountStatementScreen(),
    ));
  }
  }



