import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blechart/src/util/BluetoothUid.dart';
import 'package:blechart/src/vo/Graph.dart';
import 'package:blechart/src/vo/HttpRequestInfo.dart';
import 'package:blechart/src/vo/RingBuffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ModeControlController extends ChangeNotifier {
  BluetoothDevice? device;

  // service의 characteristic List
  List<BluetoothCharacteristic>? cl;

  // 통신 할 캐릭터리스틱
  BluetoothCharacteristic? characteristic;

  List<BluetoothCharacteristic>? cll;

  // LED 라이트
  BluetoothCharacteristic? characteristicLight;

  bool isListened = false;

  // 채널 기본값
  List<int> channelSelection = [18, 19, 20, 21];

  // 유저가 선택한 채널
  List<int> selected = List.empty(growable: true);

  StreamSubscription<BluetoothDeviceState>? streamSubscriptionState;
  StreamSubscription<List<int>>? streamSubscriptionValue;
  RingBuffer ringBuffer = new RingBuffer();
  Graph graph = new Graph();
  String targetFirmwareModeName = "";

  Future<void> connect(ScanResult scanResult) async {
    try {
      device = scanResult.device;
      await device!.connect();
      print("블루투스 연결 성공..");
      bluetoothDeviceStateListen();
    } on TimeoutException catch (e) {
      print("HomeController.dart connect() function error. : $e");
    }
  }

  void bluetoothDeviceStateListen() {
    streamSubscriptionState =
        device!.state.listen((BluetoothDeviceState event) {
      if (event == BluetoothDeviceState.connected) {
        init();
      }
    });
  }

  void disconnect() async {
    try {
      device!.disconnect();
      print("블루투스 연결 해제...");
    } catch (error) {
      print(error.toString());
    }
  }

  void init() async {
    try {
      // service List
      List<BluetoothService> sl = await device!.discoverServices();
      // target Bluetooth Service
      BluetoothService? tbs;
      // target Light Bluetooth Service
      BluetoothService? tlbs;

      sl.forEach((e) {
        if (e.uuid.toString() == BluetoothUid.serviceUID) tbs = e;
        if (e.uuid.toString() == BluetoothUid.serviceLightUID) tlbs = e;
      });
      cl = tbs!.characteristics;
      cll = tlbs!.characteristics;

      // 차트 데이터를 받기 위한 캐릭터리스틱 구함.
      Iterable<BluetoothCharacteristic> bc = cl!.where((e) {
        return e.uuid.toString() == BluetoothUid.characteristicUID;
      });

      // LED를 제어하기 위한 캐릭터리스틱 구함.
      for (int i = 0; i < cll!.length; i++) {
        if (cll![i].uuid.toString() == BluetoothUid.characteristicLightUID) {
          characteristicLight = cll![i];
          break;
        }
      }

      if (characteristicLight! == null) {
        print("characteristicLight is null...");
      } else {
        print("characteristicLight is not null...");
      }

      if (bc.isEmpty) {
        print("bluetooth Characteristic is isEmpty....");
        return;
      }
      characteristic = bc.first;

      print("init complete...");
      print("==================================");
    } catch (error) {
      print(error);
    }
  }

  bool isrequestMtu = false;
  Future<bool> checkOnBluetoothCharacteristic(bool flag) async {
    try {
      // mtu 설정.
      if (!isrequestMtu) {
        isrequestMtu = true;
        await device!.requestMtu(247);
      }
      bool result = await characteristic!.setNotifyValue(flag);
      if (result == false) {
        print("블루투스 연결 실패 또는 블루투스 연결 해제....");
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

  // 블루투스 장치로부터 값을 받아옴.
  // void onBluetoothCharacteristicListening() async {
  //   streamSubscriptionValue = characteristic!.value.listen((List<int> list) {
  //     // 들어온 값들을 버퍼에 저장.
  //     ringBuffer.addAllBuffer(list);

  //     // 244 || 196만큼 값을 가져옴.
  //     List<int>? returnValue = graph.targetserverUploadList == 0
  //         ? ringBuffer.readBuffer(244)
  //         : ringBuffer.readBuffer(196);

  //     if (returnValue == null) return;

  //     // 받아온 값을 채널에 맞게 파싱.
  //     graph.targetserverUploadList == 0
  //         ? graph.allAdd2(returnValue)
  //         : graph.allAdd(returnValue);

  //     // 차트에 데이터를 그림.
  //     graphClear();
  //   });
  // }

  void onBluetoothCharacteristicListening() async {
    streamSubscriptionValue = characteristic!.value.listen((List<int> list) {
      // print(list);
      // 들어온 값들을 버퍼에 저장.
      // ringBuffer.addBuffer(list);

      // List<int>? returnValue = ringBuffer.readBuffer(244);
      // if (returnValue == null) return;

      // 32Ch Raster Mode
      if (graph.targetserverUploadList == 0) {
        graph.allAdd2(list);
      }
      // 32Ch LFP Mode
      else if (graph.targetserverUploadList == 3) {
        graph.allAdd(list);
      }
      // 4Ch AP, 4Ch AP + LFP Mode
      else {
        graph.allAdd(list);
      }
      // 받아온 값을 채널에 맞게 파싱.
      // graph.targetserverUploadList == 0
      //     ? graph.allAdd2(list)
      //     : graph.allAdd(list);

      // 차트에 데이터를 그림.
      graphClear();
    });
  }

  void graphClear() {
    if (graph.targetserverUploadList == 0) {
      if (graph.totalCount == 30724) {
        notifyListeners();
      } else if (graph.totalCount == 61448) {
        notifyListeners();
      } else if (graph.totalCount == 92172) {
        notifyListeners();
      } else if (graph.totalCount >= 153620) {
        graph.allClear();
        Timer(Duration(seconds: 1), () {
          notifyListeners();
        });
      }
      return;
    } else if (graph.targetserverUploadList == 3) {
      if (graph.totalCount == 3750) {
        notifyListeners();
      } else if (graph.totalCount == 7500) {
        notifyListeners();
      } else if (graph.totalCount == 11250) {
        notifyListeners();
      } else if (graph.totalCount == 15000) {
        notifyListeners();
      } else if (graph.totalCount == 18750) {
        notifyListeners();
      } else if (graph.totalCount == 22500) {
        notifyListeners();
      } else if (graph.totalCount == 26250) {
        notifyListeners();
      } else if (graph.totalCount >= 30000) {
        graph.allClear();
        Timer(Duration(seconds: 1), () {
          notifyListeners();
        });
      }
    } else {
      if (graph.totalCount == 7500) {
        notifyListeners();
      } else if (graph.totalCount == 15000) {
        notifyListeners();
      } else if (graph.totalCount == 22500) {
        notifyListeners();
      } else if (graph.totalCount >= 30000) {
        graph.allClear();
        Timer(Duration(seconds: 1), () {
          notifyListeners();
        });
      }
    }
  }

  Future<void> setLedControl(List<int> targetList) async {
    try {
      await characteristicLight!.write(targetList, withoutResponse: true);
    } on PlatformException catch (e) {
      print("=============================================");
      // PlatformException(write_characteristic_error, writeCharacteristic failed, null, null)
      print(e.toString());
      print("=============================================");
      setLedControl(targetList);
    }
  }

  Future<Map<String, Object>> postHttp(String name, String species,
      String gender, String age, String weight, String fileName) async {
    Map<String, Object> map = {};
    try {
      var response = await http.post(
        HttpRequestInfo.myServerUri,
        headers: HttpRequestInfo.header,
        body: json.encode(
          graph.serverUploadLists[graph.targetserverUploadList!].toJson(
            graph.targetserverUploadList!,
            name,
            species,
            gender,
            age,
            weight,
            fileName,
          ),
        ),
      );
      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        map.addAll({
          "boolean": false,
          "statusCode": response.statusCode,
        });
        return map;
      }
      map.addAll({
        "boolean": true,
        "statusCode": response.statusCode,
      });
      return map;
    } catch (e) {
      print(e.toString());
      map.addAll({
        "boolean": false,
        "statusCode": -9999,
      });
      return map;
    }
  }

  // Firmware Mode 변경
  Future<void> setFirmwareMode(
      int command, changeMode, String firmwareModeName) async {
    DateTime now = DateTime.now();
    graph.targetserverUploadList = changeMode;
    graph.allClear();
    targetFirmwareModeName = firmwareModeName;
    await setLedControl([command]);
    graph.serverUploadLists[changeMode].setStartTime(
        DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second)
            .toString());
    if (this.isListened == false) {
      await checkOnBluetoothCharacteristic(true);
      onBluetoothCharacteristicListening();
    }
  }

  void initServerUploadData() {
    streamSubscriptionValue!.cancel();
    checkOnBluetoothCharacteristic(false);
    DateTime now = DateTime.now();
    graph.serverUploadLists[graph.targetserverUploadList!].setEndTime(
      DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second)
          .toString(),
    );
  }

  void addBuffer(int n) {
    ringBuffer.addBuffer([n]);
  }
}
