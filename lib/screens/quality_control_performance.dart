import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class QualityControlPerformance extends StatefulWidget {
  const QualityControlPerformance({Key? key}) : super(key: key);

  @override
  State<QualityControlPerformance> createState() =>
      _QualityControlPerformanceState();
}

class _QualityControlPerformanceState extends State<QualityControlPerformance> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white30,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
                border: Border.all(
                  color:Colors.transparent
                ),

                borderRadius: BorderRadius.all(Radius.circular(40))
            ,color: Colors.white.withOpacity(0.85),

            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0,left: 18.0,right: 18.0),
                child:

                Text("QUALITY CONTROL",style: TextStyle(color:Colors.black.withOpacity(0.8),fontSize: 30.sp,fontWeight: FontWeight.w700),),

              ),

      SizedBox(
            height: mediaQuery.height / 2.1 - 90,
            width: mediaQuery.width ,
            child: SfRadialGauge(
                enableLoadingAnimation: true, animationDuration: 2000,
                axes: <RadialAxis>[
      RadialAxis(

            labelFormat: "{value}%",
            startAngle: 180,
            endAngle: 0,
            interval: 10,
            canScaleToFit: true,
            pointers: <GaugePointer>[RangePointer(value: 70, width: 0.2,
                gradient: SweepGradient(
                  colors: [Colors.green, Colors.red],
                  stops: [0.5,0.3]
                ), sizeUnit: GaugeSizeUnit.factor
            ),NeedlePointer(value: 70,)
            ],
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              thicknessUnit: GaugeSizeUnit.factor,
             color: Colors.grey),
      )]),
      ),

      Expanded(
        child: Container(
            
            width: mediaQuery.width,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.transparent
              ),
              borderRadius: BorderRadius.only(topLeft:Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40) )
              ,color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],),
            child: SizedBox(
            height: mediaQuery.height / 2.1 - 50,
    width: mediaQuery.width,
            child: Padding(
              padding: const EdgeInsets.only(top:25.0),
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Container(
                        padding: EdgeInsets.all(10.h),
                        width: mediaQuery.width/2,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ,color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.9),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],),

                        child: Center(child: Column(
                          children: [

                            Text(
                              String.fromCharCode(CupertinoIcons.check_mark.codePoint),
                              style: TextStyle(
                                inherit: false,
                                color: Colors.green,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: CupertinoIcons.check_mark.fontFamily,
                                package: CupertinoIcons.check_mark.fontPackage,
                              ),
                            ),
                            Text("Successful",style: TextStyle(color: Colors.green,fontSize: 20.sp),),
                            SizedBox(height:10.h),
                            Container(
                              width: 50.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:Colors.transparent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                ,color: Colors.green,
                              ),


                              child: Center(child: Text("70%",style: TextStyle(color: Colors.white,fontSize: 20.sp),)),
                            )
                          ],
                        ),),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.h),
                        margin:  EdgeInsets.only(top: 30.h),
                        width: mediaQuery.width/2,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                          ,color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.9),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],),

                        child: Center(child: Column(
                          children: [

                            Text(
                              String.fromCharCode(CupertinoIcons.repeat.codePoint),
                              style: TextStyle(
                                inherit: false,
                                color: Colors.red,
                                fontSize: 35.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: CupertinoIcons.repeat.fontFamily,
                                package: CupertinoIcons.repeat.fontPackage,
                              ),
                            ),
                            Text("Repeat",style: TextStyle(color: Colors.red,fontSize: 20.sp),),
                            SizedBox(height:10.h),
                            Container(
                              width: 50.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:Colors.transparent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15))
                                ,color: Colors.red,
                              ),


                              child: Center(child: Text("30%",style: TextStyle(color: Colors.white,fontSize: 20.sp),)),
                            )
                          ],
                        ),),
                      ),


              ]),
            ),),
        ),
      ),
    ]),
          ),
        ));
  }
}
