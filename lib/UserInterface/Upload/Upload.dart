import 'package:blechart/src/controller/ModeControlController.dart';
import 'package:blechart/src/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController? fileNameController;
  bool isInit = false;

  ModeControlController? modeControlController;

  @override
  void initState() {
    super.initState();
    fileNameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = !isInit;
      modeControlController =
          Provider.of<ModeControlController>(context, listen: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    fileNameController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            "File Upload",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${modeControlController!.targetFirmwareModeName}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "시작시간 : ${modeControlController!.graph.serverUploadLists[modeControlController!.graph.targetserverUploadList!].getStartTime()}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "종료시간 : ${modeControlController!.graph.serverUploadLists[modeControlController!.graph.targetserverUploadList!].getEndTime()}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: fileNameController,
                    decoration: InputDecoration(hintText: "파일이름을 입력해주세요."),
                    onSubmitted: (String filename) {
                      print(filename);
                    },
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        // Colors.blue[100],
                        Colors.white,
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 50),
                      ),
                    ),
                    child: Text(
                      "서버로 전송",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      // http post 통신..
                      // modeControlController
                      // for (int i = 0; i < 4; i++) {
                      //   print(modeControlController!
                      //       .graph.serverUploadLists[i].list);
                      //   print(modeControlController!.graph.serverUploadLists[i]
                      //       .getStartTime());
                      //   print(modeControlController!.graph.serverUploadLists[i]
                      //       .getEndTime());
                      //   print(
                      //       "=========================================================================");
                      // }
                      EasyLoading.show(status: 'loading...');
                      Map<String, Object> result = await modeControlController!
                          .postHttp(fileNameController!.text);
                      EasyLoading.dismiss();

                      Fluttertoast.showToast(
                        msg: result["boolean"] as bool
                            ? "서버에 파일을 업로드하였습니다. status code: ${result['statusCode']}"
                            : "다시 시도해주세요. status code: ${result['statusCode']}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
