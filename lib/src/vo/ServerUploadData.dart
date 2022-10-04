class ServerUploadData {
  // 32Ch Raster
  // 4Ch AP + LFP
  // 4Ch AP only
  // 32Ch LFP
  List<List<int>> list = [];

  /** 차트 데이터를 받기 시작한 시간 */
  String? _startTime = "";

  /** 차트 데이터를 종료한 시간 */
  String? _endTime = "";

  ServerUploadData() {
    for (int i = 0; i < 36; i++) {
      list.add(List.empty(growable: true));
    }
  }

  /** HTTP POST 통신 후 데이터 초기화. */
  void clear() {
    _startTime = "";
    _endTime = "";
    for (int i = 0; i < this.list.length; i++) {
      this.list[i].clear();
    }
  }

  /** HTTP POST 통신 하기 위한 데이터 파싱 */
  toJson(int targetNum, String fileName) {
    return {
      "fileName": fileName,
      "start_date": this._startTime,
      "end_date": this._endTime,
      "data": this.list,
    };
  }

  void setStartTime(String time) {
    _startTime = time;
  }

  String? getStartTime() {
    return _startTime;
  }

  void setEndTime(String time) {
    _endTime = time;
  }

  String? getEndTime() {
    return _endTime;
  }
}
