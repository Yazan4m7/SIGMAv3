import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobTypePerformance extends StatefulWidget {
  const JobTypePerformance({Key? key}) : super(key: key);

  @override
  State<JobTypePerformance> createState() => _JobTypePerformanceState();
}

late List<ChartData> chartData;
late TooltipBehavior _tooltip;
late double screenWidth;
late double screenHeight;
class _JobTypePerformanceState extends State<JobTypePerformance> {

  Color crownColor = kGreen;
  Color veneerColor = Color.fromRGBO(251, 2, 210, 1.0);
  Color screwRetainedColor = Colors.indigo;
  Color inlayColor = Colors.amber;
  double iconSize = 25.w;
  TextStyle labelTextStyle = TextStyle(
      color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w600);
  TextStyle valueTextStyle = TextStyle(
       fontSize: 28.sp, fontWeight: FontWeight.w600);
  TextStyle titleTextStyle = TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w400,color: Colors.black);
  @override
  void initState() {
    print("init state");
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build screen");
    screenWidth = MediaQuery
        .of(context)
        .size.width-5.w;
    screenHeight = MediaQuery
        .of(context)
        .size.height -64.3.h;
    chartData = [
      ChartData('Crown', 25, crownColor,"10%"),
      ChartData('Veneer', 38, veneerColor,"21%"),
      ChartData('S.Retained', 34, screwRetainedColor,"18%"),
      ChartData('Inlay', 52, inlayColor,"40%")
    ];

    TextStyle titleTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 25.sp,
      fontWeight: FontWeight.w400,
    );
    TextStyle amountTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: 35.sp,
      fontWeight: FontWeight.w900,
    );
    return Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(0)),
            color: Colors.white,
          ),
          child: Stack(children: [
            Positioned(
                top:150.h,
                width: screenWidth,
                child: _buildPieChart()),
            Column(children: [
              SizedBox(
                height: 35.h,
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 25.0, left: 18.0, right: 18.0),
                child: Text(
                  "JOB TYPES",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                height: screenHeight / 2.7,
                width: screenWidth,
                child: Container(),
              ),


              Expanded(
                child: Container(
                  width: screenWidth-20.w,
                  height: screenHeight/2-30.h,
                  alignment: Alignment.center,
                  child:
                  Column(children: [

                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        _buildValueContainer(
                            chartData[0].color, chartData[0].x, chartData[0].y,"assets/icons/crown.svg"),
                        _buildValueContainer(
                            chartData[1].color, chartData[1].x, chartData[1].y,"assets/icons/veneer.svg")
                      ],
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        _buildValueContainer(
                            chartData[2].color, chartData[2].x, chartData[2].y,"assets/icons/screw-retained.svg"),
                        _buildValueContainer(
                            chartData[3].color, chartData[3].x, chartData[3].y,"assets/icons/inlay.svg")
                      ],
                    ),
                  ])
                ),
              ),
            ],)
          ]),
        ));
  }

  SfCircularChart _buildPieChart() {
    print("build chart");
    return SfCircularChart(

        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
            // Starting angle of doughnut
            startAngle: 270,
            // Ending angle of doughnut
            endAngle: 90,
            radius: "100%",

        dataLabelSettings:
        DataLabelSettings(isVisible: true, textStyle: labelTextStyle,labelPosition: ChartDataLabelPosition.outside,useSeriesColor: true),
        enableTooltip: true,
        dataSource: chartData,
        pointColorMapper: (ChartData data, _) => data.color,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,

        dataLabelMapper: (ChartData data, _) => data.percentage,
        // Segments will explode on tap
        explode: true,
        // First segment will be exploded on initial rendering
      )
    ]);
  }

  Container _buildValueContainer(Color color, String title, int value,String iconPath) {

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      width: screenWidth/2-40.w,
      height: (screenHeight-90-screenHeight/2)/2-20.h,
      decoration:BoxDecoration(

          border: Border.all(color: Colors.transparent,width: 2),borderRadius: BorderRadius.all(Radius.circular(15))),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(
            height: 35.0.h,
            width: 35.0.w,
            child: SvgPicture.asset(
                iconPath,
                colorFilter:  ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          Text(title,style: titleTextStyle,),
          Text(value.toString(),style: valueTextStyle,),
          //SizedBox(height: 10.h,),

        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color,this.percentage);
  final String x;
  final String percentage;
  final int y;
  final Color color;
}
