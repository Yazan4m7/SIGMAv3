import 'package:app/screens/quality_control_performance.dart';
import 'package:app/screens/units_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../utils/constants.dart';

class PerformanceScreen extends StatefulWidget {
  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
    with SingleTickerProviderStateMixin {
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/gifs/performance_bg.gif"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 100,
                  left: 170.h,
                  child: Image.asset(
                    "assets/images/logo_small.png",
                    width: 50.w,
                  )),
              Positioned.fill(
                  top: 280.h,
                  child: Container(

                      width: 300.w,
                      height: 600.h,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: GridView.count(crossAxisCount: 2, children: [
                          // Units count, Quality con,Job types,Implants
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                  ),
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.all(Radius.circular(25))
                              ),

                              child: Stack(
                            children: [
                              // Background image placed in the center of Stack

                              // Blue container 50x50 placed on the top of an image
                              GestureDetector(
                                onTap:(){
                                  Navigator.of(context).push(SwipeablePageRoute(
                                    builder: (BuildContext context) => const UnitsCounts(),
                                  ));
                                },
                                child: Center(
                                  child: Container(

                                      child: Center(
                                          child: Text(
                                        "JOB TYPES",
                                        style: TextStyle(color: kGreen,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18.sp,),
                                      )),
                                      width: 300,
                                      height: 20,
                                      ),
                                ),
                              ),
                            ],
                          )),
                          Container(

                            decoration: BoxDecoration(
                                border: Border.all(
                                ),
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            child: Stack(children: [
                              // Background image placed in the center of Stack
                                                          // Blue container 50x50 placed on the top of an image
                              Center(
                                child: GestureDetector(
                                  child: Container(
                                      child: Center(
                                          child: SizedBox(
                                              width: 90,
                                              height: 60,
                                              child: Center(
                                                child: Text("QUALITY CONTROL",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                        fontSize: 18.sp,
                                                        color: kGreen)),
                                              )))),

                              onTap:(){ Navigator.of(context).push(SwipeablePageRoute(
                                builder: (BuildContext context) => const QualityControlPerformance(),
                              )); } ),
                              ),

                            ]),
                          ),

                          Container(

                            decoration: BoxDecoration(
                                border: Border.all(
                                ),
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            child: Stack(children: [
                              // Background image placed in the center of Stack
                              // Blue container 50x50 placed on the top of an image
                              Center(
                                child: Container(
                                    child: Center(
                                        child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                              child: Text("UNITS COUNT",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 18.sp,
                                                      color: kGreen)),
                                            )))),
                              ),
                            ]),
                          ),
                          Container(

                              decoration: BoxDecoration(
                                  color:Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Stack(
                            children: [
                              // Background image placed in the center of Stack
                              // Blue container 50x50 placed on the top of an image
                              Center(
                                child: Container(
                                    child: Center(
                                        child: SizedBox(
                                          width:90,
                                          child: Text(
                                      "IMPLANTS"
                                      ,style: TextStyle(color: kGreen,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18.sp,),
                                    ),
                                        )),
                                    width: 90,
                                    height: 20,
                                   ),
                              ),
                            ],
                          ))
                        ]),
                      )))
            ])));
  }
}
