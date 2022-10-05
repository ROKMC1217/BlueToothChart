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
  bool isInit = false;

  ModeControlController? modeControlController;

  TextEditingController? nameController;
  TextEditingController? speciesController;
  TextEditingController? genderController;
  TextEditingController? ageController;
  TextEditingController? weightController;
  TextEditingController? filenameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    speciesController = TextEditingController();
    genderController = TextEditingController();
    ageController = TextEditingController();
    weightController = TextEditingController();
    filenameController = TextEditingController();
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
    filenameController!.dispose();
    nameController!.dispose();
    speciesController!.dispose();
    genderController!.dispose();
    ageController!.dispose();
    weightController!.dispose();
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
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
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
                  SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 3.0,
                    crossAxisSpacing: 3.0,
                    childAspectRatio: 4.5,
                    children: <Widget>[
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          filled: true,
                          // fillColor: Colors.lightBlue[50],
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.length == 0)
                            return "Please enter your name.";
                          else {
                            return null;
                          }
                        },
                        // maxLength: 30,
                        // onSaved: (value) => setState(() => username = value!),
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: speciesController,
                        decoration: InputDecoration(
                          labelText: "Species",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          filled: true,
                          // fillColor: Colors.lightBlue[50],
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.length == 0)
                            return "Please enter your Species.";
                          else {
                            return null;
                          }
                        },
                        // maxLength: 30,
                        // onSaved: (value) => setState(() => username = value!),
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: genderController,
                        decoration: InputDecoration(
                          labelText: "Gender",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          filled: true,
                          // fillColor: Colors.lightBlue[50],
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.length == 0)
                            return "Please enter your Gender.";
                          else {
                            return null;
                          }
                        },
                        // maxLength: 30,
                        // onSaved: (value) => setState(() => username = value!),
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: "Age",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          filled: true,
                          // fillColor: Colors.lightBlue[50],
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.length == 0)
                            return "Please enter your Age.";
                          else {
                            return null;
                          }
                        },
                        // maxLength: 30,
                        // onSaved: (value) => setState(() => username = value!),
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: weightController,
                        decoration: InputDecoration(
                          labelText: "Weight",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          filled: true,
                          // fillColor: Colors.lightBlue[50],
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.length == 0)
                            return "Please enter your Weight.";
                          else {
                            return null;
                          }
                        },
                        // maxLength: 30,
                        // onSaved: (value) => setState(() => username = value!),
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: filenameController,
                        decoration: InputDecoration(
                          labelText: "FileName",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          filled: true,
                          // fillColor: Colors.lightBlue[50],
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.length == 0)
                            return "Please enter your FileName.";
                          else {
                            return null;
                          }
                        },
                        // maxLength: 30,
                        // onSaved: (value) => setState(() => username = value!),
                      ),
                    ],
                  ),
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
                      EasyLoading.show(status: 'loading...');

                      Map<String, Object> result =
                          await modeControlController!.postHttp(
                        nameController!.text,
                        speciesController!.text,
                        genderController!.text,
                        ageController!.text,
                        weightController!.text,
                        filenameController!.text,
                      );
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
