import 'dart:ffi';

class SalesData {
  final double x;
  final int y;
  SalesData(this.x, this.y);

  @override
  String toString() {
    return "( x: " + x.toString() + ", y: " + y.toString() + " )";
  }
}
