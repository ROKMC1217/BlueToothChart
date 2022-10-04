// import 'dart:async';
// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
// import 'dart:typed_data';

// import 'dart:ui';
// import 'package:blechart/src/util/BluetoothUid.dart';
// import 'package:blechart/src/vo/BluetoothVO.dart';
// import 'package:blechart/src/vo/InitializeDataVO.dart';
// import 'package:blechart/src/vo/LifecycleStateVO.dart';
// import 'package:blechart/src/vo/LiveData.dart';
// import 'package:blechart/src/vo/ScanResultVO.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_blue/flutter_blue.dart';

// class HomeController {
//   InitializeDataVO initializeDataVO = InitializeDataVO();
//   LifecycleStateVO? lifecycleStateVO;
//   BluetoothVO? bleVO;
//   ScanResultVO? scanResultVO;
//   // Coordinate? coordinate;
//   BluetoothDevice? device;
//   List<BluetoothCharacteristic>?
//       characteristicList; // service의 characteristic List
//   BluetoothCharacteristic? characteristic; // 통신 할 캐릭터리스틱
//   StreamSubscription<BluetoothDeviceState>? streamSubscriptionState;
//   StreamSubscription<List<int>>? streamSubscriptionValue;

//   LiveData? liveData;

//   // 생성자
//   HomeController(
//       BluetoothVO bluetoothVO, LifecycleStateVO? state, LiveData livedata) {
//     bleVO = bluetoothVO;
//     lifecycleStateVO = state;
//     liveData = livedata;
//   }

//   Future<void> connect(ScanResult scanResult) async {
//     device = scanResult.device;
//     if (device == null) {
//       print("device is null...");
//       return;
//     }
//     try {
//       // 여기서 연결요청을 하고 해당 페이지로 이동한다.
//       device!.connect().then((value) {
//         print("블루투스 연결 성공..");
//         bluetoothDeviceStateListen();
//       }).onError((PlatformException e, StackTrace stackTrace) {
//         print("HomeController.dart connect() function error.");
//         print(e.toString());
//       }).catchError((_) {
//         print("catchError");
//       });
//     } on TimeoutException catch (e) {
//       print("HomeController.dart connect() function error.");
//       print(e.toString());
//     }
//   }

//   void bluetoothDeviceStateListen() {
//     streamSubscriptionState =
//         device!.state.listen((BluetoothDeviceState event) {
//       print("============== EVENT ====================");
//       print(event.toString());
//       if (event == BluetoothDeviceState.connected) {
//         init();
//       } else if (event == BluetoothDeviceState.disconnected) {
//         try {
//           print(event.toString());
//           bleVO!.setFlag(false);
//           streamSubscriptionState!.cancel();
//           streamSubscriptionValue!.cancel();
//           disconnect();
//         } catch (error) {
//           print(error.toString());
//         }
//       }
//     });
//   }

//   void disconnect() async {
//     try {
//       // if (scanResultVO!.getScanResult().device == null) {
//       //   print("scanResultVO!.getScanResult() is null...");
//       // } else {
//       //   print("scanResultVO!.getScanResult() is not null...");
//       // }
//       device!.disconnect().then((value) {
//         print("성공적으로 연결을 끊음.");
//         bleVO!.setFlag(false);
//       }).onError((error, stackTrace) {
//         print("onError");
//       }).catchError((_) {
//         print("catchError");
//       });
//     } catch (error) {
//       print(error.toString());
//     }
//   }

//   void init() async {
//     if (device == null) {
//       print("device is null....");
//       return;
//     }
//     try {
//       List<BluetoothService> serviceList = await device!.discoverServices();
//       Iterable<BluetoothService> iterator = serviceList.where(
//           (BluetoothService e) =>
//               e.uuid.toString() == BluetoothUid.serviceUID.toString());
//       if (iterator.isEmpty) {
//         print("BluetoothService List is null...");
//         bleVO!.setFlag(false);
//         return;
//       }
//       for (var e in iterator) {
//         characteristicList = e.characteristics;
//       }
//       Iterable<BluetoothCharacteristic> bluetoothCharacteristic =
//           characteristicList!.where((e) =>
//               e.uuid.toString() == BluetoothUid.characteristicUID.toString());
//       if (bluetoothCharacteristic.isEmpty) {
//         print("bluetoothCharacteristic is null..........");
//         bleVO!.setFlag(false);
//         return;
//       }
//       for (var e in bluetoothCharacteristic) {
//         characteristic = e;
//       }
//       // Flag 값 설정 하는 코드 추가 ...
//       bleVO!.setFlag(true);
//       onBluetoothCharacteristic();
//     } catch (error) {
//       print(error);
//     }
//   }

//   void onBluetoothCharacteristic() {
//     try {
//       characteristic!.setNotifyValue(true).then((value) {
//         print("value = $value");
//         print("연결성공");
//       }).onError((error, stackTrace) {
//         print(error.toString());
//       }).catchError((_) {
//         print("catchError");
//       });
//     } catch (error) {
//       print(error.toString());
//     }
//     streamSubscriptionValue = characteristic!.value.listen((List<int> list) {
//       if (list.length > liveData!.getTotalCount()) {
//         print("약 20바이트씩 들어오다 갑자기 244바이트 이상 들어오면 예외 던짐.");
//         return;
//       }
//       // 현재 버퍼1에 작업중이라면...
//       if (liveData!.getBeInUsebuffer() == true) {
//         // 기존 버퍼1의 크기와 현재 들어온 list의 크기를 합 했을 때 244보다 크다면..
//         if (liveData!.getBuffer1().length + list.length >
//             liveData!.getTotalCount()) {
//           int buffer1Remaining = liveData!.getTotalCount() -
//               liveData!.getBuffer1().length; // 버퍼1의 비어있는 공간

//           // 버퍼1의 남아있는 공간이 현재 받아온 값보다 같거나 크다면 다 채운다.
//           if (buffer1Remaining >= list.length) {
//             liveData!.addAllBuffer1(list);
//             liveData!.setCount1(liveData!.getCount1() + list.length);
//           }
//           // 하지만 만약에 버퍼1의 남아있는 공간이 현재 받아온 값보다 작다면 현재 받아온 값을 잘라서 버퍼1을 채우고
//           // 나머지 값은 버퍼2에 저장한다. 이때 count1과 count2도 업데이트 해야 한다.
//           else if (buffer1Remaining < list.length) {
//             List<int> first = List.filled(buffer1Remaining, 0);
//             List<int> last = List.filled(list.length - buffer1Remaining, 0);

//             List.copyRange(first, 0, list, 0, buffer1Remaining);
//             List.copyRange(last, 0, list, buffer1Remaining, list.length);
//             liveData!.addAllBuffer1(first);
//             liveData!.addAllBuffer2(last);
//             liveData!.setCount1(liveData!.getCount1() + first.length);
//             liveData!.setCount2(liveData!.getCount2() + last.length);
//           }
//         } else {
//           liveData!.addAllBuffer1(list);
//           liveData!.setCount1(liveData!.getCount1() + list.length);
//         }
//         if (liveData!.getBuffer1().length == liveData!.getTotalCount()) {
//           // 출력
//           print("buffer1");
//           // print("buffer1 length: " + buffer1.length.toString());
//           // print(buffer1);
//           int temp = 0;
//           for (int count = 0; count < 30; count++) {
//             temp = count * 8;

//             print(liveData!.getBuffer1());
//             liveData!.addTargetC(
//               count,
//               (liveData!.getBuffer1()[temp++] * 0x100) +
//                   liveData!.getBuffer1()[temp++],
//             );

//             liveData!.addTargetD(
//               count,
//               (liveData!.getBuffer1()[temp++] * 0x100) +
//                   liveData!.getBuffer1()[temp++],
//             );

//             liveData!.addTargetA(
//               count,
//               (liveData!.getBuffer1()[temp++] * 0x100) +
//                   liveData!.getBuffer1()[temp++],
//             );

//             liveData!.addTargetB(
//               count,
//               (liveData!.getBuffer1()[temp++] * 0x100) +
//                   liveData!.getBuffer1()[temp++],
//             );
//           }
//           liveData!.setE(liveData!.getBuffer1()[temp++]);
//           liveData!.setF(liveData!.getBuffer1()[temp++]);
//           liveData!.setG(liveData!.getBuffer1()[temp++]);
//           liveData!.setH(liveData!.getBuffer1()[temp]);
//           print(liveData!.getA());
//           print(liveData!.getB());
//           print(liveData!.getC());
//           print(liveData!.getD());
//           print(liveData!.getE());
//           print(liveData!.getF());
//           print(liveData!.getG());
//           print(liveData!.getH());

//           liveData!.setCount1(0);
//           liveData!.setBeInUsebuffer(false);
//           liveData!.clearBuffer1();
//         }
//       }
//       // 현재 버퍼2에 작업중이라면...
//       else {
//         // 기존 버퍼2의 크기가 현재 들어온 list의 크기를 합 했을 때 244보다 크다면..

//         if (liveData!.getBuffer2().length + list.length >
//             liveData!.getTotalCount()) {
//           // 버퍼2의 비어있는 공간
//           int buffer2Remaining =
//               liveData!.getTotalCount() - liveData!.getBuffer2().length;

//           // 버퍼2의 남아있는 공간이 현재 받아온 값보다 같거나 크다면 다 채운다.
//           if (buffer2Remaining >= list.length) {
//             liveData!.addAllBuffer2(list);
//             liveData!.setCount2(liveData!.getCount2() + list.length);
//           }
//           // 하지만 만약에 버퍼2의 남아있는 공간이 현재 받아온 값보다 작다면 현재 받아온 값을 잘라 버퍼2를 채우고
//           // 나머지 값은 버퍼1에 저장한다. 이때 count1 과 count2도 업데이트 해야한다.
//           else if (buffer2Remaining < list.length) {
//             List<int> first = List.filled(buffer2Remaining, 0);
//             List<int> last = List.filled(list.length - buffer2Remaining, 0);

//             List.copyRange(first, 0, list, 0, buffer2Remaining);
//             List.copyRange(last, 0, list, buffer2Remaining, list.length);

//             liveData!.addAllBuffer2(first);
//             liveData!.addAllBuffer1(last);
//           }
//         } else {
//           liveData!.addAllBuffer2(list);
//           liveData!.setCount2(liveData!.getCount2() + list.length);
//         }
//         if (liveData!.getBuffer2().length == liveData!.getTotalCount()) {
//           // 출력
//           print("buffer2");
//           // print("buffer2");
//           // print("buffer2 length: " + buffer2.length.toString());
//           int temp = 0;
//           for (int count = 0; count < 30; count++) {
//             temp = count * 8;

//             liveData!.addTargetC(
//               count,
//               (liveData!.getBuffer2()[temp++] * 0x100) +
//                   liveData!.getBuffer2()[temp++],
//             );

//             liveData!.addTargetD(
//               count,
//               (liveData!.getBuffer2()[temp++] * 0x100) +
//                   liveData!.getBuffer2()[temp++],
//             );

//             liveData!.addTargetA(
//               count,
//               (liveData!.getBuffer2()[temp++] * 0x100) +
//                   liveData!.getBuffer2()[temp++],
//             );

//             liveData!.addTargetB(
//               count,
//               (liveData!.getBuffer2()[temp++] * 0x100) +
//                   liveData!.getBuffer2()[temp++],
//             );
//           }

//           liveData!.setE(liveData!.getBuffer2()[temp++]);
//           liveData!.setF(liveData!.getBuffer2()[temp++]);
//           liveData!.setG(liveData!.getBuffer2()[temp++]);
//           liveData!.setH(liveData!.getBuffer2()[temp]);
//           print(liveData!.getA());
//           print(liveData!.getB());
//           print(liveData!.getC());
//           print(liveData!.getD());
//           print(liveData!.getE());
//           print(liveData!.getF());
//           print(liveData!.getG());
//           print(liveData!.getH());

//           liveData!.setCount2(0);
//           liveData!.setBeInUsebuffer(true);
//           liveData!.clearBuffer2();
//         }
//       }
//     });
//   }

//   void bletoothWrite(List<int> timestamp) {
//     try {
//       // timestamp 뒤에 Ack 를 붙여 블투 장비에 전송
//       List<int> timestampAck = List.from(timestamp)
//         ..addAll(BluetoothUid.ack.codeUnits);
//       characteristic!.write(timestampAck).then((value) {
//         // print("타임스탬프와 Ack를 블루투스 장비에 전송을 성공하였다....................");
//       }).onError((error, stackTrace) {
//         print("onError");
//       }).catchError((_) {
//         print("catchError");
//       });
//     } on PlatformException catch (error) {
//       print(error.toString());
//     }
//   }
// }
