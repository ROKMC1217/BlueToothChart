import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui';
import 'package:blechart/src/util/BluetoothUid.dart';
import 'package:blechart/src/vo/Graph.dart';
import 'package:blechart/src/vo/HttpRequestInfo.dart';
import 'package:blechart/src/vo/RingBuffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_blue/flutter_blue.dart';

class HomeController extends ChangeNotifier {
  BluetoothDevice? device;
  List<BluetoothCharacteristic>?
      characteristicList; // service의 characteristic List
  BluetoothCharacteristic? characteristic; // 통신 할 캐릭터리스틱
  BluetoothCharacteristic? characteristicLight; // LED 라이트
  List<BluetoothCharacteristic>? characteristicListLight;
  StreamSubscription<BluetoothDeviceState>? streamSubscriptionState;
  StreamSubscription<List<int>>? streamSubscriptionValue;
  RingBuffer ringBuffer = new RingBuffer();
  Graph graph = new Graph();

  Future<void> connect(ScanResult scanResult) async {
    device = scanResult.device;
    if (device == null) {
      print("device is null...");
      return;
    }
    try {
      // 여기서 연결요청을 하고 해당 페이지로 이동한다.
      device!.connect().then((value) {
        print("블루투스 연결 성공..");
        bluetoothDeviceStateListen();
      }).onError((PlatformException e, StackTrace stackTrace) {
        print("HomeController.dart connect() function error.");
        print(e.toString());
      }).catchError((_) {
        print("catchError");
      });
    } on TimeoutException catch (e) {
      print("HomeController.dart connect() function error.");
      print(e.toString());
    }
  }

  void bluetoothDeviceStateListen() {
    streamSubscriptionState =
        device!.state.listen((BluetoothDeviceState event) {
      print("============== EVENT ====================");
      print(event.toString());
      if (event == BluetoothDeviceState.connected) {
        init();
      } else if (event == BluetoothDeviceState.disconnected) {
        try {
          print(event.toString());
          streamSubscriptionState!.cancel();
          streamSubscriptionValue!.cancel();
          disconnect();
        } catch (error) {
          print(error.toString());
        }
      }
    });
  }

  void disconnect() async {
    try {
      device!.disconnect().then((value) {
        print("성공적으로 연결을 끊음.");
      }).onError((error, stackTrace) {
        print("onError");
      }).catchError((_) {
        print("catchError");
      });
    } catch (error) {
      print(error.toString());
    }
  }

  // void init() async {
  //   if (device == null) {
  //     print("device is null....");
  //     return;
  //   }
  //   try {
  //     List<BluetoothService> serviceList = await device!.discoverServices();
  //     Iterable<BluetoothService> iterator =
  //         serviceList.where((BluetoothService e) {
  //       return e.uuid.toString() == BluetoothUid.serviceUID.toString();
  //     });
  //     if (iterator.isEmpty) {
  //       print("BluetoothService List is null...");
  //       bleVO!.setFlag(false);
  //       return;
  //     }
  //     for (BluetoothService e in iterator) {
  //       characteristicList = e.characteristics;
  //       print(characteristicList.toString());
  //     }
  //     Iterable<BluetoothCharacteristic> bluetoothCharacteristic =
  //         characteristicList!.where((e) {
  //       print(e.uuid.toString());
  //       return e.uuid.toString() == BluetoothUid.characteristicUID.toString();
  //     });
  //     if (bluetoothCharacteristic.isEmpty) {
  //       bleVO!.setFlag(false);
  //       return;
  //     }
  //     print("bluetoothCharacteristic length ======");
  //     print(bluetoothCharacteristic.length.toString());
  //     characteristic = bluetoothCharacteristic.first;

  //     if (characteristic == null) {
  //       print("characteristic is null...............");
  //     } else {
  //       print("characteristic is not null...............");
  //     }

  //     // Flag 값 설정 하는 코드 추가 ...
  //     bleVO!.setFlag(true);
  //     bool result = await checkOnBluetoothCharacteristic();
  //     if (!result) {
  //       return;
  //     }
  //     onBluetoothCharacteristicListening();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  void init() async {
    if (device == null) {
      print("device is null....");
      return;
    }
    try {
      List<BluetoothService> serviceList = await device!.discoverServices();
      BluetoothService? targetBluetoothService;
      BluetoothService? targetLightBluetoothService;
      for (int i = 0; i < serviceList.length; i++) {
        if (serviceList[i].uuid.toString() ==
            BluetoothUid.serviceUID.toString()) {
          targetBluetoothService = serviceList[i];
        }
        if (serviceList[i].uuid.toString() ==
            BluetoothUid.serviceLightUID.toString()) {
          targetLightBluetoothService = serviceList[i];
        }
      }
      characteristicList = targetBluetoothService!.characteristics;
      characteristicListLight = targetLightBluetoothService!.characteristics;

      Iterable<BluetoothCharacteristic> bluetoothCharacteristic =
          characteristicList!.where((e) {
        return e.uuid.toString() == BluetoothUid.characteristicUID.toString();
      });

      for (int i = 0; i < characteristicListLight!.length; i++) {
        if (characteristicListLight![i].uuid.toString() ==
            BluetoothUid.characteristicLightUID.toString()) {
          characteristicLight = characteristicListLight![i];
          break;
        }
      }
      if (bluetoothCharacteristic.isEmpty) {
        return;
      }
      characteristic = bluetoothCharacteristic.first;
      bool result = await checkOnBluetoothCharacteristic();
      if (!result) {
        return;
      }
      onBluetoothCharacteristicListening();
    } catch (error) {
      print(error);
    }
  }

  Future<bool> checkOnBluetoothCharacteristic() async {
    try {
      bool result = await characteristic!.setNotifyValue(true);
      if (result == false) {
        print("블루투스 연결 실패....");
        print("result == ${result}");
        return false;
      }
      print("result == ${result}");
      print(characteristic!.toString());
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  void onBluetoothCharacteristicListening() async {
    streamSubscriptionValue = characteristic!.value.listen((List<int> list) {
      // list는 계속 20바이트 씩 넘어옴 (원래 20바이트씩 오는지 아니면 플러터에서 자체적으로 20바이트씩 끊어서 주는건지 모르겠음)

      // 들어온 값들을 버퍼에 저장.
      ringBuffer.addBuffer(list);

      // START ~ END 사이 개수가 196보다 같거나 크다면
      List<int>? returnValue = ringBuffer.readBuffer(196);
      if (returnValue == null) return;
      graph.allAdd(returnValue); // 여기서 에러 발생.
      graphClear();
    });
  }

  void graphClear() {
    if (graph.totalCount == 3000 ||
        graph.totalCount == 6000 ||
        graph.totalCount == 9000 ||
        graph.totalCount == Graph.TARGET_LIST_SIZE) {
      if (graph.totalCount == Graph.TARGET_LIST_SIZE) {
        graph.totalCount = 0;
        graph.allClear();
        Timer(Duration(seconds: 1), () {
          notifyListeners();
        });
      }
      notifyListeners();
    }
  }

  void bletoothWrite(List<int> timestamp) {
    try {
      // timestamp 뒤에 Ack 를 붙여 블투 장비에 전송
      List<int> timestampAck = List.from(timestamp)
        ..addAll(BluetoothUid.ack.codeUnits);
      characteristic!.write(timestampAck).then((value) {
        // print("타임스탬프와 Ack를 블루투스 장비에 전송을 성공하였다....................");
      }).onError((error, stackTrace) {
        print("onError");
      }).catchError((_) {
        print("catchError");
      });
    } on PlatformException catch (error) {
      print(error.toString());
    }
  }

  void bluetoothOnWrite() async {
    try {
      characteristicLight!.write(" ".codeUnits, withoutResponse: true);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  void bluetoothOffWrite() async {
    try {
      characteristicLight!.write("!".codeUnits, withoutResponse: true);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  void bluetoothModeWrite() async {
    try {
      if (characteristicLight == null) {
        print("characteristicLight is null........");
      }
      characteristicLight!.write("d".codeUnits, withoutResponse: true);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  void getHttp(Uri uri, Map<String, Object> body) {
    http
        .post(uri, headers: HttpRequestInfo.header, body: json.encode(body))
        .then((response) {
      print("statusCode == " + response.statusCode.toString());
      print(response.body);
    }).onError((error, stackTrace) {
      print("onError");
    }).catchError((_) {
      print("catchError");
    });
  }
}
