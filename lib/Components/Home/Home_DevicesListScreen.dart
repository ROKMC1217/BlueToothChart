import 'dart:async';

import 'package:blechart/Components/Home/Home_ScanResultTile.dart';
import 'package:blechart/UserInterface/ModeControl/ModeControl.dart';
import 'package:blechart/src/controller/HomeController.dart';
import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:blechart/src/util/BluetoothUid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class Home_DevicesListScreen extends StatefulWidget {
  const Home_DevicesListScreen({Key? key}) : super(key: key);

  @override
  State<Home_DevicesListScreen> createState() => _Home_DevicesListScreenState();
}

class _Home_DevicesListScreenState extends State<Home_DevicesListScreen>
    with WidgetsBindingObserver {
  bool isInit = false;
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
      modeControlController =
          Provider.of<ModeControlController>(context, listen: true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // 포그라운드 상태
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        // 백그라운드 상태
        break;
      case AppLifecycleState.detached:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // SizedBox(width: 20),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  FlutterBlue.instance
                      .startScan(timeout: Duration(seconds: 4));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  fixedSize: Size(320, 320),
                  shape: CircleBorder(),
                  side: BorderSide(
                    width: 7.0,
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  "BLE list search",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "The device currently connected.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      StreamBuilder<List<BluetoothDevice>>(
                        stream: Stream.periodic(const Duration(seconds: 2))
                            .asyncMap(
                                (_) => FlutterBlue.instance.connectedDevices),
                        initialData: [],
                        builder: (BuildContext context,
                            AsyncSnapshot<List<BluetoothDevice>> snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: snapshot.data!
                                .map((BluetoothDevice bluetoothDevice) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    bluetoothDevice.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    bluetoothDevice.id.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  StreamBuilder<BluetoothDeviceState>(
                                    stream: bluetoothDevice.state,
                                    initialData:
                                        BluetoothDeviceState.disconnected,
                                    builder: ((BuildContext context,
                                        AsyncSnapshot<BluetoothDeviceState>
                                            snapshot) {
                                      if (snapshot.data ==
                                          BluetoothDeviceState.connected) {
                                        return OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: Size(20, 25),
                                            side: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Text(
                                            "OPEN",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ModeControl()));
                                          },
                                        );
                                      }
                                      return Text(
                                        snapshot.data.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                      Text(
                        "A list of devices that can be connected.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // 연결 할 수 있는 장치들을 리스트로 반환.
                      StreamBuilder<List<ScanResult>>(
                        stream: FlutterBlue.instance.scanResults,
                        initialData: [],
                        builder: ((BuildContext context,
                            AsyncSnapshot<List<ScanResult>> snapshot) {
                          return Column(
                            children:
                                snapshot.data!.map((ScanResult scanResult) {
                              return Home_ScanResultTile(
                                result: scanResult,
                                onTap: () async {
                                  EasyLoading.show(status: 'loading...');
                                  await modeControlController!
                                      .connect(scanResult);
                                  EasyLoading.dismiss();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ModeControl(),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
