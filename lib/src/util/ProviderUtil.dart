import 'package:blechart/src/controller/HomeController.dart';
import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => HomeController()),
  ChangeNotifierProvider(create: (_) => ModeControlController()),
];
