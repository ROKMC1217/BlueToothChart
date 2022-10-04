import 'package:blechart/Components/Device/Device_CharacteristicTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Device_ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<Device_CharacteristicTile> characteristicTiles;

  const Device_ServiceTile(
      {Key? key, required this.service, required this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Service"),
            // Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
            Text("${service.uuid.toString()}",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context).textTheme.caption?.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: const Text("Service"),
        subtitle: Text("${service.uuid.toString()}"),
        // Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}
