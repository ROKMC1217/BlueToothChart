import 'dart:ffi';

import 'package:blechart/src/controller/HomeController.dart';
import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:blechart/src/util/Util.dart';
import 'package:blechart/src/vo/Graph.dart';
import 'package:blechart/src/vo/SalesData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart_Graph extends StatefulWidget {
  int? index;
  Chart_Graph({required int i, required UniqueKey key}) {
    index = i;
  }

  @override
  _Chart_GraphState createState() => _Chart_GraphState();
}

class _Chart_GraphState extends State<Chart_Graph> with WidgetsBindingObserver {
  bool isInit = false;
  List<SalesData>? chartData;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  HomeController? homeController;
  ModeControlController? modeControlController;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: false, // 두손가락으로 확대및 축소
      enableDoubleTapZooming: false, // 더블 탭
      enableSelectionZooming: false,
      selectionRectBorderColor: Colors.white,
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
      homeController = Provider.of<HomeController>(context, listen: true);
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
      enableSideBySideSeriesPlacement: false,
      enableMultiSelection: false,
      borderWidth: 0,
      enableAxisAnimation: true,
      selectionGesture: ActivationMode.singleTap,
      key: widget.key,
      tooltipBehavior: _tooltipBehavior,
      // ======================================================
      plotAreaBorderColor: Colors.white, // 그래프의 테두리 색
      plotAreaBorderWidth: 1.5, // 그래프의 테두리
      // ======================================================
      backgroundColor: Colors.black,
      // zoomPanBehavior: _zoomPanBehavior,
      series: <LineSeries<SalesData, double>>[
        LineSeries<SalesData, double>(
          width: 0.666, // 그래프 실선의 두께
          onRendererCreated: (ChartSeriesController controller) {},
          dataSource: modeControlController!.graph.totalList[widget.index!],
          color: Util.colorList[widget.index!], // 꺽은선 그래프의 색상
          xValueMapper: (SalesData sales, _) => sales.x,
          yValueMapper: (SalesData sales, _) => sales.y,
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
        // x축 0 1, 2, 3, 4, 5 의 스타일 변경 labelStyle
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        title: AxisTitle(
          alignment: ChartAlignment.near,
          text: "time",
          textStyle: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
      primaryYAxis: NumericAxis(
        // minimum: widget.index! >= 32 ? 0 : 0,
        // maximum: widget.index! >= 32 ? 255.0 : 65555,
        // interval: widget.index! >= 32 ? 25.0 : 500.0,
        minimum: getMinimum(),
        maximum: getMaximum(),
        interval: getInterval(),
        axisLine: const AxisLine(width: 0),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        title: AxisTitle(
          alignment: ChartAlignment.near,
          text: "value",
          textStyle: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
        labelAlignment: LabelAlignment.center,
        labelPosition: ChartDataLabelPosition.outside,
        majorGridLines: const MajorGridLines(width: 0),
      ),
    );
  }

  double getMinimum() {
    // 상단 오른쪽 첫번째 그래프
    if (widget.index == 32) {
      return 0.0;
    }
    // 상단 오른쪽 두번째 그래프
    else if (widget.index == 33) {
      return 60.0;
    }
    // 상단 오른쪽 세번째 그래프
    else if (widget.index == 34) {
      return 60.0;
    }
    // 상단 오른쪽 네번째 그래프
    else if (widget.index == 35) {
      return 40.0;
    }
    // 나머지 그래프
    else {
      return 32000;
    }
  }

  double getMaximum() {
    // 상단 오른쪽 첫번째 그래프
    if (widget.index == 32) {
      return 300.0;
    }
    // 상단 오른쪽 두번째 그래프
    else if (widget.index == 33) {
      return 90.0;
    }
    // 상단 오른쪽 세번째 그래프
    else if (widget.index == 34) {
      return 80.0;
    }
    // 상단 오른쪽 네번째 그래프
    else if (widget.index == 35) {
      return 50.0;
    }
    // 나머지 그래프
    else {
      return 33500.0;
    }
  }

  double getInterval() {
    if (widget.index! >= 32) {
      return 2.5;
    } else {
      return 500.0;
    }
  }
}
