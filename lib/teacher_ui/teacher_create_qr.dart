import 'dart:math';
import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:attendance_app/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQR extends StatefulWidget {
  final String firebaseUser;

  const CreateQR({Key key, this.firebaseUser}) : super(key: key);
  @override
  _CreateQRState createState() => _CreateQRState();
}

class _CreateQRState extends State<CreateQR> {
  Color colorBlue = Colors.blue[900];
  var dataValue;
  @override
  void initState() {
    dateNow = DateTime.now();
    dateEnd = DateTime.now();
    super.initState();
  }

  String code;
  String keyCode;
  var attendance_data;
  bool hasGenerate = false;
  bool hasCreate = false;
  String dateStartString;
  String dateEndString;
  DateTime dateNow;
  DateTime dateEnd;

  @override
  Widget build(BuildContext context) {
    var user_id;
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.firebaseUser)
        .get()
        .then((value) async {
      user_id = await value.data()['user_id'];
    });

    return StreamBuilder(
        stream: AuthServices.firebaseUserStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: colorBlue,
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TeacherPage();
                        },
                      ),
                    );
                  },
                ),
                title: Text(
                  'Create Attendance',
                  style: TextStyle(
                    color: colorBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    height: double.infinity,
                    width: double.infinity,
                    child: (hasGenerate)
                        ? Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: colorBlue,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('attendance')
                                              .doc(keyCode)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null) {
                                              return CircularProgressIndicator();
                                            } else {
                                              attendance_data = snapshot.data;
                                              dateStartString = DateFormat(
                                                      'MMM d, yyyy | kk:mm')
                                                  .format(snapshot.data
                                                      .data()['dateStart']
                                                      .toDate());
                                              dateEndString = DateFormat(
                                                      'MMM d, yyyy | kk:mm')
                                                  .format(snapshot.data
                                                      .data()['dateEnd']
                                                      .toDate());
                                              return Column(children: [
                                                Text(
                                                  snapshot.data
                                                      .data()['class_name'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  snapshot.data
                                                      .data()['lecturer_name'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                Divider(
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  dateStartString,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  dateEndString,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ]);
                                            }
                                          },
                                        ),
                                      ),
                                      Center(
                                        child: QrImage(
                                          data: keyCode,
                                          padding: EdgeInsets.all(15),
                                          foregroundColor: Colors.white,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          version: QrVersions.auto,
                                        ),
                                      ),
                                      Text(
                                        'Key Code',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      Text(
                                        keyCode,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  code = (100000 +
                                          Random().nextInt(999999 - 100000))
                                      .toString();
                                  keyCode = code;

                                  await FirebaseFirestore.instance
                                      .collection('attendance')
                                      .doc(keyCode)
                                      .set(attendance_data.data());

                                  await FirebaseFirestore.instance
                                      .collection('attendance')
                                      .doc(keyCode)
                                      .update({'attendance_id': keyCode});
                                  await FirebaseFirestore.instance
                                      .collection('presence')
                                      .where('attendance_id',
                                          isEqualTo: attendance_data.id)
                                      .get()
                                      .then((value) async {
                                    for (int i = 0;
                                        i < value.docs.length;
                                        i++) {
                                      var changedAttendance = value.docs[i].id;
                                      await FirebaseFirestore.instance
                                          .collection('presence')
                                          .doc(changedAttendance)
                                          .update({'attendance_id': keyCode});
                                    }
                                    await FirebaseFirestore.instance
                                        .collection('attendance')
                                        .doc(attendance_data.id)
                                        .delete();
                                  });
                                  setState(() {
                                    keyCode = code;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        color: colorBlue,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Change Code',
                                        style: TextStyle(
                                          color: colorBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Please create an attendance for generate the QR code',
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 60),
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.green[500],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 8,
                                  onPressed: () {
                                    setState(() {
                                      hasCreate = true;
                                    });
                                  },
                                  child: Container(
                                      child: Text(
                                    'Create Attendance',
                                    style: TextStyle(fontSize: 16),
                                  )),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: (hasCreate)
                        ? Container(
                            padding: EdgeInsets.all(30),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.75,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 40,
                                      offset: Offset(0, -10))
                                ],
                                color: colorBlue,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(40))),
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsetsDirectional.only(bottom: 24),
                                  child: Text(
                                    'Create Attendance',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('class')
                                      .where('lecturer_id', isEqualTo: user_id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      final List<DropdownMenuItem> data = [];
                                      for (int i = 0;
                                          i < snapshot.data.docs.length;
                                          i++) {
                                        DocumentSnapshot snap =
                                            snapshot.data.docs[i];

                                        data.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              snap.data()['class_name'],
                                              style:
                                                  TextStyle(color: colorBlue),
                                            ),
                                            value: snap.data()['class_id'],
                                          ),
                                        );
                                      }

                                      return Card(
                                        margin: EdgeInsets.only(bottom: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        color: Colors.white,
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(25, 5, 30, 5),
                                          child: DropdownButton(
                                            hint: Text(
                                              'Select a class',
                                              style:
                                                  TextStyle(color: colorBlue),
                                            ),
                                            value: dataValue,
                                            items: data,
                                            isExpanded: true,
                                            onChanged: (value) {
                                              setState(() {
                                                dataValue = value;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('Data not found!');
                                    }
                                  },
                                ),
                                Card(
                                  margin: EdgeInsets.only(bottom: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  color: Colors.white,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Select Last Attend',
                                          style: TextStyle(
                                              color: colorBlue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          height: 200,
                                          child: CupertinoDatePicker(
                                              initialDateTime: DateTime.now(),
                                              onDateTimeChanged: (val) {
                                                setState(() {
                                                  dateEnd = val;
                                                });
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: buildButton(
                                    double.infinity,
                                    60.0,
                                    Colors.lightGreen,
                                    'Generate QR Code',
                                    Colors.green[500],
                                    15.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            );
          }
        });
  }

  SizedBox buildButton(
      width, height, splashColor, buttonText, buttonColor, borderRadius) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        child: Material(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: splashColor,
            onTap: () {
              setState(() {
                if (dataValue == null) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Please select a class!',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  code =
                      (100000 + Random().nextInt(999999 - 100000)).toString();
                  keyCode = code;

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.firebaseUser)
                      .get()
                      .then((teacherValue) async {
                    Map<String, dynamic> dataLecturer = teacherValue.data();
                    await FirebaseFirestore.instance
                        .collection('class')
                        .doc(dataValue)
                        .get()
                        .then((value) async {
                      Map<String, dynamic> dataClass = value.data();
                      await FirebaseFirestore.instance
                          .collection('attendance')
                          .doc(keyCode)
                          .set({
                        'attendance_id': keyCode,
                        'lecturer_id': dataLecturer['user_id'],
                        'lecturer_name': dataLecturer['first_name'] +
                            ' ' +
                            dataLecturer['last_name'],
                        'class_id': dataClass['class_id'],
                        'class_name': dataClass['class_name'],
                        'dateStart': dateNow,
                        'dateEnd': dateEnd
                      });
                      await FirebaseFirestore.instance
                          .collection('class')
                          .doc(dataValue)
                          .collection('joinedStudent')
                          .get()
                          .then((value) async {
                        for (int i = 0; i < value.docs.length; i++) {
                          DocumentSnapshot dataStudentId = value.docs[i];

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(dataStudentId.id)
                              .get()
                              .then((value) async {
                            Map<String, dynamic> dataStudent = value.data();
                            await FirebaseFirestore.instance
                                .collection('presence')
                                .add({
                              'student_id': dataStudent['user_id'],
                              'student_name': dataStudent['first_name'] +
                                  ' ' +
                                  dataStudent['last_name'],
                              'status': 0,
                              'attendance_id': keyCode,
                              'class_id': dataClass['class_id'],
                              'created_at': dateNow,
                            });
                          });
                        }
                      });
                    });
                  });
                }
                setState(() {
                  hasGenerate = true;
                  hasCreate = false;
                });
              });
            },
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: buttonColor,
        ),
      ),
    );
  }
}
