import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ImplantsPerformance extends StatefulWidget {
  const ImplantsPerformance({Key? key}) : super(key: key);

  @override
  State<ImplantsPerformance> createState() => _ImplantsPerformanceState();
}

late List<_ChartData> data;
late TooltipBehavior _tooltip;

class _ImplantsPerformanceState extends State<ImplantsPerformance> {
  Color tiBaseColor = kGreen;
  Color customColor = Color.fromRGBO(251, 2, 210, 1.0);
  Color multiColor = Colors.indigo;
  Color cementColor = Colors.amber;
  double maxValue =0;
  late Size screenSize;
  TextStyle titleTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 19.sp,
    fontWeight: FontWeight.w600,
  );
  TextStyle amountTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
  );
  @override
  void initState() {
    data = [
      _ChartData('Ti Base', 10, tiBaseColor, "12"),
      _ChartData('Custom', 30, customColor, "15"),
      _ChartData('Multi Unit', 20, multiColor, "30"),
      _ChartData('Cement', 15, cementColor, "6"),
    ];

    data.forEach((element) {
      if(element.y > maxValue)
        maxValue = element.y;
    });
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(0)),
            color: Colors.white,
          ),
          child: Column(children: [
            SizedBox(
              height: 35.h,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 18.0, right: 18.0),
              child: Text(
                "IMPLANTS",
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
              height: screenSize.height / 2.9,
              width: screenSize.width,
              child: _buildBarsChart(),
            ),
            SizedBox(
              height: 30.h,
            ),
            Expanded(
              child: Column(children: [

                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    _buildDescBox("Ti Base",12,tiBaseColor,"assets/icons/tibase.svg"),
                    _buildDescBox("Custom",15,customColor,"assets/icons/custom.svg"),
                  ],
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    _buildDescBox("Multi-Unit",30,multiColor,"assets/icons/multi-unit.svg"),
                    _buildDescBox("Cement",6,cementColor,"assets/icons/cement.svg"),
                  ],
                ),
              ]),
            ),
          ]),
        ));
  }
  SfCartesianChart _buildBarsChart() {
    return SfCartesianChart(

        enableAxisAnimation: true,
        plotAreaBorderWidth:0,
        borderWidth: 0,
        primaryXAxis: CategoryAxis(
          majorTickLines: MajorTickLines(
              size: 6,
              width: 0,
              color: Colors.red
          ),
          minorTickLines: MinorTickLines(
              size: 4,
              width: 0,
              color: Colors.blue
          ),
          //Hide the gridlines of x-axis
          majorGridLines: MajorGridLines(width: 0),
          //Hide the axis line of x-axis
          axisLine: AxisLine(width: 0),
        ),

        primaryYAxis: NumericAxis(
            majorTickLines: MajorTickLines(
                size: 6,
                width: 0,
                color: Colors.red
            ),
            minorTickLines: MinorTickLines(
                size: 4,
                width: 0,
                color: Colors.blue
            ),
            isVisible: false,
            edgeLabelPlacement:  EdgeLabelPlacement.shift,
            minimum: 0, maximum: maxValue*1.25, interval: 10,
            //Hide the gridlines of y-axis
            majorGridLines: MajorGridLines(width: 0),
            //Hide the axis line of y-axis
            axisLine: AxisLine(width: 0)
        ),

        tooltipBehavior: _tooltip,

        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              trackBorderWidth: 0,
              borderWidth: 0,
              isTrackVisible: false,
              animationDelay: 500,
              width: 0.6.w,
              animationDuration: 500,
              enableTooltip: true,
              yAxisName: "Amount",
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              pointColorMapper: (_ChartData data, _) => data.color,
              dataLabelMapper: (_ChartData data, _) => data.label,
              dataLabelSettings: DataLabelSettings(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
                  color: Colors.transparent,
                  isVisible: true,
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)),
              name: 'Amount',
              color: Color.fromRGBO(8, 142, 255, 1))
        ]);
  }
  _buildDescBox(String title, int value, Color color,String iconPath){
    return Container(

      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      width: screenSize.width/2-40.w,
      height: (screenSize.height-90-screenSize.height/2)/2-20.h,
      decoration:BoxDecoration(

          border: Border.all(color: Colors.transparent,width: 2),borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 35.w,
            width:35.w ,
            child: SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
            title,
            style: titleTextStyle.copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            value.toString(),
            style: amountTextStyle,
          ),



        ],
      ),
    );
  }
}


class _ChartData {
  _ChartData(this.x, this.y, this.color, this.label);

  final String x;
  final double y;
  final Color color;
  final String label;
}
