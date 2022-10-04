/** 블루투스 장치로부터 받아온 값을 저장하는 기능을 적은 클래스 */
class RingBuffer {
  static int TOTAL_LENGTH = 244;

  // 65536
  static const int _BUFFER_SIZE = 4;

  // 버퍼의 START ~ END 사이의 개수
  int totalCount = 0;

  // START COUNT
  int start = 0;

  // END COUNT
  int end = 0;

  // 실 데이터 저장하는 버퍼
  // final List<int> _buffer = List.filled(_BUFFER_SIZE, 0);
  List<int> _buffer = [18, 19, 20, 21];

  // START ~ END 사이 개수
  int getTotalCount() =>
      // totalCount = end - start < 0 ? start - end : end - start;
      totalCount = end - start < 0 ? (_BUFFER_SIZE - start) + end : end - start;

  List<int> getBuffer() => _buffer;

  // bool addBuffer(int element) {
  //   if (getTotalCount() + 1 > _BUFFER_SIZE) return false;
  //   if (end == _BUFFER_SIZE) end = 0;

  //   _buffer[end] = element;
  //   end++;

  //   return true;
  // }

  void printBuffer() {
    print("start              : ${start}");
    print("end                : ${end}");
    print("BUFFER_SIZE - end  : ${_BUFFER_SIZE - end}");
    print("start ~ end        : ${getTotalCount()}");
  }

  bool addBuffer(List<int> list) {
    if (list.length > _BUFFER_SIZE) return false;
    // if (list.length > _BUFFER_SIZE - getTotalCount()) return false;

    // remaining이 0이하면 버퍼가 꽉 찼다는 뜻이다.
    // remaining이 0보다 크면 버퍼에 남아있는 공간이 있다는 뜻이다.
    int remaining = _BUFFER_SIZE - end;

    // remaining이 list.length보다 같거나 크면 _buffer에 저장.
    if (remaining >= list.length) {
      _buffer.setRange(end, end + list.length, list, 0);
      end += list.length;
    }
    // remaining이 0이거나 0보다 작다면 (가용 할 수 있는 공간이 아예 없는 경우)
    else if (remaining <= 0) {
      _buffer.setRange(0, list.length, list, 0);
      start = 0;
      end = list.length;
    }
    // remaining이 list.length보다 작다면 (_buffer에 값이 저장될 공간이 없다면)
    else {
      // endPoint : 남은 list의 개수
      int endPoint = list.length - remaining;
      _buffer.setRange(end, _BUFFER_SIZE, list, 0);
      _buffer.setRange(0, endPoint, list, remaining); // 여기서 에러 뜸............
      end = endPoint;
    }
    _buffer.sort();
    return true;
  }

  List<int>? readBuffer(int length) {
    if (getTotalCount() < TOTAL_LENGTH) {
      return null;
    }
    // 사용자가 버퍼의 크기보다 더 큰수를 요청했을 떄
    if (length < 0 || length > TOTAL_LENGTH) {
      // 음수를 요청 할 수 없음.
      // length가 TOTAL_LENGTH보다 큰 경우도 안됨. 왜냐 244만큼만 처리 해야 하기 때문.
      return null;
    }

    // end가 앞에 있고 start가 뒤에 있는 경우.
    if (end < start) {
      // START ~ _BUFFER_SIZE 까지 자르고, 0 ~ END 까지 자른 후 두개를 합친 배열을 리턴 한다.
      List<int> dummy1 = List.filled(_BUFFER_SIZE - start, 0);
      List<int> dummy2 = List.filled(end, 0);

      List.copyRange(dummy1, 0, _buffer, start, _buffer.length);
      List.copyRange(dummy2, 0, _buffer, 0, end);
      List<int> returnValue = List.empty(growable: true);
      returnValue.addAll(dummy1);
      returnValue.addAll(dummy2);
      if (returnValue.length != TOTAL_LENGTH) return null;

      // START를 END값으로 저장해준다 ex) START = END; 그럼 START와 END가 가리키는 곳이 같아진다.
      start = end;

      return returnValue;
    } else if (end > start) {
      int temp = end;
      if (end - start > TOTAL_LENGTH) {
        // ex) end = 460, start = 200 이라면....
        end = start + TOTAL_LENGTH;
      }
      List<int> dummy = List.filled(getTotalCount(), 0);
      List.copyRange(dummy, 0, _buffer, start, end);

      if (dummy.length != TOTAL_LENGTH) return null;
      start = end;
      end = temp;
      return dummy;
    } else {
      return null;
    }
  }

  void clearBuffer() {
    if (this._buffer != 0) {
      _buffer.clear();
    }

    start = end = 0;
    totalCount = 0;
  }
}
