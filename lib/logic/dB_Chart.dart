import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// pending testing on different device

class DBChart extends StatelessWidget {
  const DBChart({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'dB Graph'),
      series: <LineSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataLabelSettings: const DataLabelSettings(
            // isVisible: true,
          ),
          dataSource: chartData,
          xAxisName: 'Time',
          yAxisName: 'dB',
          name: 'dB values over time',
          xValueMapper: (ChartData value, _) => value.frames,
          yValueMapper: (ChartData value, _) => value.maxDB?.floor(),
          animationDuration: 1
        ),
      ],
    );
  }
}

class ChartData {
  final double? maxDB;
  final double? meanDB;
  final double frames;

  ChartData(this.maxDB, this.meanDB, this.frames);
}
