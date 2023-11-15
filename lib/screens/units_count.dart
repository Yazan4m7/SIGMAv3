import 'package:app/models/emplyee2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/emp_data_source.dart';

class UnitsCounts extends StatefulWidget {
  const UnitsCounts({Key? key}) : super(key: key);

  @override
  State<UnitsCounts> createState() => _UnitsCountsState();
}

class _UnitsCountsState extends State<UnitsCounts> {
  List<Employee2> employees = <Employee2>[];

  late EmployeeDataSource employeeDataSource;

  @override
  void initState() {
    super.initState();
    employees= getEmployees();
    employeeDataSource = EmployeeDataSource(employees: employees);
  }

  List<Employee2> getEmployees() {
    return[
      Employee2(10001, 'James', 'Project Lead', 20000),
      Employee2(10002, 'Kathryn', 'Manager', 30000),
      Employee2(10003, 'Lara', 'Developer', 15000),
      Employee2(10004, 'Michael', 'Designer', 15000),
      Employee2(10005, 'Martin', 'Developer', 15000),
      Employee2(10006, 'Newberry', 'Developer', 15000),
      Employee2(10007, 'Balnc', 'Developer', 15000),
      Employee2(10008, 'Perry', 'Developer', 15000),
      Employee2(10009, 'Gable', 'Developer', 15000),
      Employee2(10010, 'Grimes', 'Developer', 15000)
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        SizedBox(width: 450, height: 400, child: chartToRun()),
        SizedBox(width: 450, height: 400,child: table(),)
      ],
    )));
    // return  Scaffold(
    //
    //   body: Column(children: [
    //     SizedBox(height:50.h),
    //     Text("Units Count", style: TextStyle(fontSize: 35.sp),),
    //     SizedBox(height:30.h),
    //     chartToRun()
    //   ],),
    // );
  }

  Widget chartToRun() {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();

    // Example shows an explicit use of the DefaultIterativeLabelLayoutStrategy.
    // The xContainerLabelLayoutStrategy, if set to null or not set at all,
    //   defaults to DefaultIterativeLabelLayoutStrategy
    // Clients can also create their own LayoutStrategy.
    xContainerLabelLayoutStrategy = DefaultIterativeLabelLayoutStrategy(
      options: chartOptions,
    );
    chartData = ChartData(
      dataRows: const [
        [10.0, 20.0],
        [10.0,  0.0],
        [10.0,  0.0],
        [10.0, 0.0],
      ],
      dataRowsColors: const [
        Colors.red,
        Colors.red,
        Colors.red,
        Colors.red,
      ],
      xUserLabels: const ['Wolf', 'Deer'],
      dataRowsLegends: const [
        '',
        '',
        '',
        '',
      ],
      chartOptions: chartOptions,
    );
    // chartData.dataRowsDefaultColors(); // if not set, called in constructor
    var verticalBarChartContainer = VerticalBarChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var verticalBarChart = VerticalBarChart(
      painter: VerticalBarChartPainter(
        verticalBarChartContainer: verticalBarChartContainer,
      ),
    );
    return verticalBarChart;
  }
  Widget table(){
    return SfDataGrid(
      source: employeeDataSource,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'id',
            label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerRight,
                child: Text(
                  'ID',
                ))),
        GridColumn(
            columnName: 'name',
            label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text('Name'))),
        GridColumn(
            columnName: 'designation',
            width: 120,
            label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text('Designation'))),
        GridColumn(
            columnName: 'salary',
            label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerRight,
                child: Text('Salary'))),
      ],
    );
  }
}
