import 'package:app/screens/login_screen.dart';
import 'package:app/utils/FCM_Service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/local_notification_service.dart';
import 'package:app/utils/main_bindings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );/*.then((value) => Get.put(AuthController()));*/
  initializeFCM();

  // await setupLocalNotification();
  runApp(const SigmaApplication());

}

class SigmaApplication extends StatefulWidget {
  const SigmaApplication({Key? key}) : super(key: key);

  @override
  State<SigmaApplication> createState() => _SigmaApplicationState();
}

class _SigmaApplicationState extends State<SigmaApplication> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context , child) {
      return  GetMaterialApp(
        initialBinding: MainBindings(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: const LoginScreen()
      );
    }
    );
  }
}
