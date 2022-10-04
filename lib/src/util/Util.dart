import 'package:blechart/src/vo/SalesData.dart';
import 'package:flutter/material.dart';

class Util {
  static late Size size;
  static late double width;
  static late double height;

  static final List<Color> colorList = <Color>[
    Colors.pink[100] as Color,
    Colors.pink[300] as Color,
    Colors.pink[700] as Color,
    Colors.red[100] as Color,
    Colors.red[200] as Color,
    Colors.red[300] as Color,
    Colors.red[400] as Color,
    Colors.red[600] as Color,
    Colors.deepOrange[100] as Color,
    Colors.deepOrange[200] as Color,
    Colors.deepOrange[300] as Color,
    Colors.deepOrange[400] as Color,
    Colors.deepOrange[600] as Color,
    Colors.orange[100] as Color,
    Colors.orange[400] as Color,
    Colors.orange[600] as Color,
    Colors.orange[800] as Color,
    Colors.orange[900] as Color,
    Colors.lightGreen[200] as Color,
    Colors.lightGreen[400] as Color,
    Colors.lightGreen[700] as Color,
    Colors.lightGreenAccent[100] as Color,
    Colors.lightGreenAccent[400] as Color,
    Colors.teal[200] as Color,
    Colors.teal[300] as Color,
    Colors.teal[400] as Color,
    Colors.cyan[200] as Color,
    Colors.lightBlue[200] as Color,
    Colors.lightBlue[400] as Color,
    Colors.lightBlue[700] as Color,
    Colors.indigo[100] as Color,
    Colors.indigo[300] as Color,
    Colors.indigo[600] as Color,
    Colors.purple[200] as Color,
    Colors.purple[400] as Color,
    Colors.purpleAccent[400] as Color,
    Colors.purpleAccent[700] as Color,
    Colors.deepPurpleAccent[400] as Color,
    Colors.deepPurpleAccent[700] as Color,
  ];

  MaterialColor c = Colors.green[400] as MaterialColor;

  // 기기의 width, height set function
  static void setSize(Size setSize) {
    width = setSize.width;
    height = setSize.height;
  }

  // 값이 커침에 따라 숫자 축약 해주는 메서드.
  static String setNumberFormatter(String currentBalance) {
    try {
      // suffix(접미사) = { "", "k", "M", "B", "T", "P", "E" };

      double value = double.parse(currentBalance);
      if (value < 1000000) {
        // 1000000(백만) 보다 작을 때
        return value.toStringAsFixed(2);
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // 100000000(1억) 보다 작을 때
        double result = value / 1000000;
        return result.toStringAsFixed(2) + "M";
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // 100000000000(1000억) 보다 작을 때
        double result = value / (1000000 * 10 * 100);
        return result.toStringAsFixed(2) + "B";
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // 100000000000000(100조) 보다 작을 때
        double result = value / (1000000 * 10 * 100 * 100);
        return result.toStringAsFixed(2) + "T";
      }
    } catch (e) {
      print(e);
      return "";
    }
    print("setNumberFormatter() error...");
    return "";
  }
}
