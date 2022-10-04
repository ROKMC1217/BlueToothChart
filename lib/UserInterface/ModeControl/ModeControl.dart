import 'package:blechart/UserInterface/Chart/Chart.dart';
import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:blechart/src/util/Util.dart';
import 'package:blechart/src/vo/Graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModeControl extends StatefulWidget {
  const ModeControl({Key? key}) : super(key: key);

  @override
  State<ModeControl> createState() => _ModeControlState();
}

class _ModeControlState extends State<ModeControl> {
  bool isInit = false;

  ModeControlController? modeControlController;
  Graph? graph;
  Color targetColor = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = !isInit;
      modeControlController =
          Provider.of<ModeControlController>(context, listen: true);
    }
  }

  void alert() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("개발중입니다."),
          content: Text("개발중입니다."),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "확인",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text(
            "Mode Controller",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Row(
          children: <Widget>[
            Padding(padding: const EdgeInsets.symmetric(horizontal: 3)),
            Flexible(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: Util.height * 0.07,
                    decoration: BoxDecoration(
                      color: targetColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Firmware Mode",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      modeControlController!
                          .setFirmwareMode(100, 0, "32Ch Raster");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Chart(true),
                        ),
                      );
                    },
                    child: Container(
                      height: Util.height * 0.11,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "32Ch Raster",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      modeControlController!.setFirmwareMode(101, 2, "4Ch AP");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Chart(false),
                        ),
                      );
                    },
                    child: Container(
                      height: Util.height * 0.11,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "4Ch AP",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      modeControlController!
                          .setFirmwareMode(103, 3, "32Ch LFP");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Chart(true),
                        ),
                      );
                    },
                    child: Container(
                      height: Util.height * 0.11,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "32Ch LFP",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // modeControlController!
                      //     .setFirmwareMode(102, 1, "4Ch AP + LFP");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Chart(false),
                        ),
                      );
                    },
                    child: Container(
                      height: Util.height * 0.11,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "4Ch AP + LFP",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 5)),
            Flexible(
              child: Column(
                children: <Widget>[
                  Container(
                    height: Util.height * 0.07,
                    decoration: BoxDecoration(
                      color: targetColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Channel Selection",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          numberButton("0", 0, 200),
                          numberButton("1", 1, 201),
                          numberButton("2", 2, 202),
                          numberButton("3", 3, 203),
                          numberButton("4", 4, 204),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          numberButton("5", 5, 205),
                          numberButton("6", 6, 206),
                          numberButton("7", 7, 207),
                          numberButton("8", 8, 208),
                          numberButton("9", 9, 209),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          numberButton("10", 10, 210),
                          numberButton("11", 11, 211),
                          numberButton("12", 12, 212),
                          numberButton("13", 13, 213),
                          numberButton("14", 14, 214),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          numberButton("15", 15, 215),
                          numberButton("16", 16, 216),
                          numberButton("17", 17, 217),
                          numberButton("18", 18, 218),
                          numberButton("19", 19, 219),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          numberButton("20", 20, 220),
                          numberButton("21", 21, 221),
                          numberButton("22", 22, 222),
                          numberButton("23", 23, 223),
                          numberButton("24", 24, 224),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          numberButton("25", 25, 225),
                          numberButton("26", 26, 226),
                          numberButton("27", 27, 227),
                          numberButton("28", 28, 228),
                          numberButton("29", 29, 229),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          numberButton("30", 30, 230),
                          numberButton("31", 31, 231),
                        ],
                      ),
                    ],
                  ),
                  //
                  InkWell(
                    onTap: () {
                      modeControlController!.setLedControl([119]);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: Util.height * 0.07,
                      decoration: BoxDecoration(
                        color: targetColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "System Restart",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 3)),
          ],
        ),
      ),
    );
  }

  Widget numberButton(String value, int chMode, rasterMode) {
    return GestureDetector(
      onTap: () {
        print("$chMode Click");
        modeControlController!.setLedControl([chMode]);
        modeControlController!.addBuffer(chMode);
      },
      child: Container(
        width: Util.width * 0.035,
        height: Util.width * 0.035,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          // color: Colors.blue[100],
          color: targetColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
