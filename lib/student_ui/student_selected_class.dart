import 'package:attendance_app/auth_services.dart';

import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedClass extends StatefulWidget {
  final dynamic sendedData;

  const SelectedClass({Key key, this.sendedData}) : super(key: key);

  @override
  _SelectedClassState createState() => _SelectedClassState();
}

class _SelectedClassState extends State<SelectedClass> {
  Color colorBlue = Colors.blue[900];
  String dateStartString;
  String dateEndString;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user;
    return StreamBuilder(
      stream: AuthServices.firebaseUserStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  user = snapshot.data.data();
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
                        widget.sendedData.data()['class_name'],
                        style: TextStyle(
                          color: colorBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    body: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                      color: Colors.white,
                      child: SingleChildScrollView(
                        clipBehavior: Clip.none,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  color: colorBlue,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.sendedData
                                              .data()['class_name'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.sendedData.id,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          widget.sendedData
                                              .data()['lecturer_name'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20, top: 20),
                              child: Text(
                                'My Presence',
                                style: TextStyle(
                                    color: colorBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('presence')
                                    .where('class_id',
                                        isEqualTo: widget.sendedData
                                            .data()['class_id'])
                                    .where('student_id',
                                        isEqualTo: user['user_id'])
                                    .snapshots(),
                                builder: (_, snapshot) {
                                  if (snapshot.data != null) {
                                    if (!snapshot.data.docs.isEmpty) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: snapshot.data.docs
                                              .map<Widget>(
                                                (e) => buildAttendanceCard(e),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    } else {
                                      return Text('No attendance found!');
                                    }
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              });
        } else {
          return Scaffold();
        }
      },
    );
  }

  Card buildAttendanceCard(QueryDocumentSnapshot e) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('attendance')
                  .doc(e.data()['attendance_id'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  var attendance = snapshot.data.data();
                  dateStartString = DateFormat('MMM d, yyyy | kk:mm')
                      .format(attendance['dateStart'].toDate());
                  dateEndString = DateFormat('MMM d, yyyy | kk:mm')
                      .format(attendance['dateEnd'].toDate());
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance['class_name'],
                        style: TextStyle(
                          color: colorBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        attendance['lecturer_name'],
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      Text(
                        'Start : ' + dateStartString,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        'End : ' + dateEndString,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                            (e.data()['status'] == 1)
                                ? 'Present'
                                : (e.data()['status'] == 2)
                                    ? 'Late'
                                    : 'Absent',
                            style: TextStyle(
                                color: (e.data()['status'] == 1)
                                    ? Colors.green
                                    : (e.data()['status'] == 2)
                                        ? Colors.yellow
                                        : Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
