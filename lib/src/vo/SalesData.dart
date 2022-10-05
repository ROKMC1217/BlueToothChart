import 'dart:ffi';

class SalesData {
  final double x;
  final num y;
  SalesData(this.x, this.y);

  @override
  String toString() {
    return "( x: " + x.toString() + ", y: " + y.toString() + " )";
  }
}
