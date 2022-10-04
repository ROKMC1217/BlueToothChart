// 휴대폰의 블루투스가 꺼져있다면 보여지는 화면.
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Home_BluetoothOffScreen extends StatelessWidget {
  final BluetoothState? state;

  const Home_BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 40.0,
              color: Colors.white54,
            ),
            SizedBox(height: 10),
            Text(
              "Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
