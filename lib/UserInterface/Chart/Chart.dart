import 'package:blechart/Components/Chart/Chart_Graph.dart';
import 'package:blechart/Components/Chart/Chart_StepLineGraph.dart';
import 'package:blechart/UserInterface/Upload/Upload.dart';
import 'package:blechart/src/controller/HomeController.dart';
import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:blechart/src/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Chart",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                modeControlController!.initServerUploadData();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Upload(),
                  ),
                );
              },
              child: Text(
                "File Upload",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    height: Util.height * 0.48,
                    width: Util.width * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Monkey Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Util.height * 0.03,
                        ),
                        Text(
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "C934",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Util.height * 0.03,
                        ),
                        Text(
                          "Species",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Cynomulgus",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Util.height * 0.03,
                        ),
                        Text(
                          "Gender",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Female",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Util.height * 0.03,
                        ),
                        Text(
                          "Age",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "13",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Util.height * 0.03,
                        ),
                        Text(
                          "Weight",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "3.0kg",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    for (int i = 32; i < 36; i++) ...[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 3.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          // color: Colors.white,
                          height: Util.height * 0.125,
                          width: Util.width * 0.69,
                          child: modeControlController!
                                      .graph.targetserverUploadList ==
                                  0
                              ? Chart_StepLineGraph(i: i, key: UniqueKey())
                              : Chart_Graph(i: i, key: UniqueKey()),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            // 32Ch Raster Mode와 32Ch LFP모드는 36개 보여주는게 맞다..
            if (widget.modeFlag == true) ...[
              for (int i = 0; i < 4; i++) ...[
                IgnorePointer(
                  ignoring: true,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      height: Util.height * 0.17,
                      width: Util.width * 0.95,
                      child: modeControlController!.graph.targetserverUploadList == 0
                          ? Chart_StepLineGraph(i: i, key: UniqueKey())
                          : Chart_Graph(i: i, key: UniqueKey()),
                    ),
                  ),
                ),
              ],
            ],
            if (widget.modeFlag == false) ... [
              for (int i = 0; i < 4; i++) ...[
                IgnorePointer(
                  ignoring: true,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      height: Util.height * 0.17,
                      width: Util.width * 0.95,
                      child: modeControlController!.graph.targetserverUploadList == 0
                          ? Chart_StepLineGraph(i: i, key: UniqueKey())
                          : Chart_Graph(i: i, key: UniqueKey()),
                    ),
                  ),
                ),
              ],
            ],

            // 4Ch AP Mode와 4Ch AP + LFP모드는 8개를 보여줘야 한다.
          ],
        ),
      ),
    );
  }
}
