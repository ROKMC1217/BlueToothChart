import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:blechart/src/util/Util.dart';
import 'package:blechart/src/vo/SalesData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart_StepLineGraph extends StatefulWidget {
  int? index;
  Chart_StepLineGraph({required int i, required UniqueKey key}) {
    index = i;
  }
  @override
  State<Chart_StepLineGraph> createState() => _Chart_StepLineGraphState();
}

class _Chart_StepLineGraphState extends State<Chart_StepLineGraph>
    with WidgetsBindingObserver {
  bool isInit = false;
  List<SalesData>? chartData;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  ModeControlController? modeControlController;

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
    if (!isInit) {
      isInit = !isInit;
      modeControlController =
          Provider.of<ModeControlController>(context, listen: true);
    }
  }

  // void/ updateDataSource(Timer timer) {
  // chartData!.add(SalesData(time++, (math.Random().nextInt(60) + 30)));
  // chartData!.removeAt(0);
  // _chartSeriesController!.updateDataSource(
  //   addedDataIndex: chartData!.length - 1, // 인덱스 마지막에 새로들어온 값 추가.
  // removedDataIndex: 0,
  // );
  // }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      selectionGesture: ActivationMode.singleTap,
      key: widget.key,
      tooltipBehavior: _tooltipBehavior,
      borderColor: Colors.black,
      plotAreaBackgroundColor: Colors.black,
      plotAreaBorderColor: Colors.white,    // 그래프의 테두리 색
      plotAreaBorderWidth: 1.5,               // 그래프의 테두리
      backgroundColor: Colors.black,
      zoomPanBehavior: _zoomPanBehavior,
      series: widget.index! >= 32
          ? <LineSeries<SalesData, double>>[
              LineSeries<SalesData, double>(
                onRendererCreated: (ChartSeriesController controller) {},
                dataSource:
                    modeControlController!.graph.totalList[widget.index!],
                color: Util.colorList[widget.index!], // 꺽은선 그래프의 색상
                xValueMapper: (SalesData sales, _) => sales.x,
                yValueMapper: (SalesData sales, _) => sales.y,
              ),
            ]
          : <ScatterSeries<SalesData, double>>[
              ScatterSeries<SalesData, double>(
                onRendererCreated: (ChartSeriesController controller) {},
                dataSource:
                    modeControlController!.graph.totalList[widget.index!],
                color: Util.colorList[widget.index!], // 꺽은선 그래프의 색상
                xValueMapper: (SalesData sales, _) => sales.x,
                yValueMapper: (SalesData sales, _) => sales.y,
                markerSettings: MarkerSettings(height: 3, width: 3),
              ),
            ],
      primaryXAxis: NumericAxis(
        minimum: 0,
        maximum: 4.0,
        tickPosition: TickPosition.outside,
        // plotOffset: 5,
        anchorRangeToVisiblePoints: true,
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        enableAutoIntervalOnZooming: false,
        autoScrollingMode: AutoScrollingMode.start,
        interval: widget.index! >= 32 ? 1.0 : 0.5,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        title: AxisTitle(
          alignment: ChartAlignment.near,
          text: "time",
          textStyle: const TextStyle(
            fontSize: 11,
          ),
        ),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: widget.index! >= 32 ? 255.0 : 2.0,
        axisLine: const AxisLine(width: 0),
        rangePadding: ChartRangePadding.auto,
        interval: widget.index! >= 32 ? 25.0 : 1.0,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        title: AxisTitle(
          alignment: ChartAlignment.near,
          text: "value",
          textStyle: const TextStyle(
            fontSize: 11,
          ),
        ),
        labelAlignment: LabelAlignment.center,
        labelPosition: ChartDataLabelPosition.outside,
        majorGridLines: const MajorGridLines(width: 0),
      ),
    );
  }
}
