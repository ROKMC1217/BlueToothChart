import 'package:blechart/src/vo/SalesData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> with WidgetsBindingObserver {
  bool isInit = false;
  List<SalesData>? chartData;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true, // 두손가락으로 확대및 축소
      enableDoubleTapZooming: true, // 더블 탭
      enableSelectionZooming: true,
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 2,
      selectionRectColor: Colors.grey,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {}
  }

  List<SalesData> list = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SfCartesianChart(
            enableAxisAnimation: true,
            selectionGesture: ActivationMode.singleTap,
            key: widget.key,
            tooltipBehavior: _tooltipBehavior,
            plotAreaBorderColor: Colors.white, // 그래프의 테두리 색
            plotAreaBorderWidth: 1.5, // 그래프의 테두리
            borderColor: Colors.black,
            plotAreaBackgroundColor: Colors.black,
            backgroundColor: Colors.black,
            zoomPanBehavior: _zoomPanBehavior,
            // ==========================================
            series: <ChartSeries<SalesData, double>>[
            // ==========================================
              // HiloSeries<SalesData, double>(
              //   // onRendererCreated: (ChartSeriesController controller) {},
              //   dataSource: list,
              //   color: Colors.red, // 꺽은선 그래프의 색상
              //   xValueMapper: (SalesData sales, _) => sales.x,
              //   lowValueMapper: (SalesData sales, _) => 10,
              //   highValueMapper: (SalesData sales, _) => 10,
              // ),
              LineSeries<SalesData, double>(
                width: 0.666,
                onRendererCreated: (ChartSeriesController controller) {},
                dataSource: list,
                color: Colors.white, // 꺽은선 그래프의 색상
                xValueMapper: (SalesData sales, _) => sales.x,
                yValueMapper: (SalesData sales, _) => sales.y,
                // ============================================
                // markerSettings: MarkerSettings(
                //   height: 5,
                //   width: 5,
                //   color: Colors.yellow,
                //   isVisible: true,
                // ),
                // ============================================
              ),
            ],
            primaryXAxis: NumericAxis(
              minimum: 0,
              maximum: 1000.0,
              tickPosition: TickPosition.outside,
              // plotOffset: 5,
              anchorRangeToVisiblePoints: true,
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              enableAutoIntervalOnZooming: false,
              autoScrollingMode: AutoScrollingMode.start,
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              title: AxisTitle(
                alignment: ChartAlignment.near,
                text: "time",
                textStyle: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
              // ===============================================
              axisLine: AxisLine(
                width: 1,
                color: Colors.white,
              ),
              // ===============================================
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 500,
              axisLine: const AxisLine(width: 0),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              rangePadding: ChartRangePadding.auto,
              title: AxisTitle(
                alignment: ChartAlignment.near,
                text: "value",
                textStyle: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
              labelAlignment: LabelAlignment.center,
              labelPosition: ChartDataLabelPosition.outside,
              majorGridLines: const MajorGridLines(width: 0),
            ),
          ),
          TextButton(
            onPressed: () {
              // for (i = 1; i <= 100; i++) {
              //   if (i % 2 == 0) {
              //     list.add(SalesData(i.toDouble(), 1));
              //   }
              // }
              list.add(SalesData(100.toDouble(), 1000));
              list.add(SalesData(200.toDouble(), 2));
              list.add(SalesData(300.toDouble(), 3));
              list.add(SalesData(400.toDouble(), 4));
              list.add(SalesData(500.toDouble(), 5));
              setState(() {});
            },
            child: Text("Good!"),
          ),
          TextButton(
            onPressed: () {
              list.clear();
              setState(() {});
            },
            child: Text("Clear!"),
          ),
        ],
      ),
    );
  }

  int i = 1;
  static int TOTAL = 61444;
}
