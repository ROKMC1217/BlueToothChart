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
      modeControlController = Provider.of<ModeControlController>(context, listen: true);
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () {
          try {
            return FlutterBlue.instance
                .startScan(
              allowDuplicates: false,
              timeout: const Duration(seconds: 4),
            )
                .then((value) {
              print("startScan success");
            }).onError((error, stackTrace) {
              print("onError");
            }).catchError((_) {
              print("catchError");
            });
          } on Exception catch (error) {
            print(error);
            return FlutterBlue.instance.stopScan();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              // 연결되었던 장치 목록 검색.
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Text(
                  "The device currently connected.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: const [],
                builder: (context, snapshot) => Column(
                  children: snapshot.data!
                      .map((bluetoothDevice) => ListTile(
                            title: Text(
                              bluetoothDevice.name,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              bluetoothDevice.id.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: bluetoothDevice.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (context, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  // OutlinedButton
                                  return OutlinedButton(
                                    style: OutlinedButton.styleFrom(
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
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ModeControl(),
                                      ),
                                    ),
                                  );
                                }
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Text(
                  "A list of devices that can be connected.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 연결 할 수 있는 장치들을 리스트로 반환.
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: const [],
                builder: (context, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (scanResult) => Home_ScanResultTile(
                          result: scanResult,
                          onTap: () async {
                            EasyLoading.show(status: 'loading...');
                            await modeControlController!.connect(scanResult);
                            EasyLoading.dismiss();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ModeControl(),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      // 블루투스 스캔 및 스캔을 중지하는 버튼.
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(
                Icons.stop,
                color: Colors.white,
              ),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.black,
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => FlutterBlue.instance.startScan(
                timeout: Duration(seconds: 4),
              ),
            );
          }
        },
      ),
    );
  }

}
