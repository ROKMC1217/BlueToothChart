import 'dart:io';

import 'package:blechart/UserInterface/Chart/Example.dart';
import 'package:blechart/UserInterface/Home/Home.dart';
import 'package:blechart/color_schemes.g.dart';
import 'package:blechart/src/util/ProviderUtil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 베포 할 때는 아래 코드로
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    // 테스트 할 때는 아래 코드로
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    return MaterialApp(
      title: "Flutter Chart",
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      builder: EasyLoading.init(),
      home: Home(),
    );
  }
}
