import 'package:blechart/Components/Home/Home_BluetoothOffScreen.dart';
import 'package:blechart/Components/Home/Home_DevicesListScreen.dart';
import 'package:blechart/Components/Home/Home_FindDevicesScreen.dart';
import 'package:blechart/UserInterface/Chart/Chart.dart';
import 'package:blechart/UserInterface/Chart/Example.dart';
import 'package:blechart/UserInterface/Upload/Upload.dart';
import 'package:blechart/src/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Util.setSize(MediaQuery.of(context).size);
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
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (context, snapshot) {
        // BluetoothState : 블루투스 어댑터 상태.
        final BluetoothState? state = snapshot.data;
        if (state == BluetoothState.on) {
          // 블루투스가 켜져있다면 다음 화면으로 이동.
          // return Home_FindDevicesScreen();
          return Home_DevicesListScreen();
        }
        // 블루투스가 꺼져있다면 다음 화면으로 이동.
        return Home_BluetoothOffScreen();
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: Example(),
  //   );
  // }
}
