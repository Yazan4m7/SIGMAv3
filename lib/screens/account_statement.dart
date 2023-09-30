import 'package:app/models/AccountStatementEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';
import '../utils/encrypt.dart';
import '../widgets/account_statement_tile.dart';
import 'package:get/get.dart';

class AccountStatementScreen extends StatefulWidget {
  const AccountStatementScreen({Key? key}) : super(key: key);

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {
  final authController = Get.find<AuthController>();
  final remoteServices = Get.find<RemoteServicesController>();
  final ScrollController _scrollController = ScrollController();
  double? openingBalance;
  bool isLoadingOpeningBalance = true;
  bool isLoadingAccountStatement = true;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 0,
  );
  void _scrollDown() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      print("scrolling down");
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
    });
  }


  @override
  Widget build(BuildContext context) {
    double balance = double.parse(remoteServices.openingBalance.value);

    return Scaffold(

        body: Container(
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundPath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(children: [
            Positioned(
              top: 35.h,
              left: 5.w,
              child: IconButton(
                color: kWhite,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            Positioned.fill(
                top: 40.h,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => remoteServices.date.value.yMMM ==
                                  Jiffy.now().subtract(months: 1).yMMM
                              ? SizedBox(width: 15.w)
                              : IconButton(
                                  onPressed: () {
                                    double balance = double.parse(
                                        remoteServices.openingBalance.value);
                                    remoteServices.previousMonth();
                                    _scrollDown();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  )),
                        ),
                        Obx(
                          () => Text(remoteServices.date.value.yMMM,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        Obx(
                          () =>
                              remoteServices.date.value.yMMM == Jiffy.now().yMMM
                                  ? SizedBox(width: 15.w)
                                  : IconButton(
                                      onPressed: () {
                                        remoteServices.nextMonth();
                                        _scrollDown();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      )),
                        ),
                      ],
                    ))),
            Positioned.fill(
              top: 100.h,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [
                            0.0,
                            0.1,
                            0.3,
                            0.7,
                            0.9,
                            1.0,
                          ],
                          colors: [
                            kAccountStatementTileBGColor.withOpacity(0.00),
                            kAccountStatementTileBGColor.withOpacity(0.05),
                            kAccountStatementTileBGColor,
                            kAccountStatementTileBGColor,
                            kAccountStatementTileBGColor.withOpacity(0.05),
                            kAccountStatementTileBGColor.withOpacity(0.00),
                          ],
                        ),
                        //color: kAccountStatementTileBGColor,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: 75.h,
                    width: 300.w,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text("Current Balance",
                              style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.bold,color:kAccountStatementForegroundColor)),
                          SizedBox(height:5.h),
                          Obx(
                            ()=> Text( formatter.format(double.parse(remoteServices.currentBalance.value?? '0') ),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.sp,
                                    color: double.parse(remoteServices.currentBalance.value) < 1 ? kGreen : Colors.redAccent)),
                          )
                        ],
                      ),
                    ),
                  ),
              ),
            ),

            Positioned.fill(
              top: 180.h,
              child: Column(children: [
                SizedBox(height: 5.h),
                Container(
                  height: 550.h,
                  child: Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      itemCount: remoteServices
                                  .entries[remoteServices.date.value.yM] ==
                              null
                          ? 1
                          : remoteServices
                                  .entries[remoteServices.date.value.yM]!
                                  .length +
                              1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          balance =
                              double.parse(remoteServices.openingBalance.value);
                          return Container(
                              margin: EdgeInsets.only(bottom:10.h,left:5.w,right:5.w),
                              decoration:  BoxDecoration(
                                  color: kAccountStatementTileBGColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: 350.w,
                              height: 60.h,
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 20.h,
                                      left: 10.w,
                                      child: Text(
                                        "Opening Balance",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp,
                                            color: kAccountStatementForegroundColor),
                                      )),
                                  Positioned(
                                      top: 20.h,
                                      right: 30.w,
                                      child: Obx(
                                        () => Text(
                                          formatter.format(double.parse(remoteServices.openingBalance.value) ??
                                              0),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                          color: kAccountStatementForegroundColor),
                                        ),
                                      ))
                                ],
                              ));
                        }
                        if (remoteServices
                            .entries[remoteServices.date.value.yM] !=
                            null && index == 4) {
                          _scrollDown();
                        }
                        AccountStatementEntry? entry = remoteServices
                            .entries[remoteServices.date.value.yM]?[index - 1];
                        if (entry?.status == 1) {
                          balance += entry?.amount ?? 0;
                        } else {
                          balance -= entry?.amount ?? 0;
                        }
                        if (entry != null) {
                          return AccountStatementTile(
                              entry: entry, balance: entry.balance);
                        }
                      },
                    ),
                  ),
                )
              ]),
            ),
          ]),
        ));
  }
}
