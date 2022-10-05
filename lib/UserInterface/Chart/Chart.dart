import 'package:blechart/Components/Chart/Chart_Graph.dart';
import 'package:blechart/Components/Chart/Chart_StepLineGraph.dart';
import 'package:blechart/UserInterface/Upload/Upload.dart';
import 'package:blechart/src/controller/HomeController.dart';
import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:blechart/src/util/Util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class Chart extends StatefulWidget {
  bool? modeFlag;

  Chart(bool flag) {
    modeFlag = flag;
  }

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> with WidgetsBindingObserver {
  bool isInit = false;
  HomeController? homeController;
  ModeControlController? modeControlController;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            // META DATA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "LEF Control",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              modeControlController!.setLedControl([34]);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: Util.width * 0.1,
                              height: Util.height * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Red on",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              modeControlController!.setLedControl([32]);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: Util.width * 0.1,
                              height: Util.height * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Green on",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              modeControlController!.setLedControl([35]);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: Util.width * 0.1,
                              height: Util.height * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Red off",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              modeControlController!.setLedControl([33]);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: Util.width * 0.1,
                              height: Util.height * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Green off",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Util.width * 0.152,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Power Level",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${modeControlController!.graph.powerLevel}%",
                        style: TextStyle(
                          fontSize: 29,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: setPowerLevel(),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Acceleration Value",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "X-axis",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(214, 231, 239, 1),
                                ),
                              ),
                              Text(
                                "${modeControlController!.graph.xAxis}",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(214, 231, 239, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Y-axis",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(178, 208, 220, 1),
                                ),
                              ),
                              Text(
                                "${modeControlController!.graph.yAxis}",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(178, 208, 220, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "z-axis",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(120, 150, 166, 1),
                                ),
                              ),
                              Text(
                                "${modeControlController!.graph.zAxis}",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(120, 150, 166, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    modeControlController!.initServerUploadData();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Upload(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(10, 50),
                  ),
                  child: Text(
                    "File Upload",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Ch1 ~ Ch2
            Row(
              children: <Widget>[
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: Util.width * 0.5,
                    height: Util.height * 0.3,
                    child:
                        modeControlController!.graph.targetserverUploadList == 0
                            ? Chart_StepLineGraph(i: 0, key: UniqueKey())
                            : Chart_Graph(i: 0, key: UniqueKey()),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: Util.width * 0.5,
                    height: Util.height * 0.3,
                    child:
                        modeControlController!.graph.targetserverUploadList == 0
                            ? Chart_StepLineGraph(i: 1, key: UniqueKey())
                            : Chart_Graph(i: 1, key: UniqueKey()),
                  ),
                ),
              ],
            ),

            // Ch3 ~ Ch4
            Row(
              children: <Widget>[
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: Util.width * 0.5,
                    height: Util.height * 0.3,
                    child:
                        modeControlController!.graph.targetserverUploadList == 0
                            ? Chart_StepLineGraph(i: 2, key: UniqueKey())
                            : Chart_Graph(i: 2, key: UniqueKey()),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: Util.width * 0.5,
                    height: Util.height * 0.3,
                    child:
                        modeControlController!.graph.targetserverUploadList == 0
                            ? Chart_StepLineGraph(i: 3, key: UniqueKey())
                            : Chart_Graph(i: 3, key: UniqueKey()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> setPowerLevel() {
    if (0 <= modeControlController!.graph.powerLevel && modeControlController!.graph.powerLevel < 20) {
      return <Widget>[
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ];
    } else if (20 <= modeControlController!.graph.powerLevel && modeControlController!.graph.powerLevel < 40) {
      return <Widget>[
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ];
    } else if (40 <= modeControlController!.graph.powerLevel && modeControlController!.graph.powerLevel < 60) {
      return <Widget>[
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[200],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ];
    } else if (60 <= modeControlController!.graph.powerLevel && modeControlController!.graph.powerLevel < 80) {
      return <Widget>[
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[200],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[300],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ];
    } else {
      return <Widget>[
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[200],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[300],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 3),
        Container(
          width: Util.width * 0.025,
          height: Util.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.purple[400],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ];
    }
  }

  
}
