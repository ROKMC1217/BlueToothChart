import 'package:blechart/src/vo/SalesData.dart';
import 'package:blechart/src/vo/ServerUploadData.dart';

/** RingBuffer로부터 밭아온 값을 채널에 맞게 파싱하는 클래스 */
class Graph {
  static const TARGET_LIST_SIZE = 30000;
  static const RASTER_SIZE = 153620;
  static const LFP_SIZE = 30000;
  // static const AP_LFP_SIZE = 30008;
  static const AP_LFP_SIZE = 976;
  int totalCount = 0;

  /** 지금까지 받아왔던 차트 데이터(화면에 보여주기 위한 리스트) */
  List<List<SalesData>> totalList = List.empty(growable: true);

  // serverUploadLists[0] : 32Ch Raster
  // serverUploadLists[1] : 4Ch AP + LFP
  // serverUploadLists[2] : 4Ch AP only
  // serverUploadLists[3] : 32Ch LFP
  /** 지금까지 받아왔던 차트 데이터(서버에 업로드 하기 위한 값들을 저장하는 리스트) */
  List<ServerUploadData> serverUploadLists = List.empty(growable: true);

  int powerLevel = 0;
  num xAxis = 0;
  num yAxis = 0;
  num zAxis = 0;

  /** 서버에 업로드 하기 위한 값을 구분하기 위한 serverUploadLists의 인덱스 번호 플래그 */
  int? targetserverUploadList;

  Graph() {
    for (int i = 0; i < 36; i++) {
      totalList.add(new List.empty(growable: true));
    }
    for (int i = 1; i <= 4; i++) {
      serverUploadLists.add(new ServerUploadData());
    }
  }

  /** 1 ~ 36 채널에 데이터를 저장 32Ch Raster Mode */
  bool allAdd2(List<int> list) {
    if (list.length != 244) return false;

    for (int cnt = 0; cnt < 60; cnt++) {
      for (int channel = 0; channel < 32; channel++) {
        for (int channelbytes = 0; channelbytes < 4; channelbytes++) {
          for (int bytes = 0; bytes < 8; bytes++) {
            if (list[channelbytes] % 2 == 1) {
              totalList[channel].add(SalesData(
                  (5 * totalCount++) / RASTER_SIZE, list[channelbytes] % 2));
            }
            try {
              serverUploadLists[targetserverUploadList!]
                  .list[channel]
                  .add(list[channelbytes] % 2);
            } on OutOfMemoryError catch (e) {
              print(e.toString());
              print("Graph class allAdd2 function ERROR");
              serverUploadLists[targetserverUploadList!].list.clear();
            }
          }
        }
      }
    }

    powerLevel = ((list[240] / 245) * 100).floor();
    xAxis = list[241];
    yAxis = list[242];
    zAxis = list[243];

    totalList[32].add(SalesData((5 * totalCount++) / RASTER_SIZE, powerLevel));
    totalList[33].add(SalesData((5 * totalCount++) / RASTER_SIZE, xAxis));
    totalList[34].add(SalesData((5 * totalCount++) / RASTER_SIZE, yAxis));
    totalList[35].add(SalesData((5 * totalCount++) / RASTER_SIZE, zAxis));

    serverUploadLists[targetserverUploadList!].list[32].add(powerLevel);
    serverUploadLists[targetserverUploadList!].list[33].add(xAxis);
    serverUploadLists[targetserverUploadList!].list[34].add(yAxis);
    serverUploadLists[targetserverUploadList!].list[35].add(zAxis);
    return true;
  }

  /** 4Ch AP, 4Ch AP + LFP Mode */
  // bool Four_AP_LFP(List<int> list) {
  //   if (list.length != 244) return false;

  //   for (int i = 0; i < 30; i++) {
  //     for (int cnt = 0; cnt < 4; cnt++) {
  //       int tn =
  //           (list[(cnt * 2) + (i * 8)] * 0x100) + list[(cnt * 2) + (i * 8) + 1];
  //       // 유저의 화면에 보여주기 위한 값을 저장.
  //       totalList[cnt].add(SalesData(totalCount++ / AP_LFP_SIZE, tn));
  //       // 서버에 업로드 하기 위한 데이터 저장
  //       serverUploadLists[targetserverUploadList!].list[cnt].add(tn);
  //     }
  //   }
  //   powerLevel = ((list[240] / 245) * 100).floor();
  //   totalList[32].add(SalesData((4 * totalCount++) / AP_LFP_SIZE, powerLevel));
  //   totalList[33].add(SalesData((4 * totalCount++) / AP_LFP_SIZE, list[241]));
  //   totalList[34].add(SalesData((4 * totalCount++) / AP_LFP_SIZE, list[242]));
  //   totalList[35].add(SalesData((4 * totalCount++) / AP_LFP_SIZE, list[243]));
  //   serverUploadLists[targetserverUploadList!].list[32].add(powerLevel);
  //   serverUploadLists[targetserverUploadList!].list[33].add(list[241]);
  //   serverUploadLists[targetserverUploadList!].list[34].add(list[242]);
  //   serverUploadLists[targetserverUploadList!].list[35].add(list[243]);
  //   return true;
  // }

  /** 32Ch LFP Mode */
  bool allAdd(List<int> list) {
    if (list.length != 244) return false;

    // 0 ~ 195
    for (int i = 0; i < 3; i++) {
      for (int cnt = 0; cnt < 32; cnt++) {
        int tn = (list[(cnt * 2) + (i * 64)] * 0x100) +
            list[(cnt * 2) + (i * 64) + 1];

        // 유저의 화면에 보여주기 위한 값을 저장.
        totalList[cnt]
            .add(SalesData((5 * totalCount++) / TARGET_LIST_SIZE, tn));
        // 서버에 업로드 하기 위한 데이터 저장
        serverUploadLists[targetserverUploadList!].list[cnt].add(tn);
      }
    }
    powerLevel = ((list[240] / 245) * 100).floor();
    xAxis = list[241];
    yAxis = list[242];
    zAxis = list[243];
    totalList[32]
        .add(SalesData((5 * totalCount++) / TARGET_LIST_SIZE, powerLevel));
    totalList[33]
        .add(SalesData((5 * totalCount++) / TARGET_LIST_SIZE, xAxis));
    totalList[34]
        .add(SalesData((5 * totalCount++) / TARGET_LIST_SIZE, yAxis));
    totalList[35]
        .add(SalesData((5 * totalCount++) / TARGET_LIST_SIZE, zAxis));
    serverUploadLists[targetserverUploadList!].list[32].add(powerLevel);
    serverUploadLists[targetserverUploadList!].list[33].add(xAxis);
    serverUploadLists[targetserverUploadList!].list[34].add(yAxis);
    serverUploadLists[targetserverUploadList!].list[35].add(zAxis);
    return true;
  }

  /** 차트가 한 사이클을 돌았다면 기존 차트 데이터를 삭제 */
  void allClear() {
    totalCount = 0;
    for (int i = 0; i < totalList.length; i++) {
      totalList[i].clear();
    }
  }

  /** HTTP POST 통신 후 데이터 초기화. */
  void serverUploadListsAllClear() {
    for (int i = 0; i < serverUploadLists.length; i++) {
      serverUploadLists[i].clear();
    }
  }
}
