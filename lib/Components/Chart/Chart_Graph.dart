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
      selectionRectBorderColor: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
        text: widget.index! % 2 == 0 ? "          Ch${widget.index! + 1}" : "Ch${widget.index! + 1}",
        alignment: ChartAlignment.near,
        textStyle: TextStyle(
          color: getColor(),
          fontSize: 10,
        ),
      ),
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
        maximum: 0,
        isVisible: false,
        majorGridLines: const MajorGridLines(width: 0),
        enableAutoIntervalOnZooming: false,
        autoScrollingMode: AutoScrollingMode.start,
        // x축 0 1, 2, 3, 4, 5 의 스타일 변경 labelStyle
        labelStyle: TextStyle(
          inherit: false,
          color: Colors.black,
        ),
      ),
      primaryYAxis: NumericAxis(
        minimum: -100,
        maximum: 100,
        interval: 100,
        isVisible: widget.index! % 2 == 0 ? true : false,
        axisLine: const AxisLine(width: 0),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        labelAlignment: LabelAlignment.center,
        labelPosition: ChartDataLabelPosition.outside,
        majorGridLines: const MajorGridLines(width: 0),
      ),
    );
  }

  Color getColor() {
    if (widget.index == 0) {
      return Color.fromRGBO(224, 183, 193, 1);
    } else if (widget.index == 1) {
      return Color.fromRGBO(221, 100, 124, 1);
    } else if (widget.index == 2) {
      return Color.fromRGBO(189, 55, 80, 1);
    } else {
      return Color.fromRGBO(111, 40, 59, 1);
    }
  }
}
