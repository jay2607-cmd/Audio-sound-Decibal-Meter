import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

class Chart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;


  @override
  void initState() {
    chartData = getChartData();
    Timer.periodic(Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.speed,
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Internet speed (Mbps)')))));
  }

  int time = 19;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 42),
      LiveData(1, 47),
      LiveData(2, 43),
      LiveData(3, 49),
      LiveData(4, 54),
      LiveData(5, 41),
      LiveData(6, 58),
      LiveData(7, 51),
      LiveData(8, 98),
      LiveData(9, 41),
      LiveData(10, 53),
      LiveData(11, 72),
      LiveData(12, 86),
      LiveData(13, 52),
      LiveData(14, 94),
      LiveData(15, 92),
      LiveData(16, 86),
      LiveData(17, 72),
      LiveData(18, 94)
    ];
  }
// List<_SalesData> data = [
//   _SalesData('Jan', 35),
//   _SalesData('Feb', 28),
//   _SalesData('Mar', 34),
//   _SalesData('Apr', 32),
//   _SalesData('May', 40)
// ];
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//
//       body: Column(children: [
//         //Initialize the chart widget
//         SfCartesianChart(
//             primaryXAxis: CategoryAxis(),
//             // Chart title
//             title: ChartTitle(text: 'Half yearly sales analysis'),
//             // Enable legend
//             legend: Legend(isVisible: true),
//             // Enable tooltip
//             tooltipBehavior: TooltipBehavior(enable: true),
//             series: <ChartSeries<_SalesData, String>>[
//               LineSeries<_SalesData, String>(
//                   dataSource: data,
//                   xValueMapper: (_SalesData sales, _) => sales.year,
//                   yValueMapper: (_SalesData sales, _) => sales.sales,
//                   name: 'Sales',
//                   // Enable data label
//                   dataLabelSettings: DataLabelSettings(isVisible: true))
//             ]),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             //Initialize the spark charts widget
//             child: SfSparkLineChart.custom(
//               //Enable the trackball
//               trackball: SparkChartTrackball(
//                   activationMode: SparkChartActivationMode.tap),
//               //Enable marker
//               marker: SparkChartMarker(
//                   displayMode: SparkChartMarkerDisplayMode.all),
//               //Enable data label
//               labelDisplayMode: SparkChartLabelDisplayMode.all,
//               xValueMapper: (int index) => data[index].year,
//               yValueMapper: (int index) => data[index].sales,
//               dataCount: 5,
//             ),
//           ),
//         )
//       ]));
// }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}
