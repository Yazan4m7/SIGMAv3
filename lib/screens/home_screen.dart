import 'package:app/screens/performance/performance_loading_screen.dart';
import 'package:app/screens/performance/units_count_performance.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:app/screens/cases_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';
import '../utils/local_auth_service.dart';
import 'account_statement.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:app/models/client.dart';
import 'package:app/utils/storage_service.dart';
import 'gallery_screen.dart';
import 'performance/performance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authController = Get.find<AuthController>();
  final remoteServices = Get.find<RemoteServicesController>();
  String? appName, packageName, version, buildNumber = "";
  Client? client;

  void updateFCMToken() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
    RemoteServicesController.instance.setNotificationToken(fcmToken!);
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      RemoteServicesController.instance.setNotificationToken(fcmToken!);
    })
        .onError((err) {
      print("Error getting fcm token");
    });
  }


  @override
  void initState() {
    updateFCMToken();
    checkIfAllMediaViewed();
    remoteServices.getGalleryItems();
    getVersionCode();
    setupInteractedMessage();
    super.initState();
    checkAuthorization();
  }


  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print("home screen msg : ${initialMessage?.data}");
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) async{
print("handling notification from home screen");
    if (message.data["click_action"] == "openCompletedCases") {
      remoteServices.getCompletedCases();
      remoteServices.getInProgressCases();
      Navigator.of(context).push(SwipeablePageRoute(
        builder: (BuildContext context) => const CasesScreen(tabIndex: 1,),
      ));
    }
    if (message.data["click_action"] == "OpenAccountStatement") {
      await remoteServices.getStatement();
      Navigator.of(context).push(SwipeablePageRoute(
        builder: (BuildContext context) => const AccountStatementScreen(),
      ));
    }
  }

  void getVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        elevation: 0,
        foregroundColor: kWhite,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          PopupMenuButton(

              // add icon, by default "3 dot" icon
              icon: Icon(Icons.account_circle_rounded,color: Colors.white70,),
              iconSize: 40.w,
              itemBuilder: (context) {
            return [
              PopupMenuItem<int>(padding: EdgeInsets.only(left: 30.w,right: 0),value: 0, child:_buildClientName(),),
              PopupMenuItem<int>(height:2.h,value: 0, child:Container(color: Colors.black54,height: 1.h,)),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Logout",style: TextStyle(fontSize: 22.sp,
                    color: Colors.black,
                    fontFamily: 'Quest'),textAlign: TextAlign.start,),
              ),
            ];
          }, onSelected: (value) {
            if (value == 1) {
              authController.logout();
            }
          }),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Positioned(
            //     right: 45.w,
            //     top: 29.h,
            //     child: _buildClientName()),
            Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      " د. ",
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: Colors.transparent,
                        fontFamily: 'Quest',
                      ),
                    )
                  ],
                ),
                SizedBox(height: 140.h),
                _buildLogo(),
                 SizedBox(height: 100.h),
                 //_buildClientName(),
                SizedBox(height:50.h),
                _buildCasesBtn(),
                SizedBox(height: 25.h),
                Obx(
                  () => remoteServices.isDoctorAccount.value
                      ? _buildAccountStatementBtn()
                      : SizedBox(),
                ),
                SizedBox(height: 25.h),
                _buildGalleryBtn(),
                SizedBox(height: 25.h),
                _buildPerformanceBtn()
              ],
            ),
            _buildAccessLevelTag(),
            _buildVersionCode()
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: Image.asset(
          "assets/images/logo.png",
        ),
      ),
    );
  }

  Widget _buildClientName() {
    return Obx(
      () => Text(
        " د. " + (remoteServices.client.value.name ?? ""),
        style: TextStyle(
          fontSize: 25.sp,
          color: Colors.black,
          fontFamily: 'Quest',
        ),
      ),
    );
  }

  Widget _buildCasesBtn() {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kGreen),
          foregroundColor: MaterialStateProperty.all(kWhite),
          fixedSize: MaterialStateProperty.all(Size(250.w, 45.h)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ))),
        ),
        onPressed: () {
          Navigator.of(context).push(SwipeablePageRoute(
            builder: (BuildContext context) => CasesScreen(),
          ));
        },
        child: Text(
          "CASES",
          style: TextStyle(fontSize: 20.sp, fontFamily: fontFamily),
        ));
  }

  Widget _buildAccountStatementBtn() {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kGreen),
          foregroundColor: MaterialStateProperty.all(kWhite),
          fixedSize: MaterialStateProperty.all(Size(250.w, 45.h)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ))),
        ),
        onPressed: () {
          Navigator.of(context).push(SwipeablePageRoute(
            builder: (BuildContext context) => AccountStatementScreen(),
          ));
        },
        child: Text(
          "ACCOUNT STATEMENT",
          style: TextStyle(fontSize: 20.sp, fontFamily: fontFamily),
        ));
  }

  Widget _buildGalleryBtn() {
    return Container(
      width:250.w,
      height: 45.h,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kGreen),
                foregroundColor: MaterialStateProperty.all(kWhite),
                fixedSize: MaterialStateProperty.all(Size(250.w, 45.h)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ))),
              ),
              onPressed: () {
                Navigator.of(context).push(SwipeablePageRoute(
                  builder: (BuildContext context) => const GalleryScreen(),
                ));
              },
              child: Text(
                "GALLERY",
                style: TextStyle(fontSize: 20.sp, fontFamily: fontFamily),
              )),
          ),
          Obx(
            ()=> remoteServices.isAllMediaViewed.value ? SizedBox():Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/new_badge_circle.png",width: 35.w,
                )),
          )
      ]),
    );
  }

  Widget _buildAccessLevelTag() {
    return Positioned(
        bottom: 10.h,
        left: 15.w,
        child: Obx(
          () => Text(
            remoteServices.isDoctorAccount.value
                ? "Doctor Account"
                : "Clinic Account",
            style: TextStyle(color: kGrey, fontFamily: fontFamily),
          ),
        ));
  }

  Widget _buildVersionCode() {
    return Positioned(
      bottom: 10.h,
      right: 15.w,
      child: Text(
        "V$version.$buildNumber",
        style: TextStyle(color: kGrey, fontFamily: fontFamily),
      ),
    );
  }
  Widget _buildPerformanceBtn(){
    return Container(
      width:250.w,
      height: 45.h,
      child:  TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kGreen),
                  foregroundColor: MaterialStateProperty.all(kWhite),
                  fixedSize: MaterialStateProperty.all(Size(250.w, 45.h)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ))),
                ),
                onPressed: () {
                  Navigator.of(context).push(SwipeablePageRoute(
                    builder: (BuildContext context) =>  PerformanceLoadingScreen(),
                  ));
                },
                child: Text(
                  "MY PERFORMANCE",
                  style: TextStyle(fontSize: 20.sp, fontFamily: fontFamily),
                )),

    );
  }
}
