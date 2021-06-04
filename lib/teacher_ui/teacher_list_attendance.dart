import 'package:attendance_app/auth_services.dart';
import 'package:attendance_app/teacher_ui/teacher_map.dart';
import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class ListAttendance extends StatefulWidget {
  final attendance;

  const ListAttendance({Key key, this.attendance}) : super(key: key);
  @override
  _ListAttendanceState createState() => _ListAttendanceState();
}

class _ListAttendanceState extends State<ListAttendance> {
  Color colorBlue = Colors.blue[900];
  String dateStartString;
  String dateEndString;
  int valueButton;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dateStartString = DateFormat('MMM d, yyyy | kk:mm')
        .format(widget.attendance.data()['dateStart'].toDate());
    dateEndString = DateFormat('MMM d, yyyy | kk:mm')
        .format(widget.attendance.data()['dateEnd'].toDate());
    return StreamBuilder(
      stream: AuthServices.firebaseUserStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.attendance.id,
                    style: TextStyle(
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('attendance')
                          .doc(widget.attendance.id)
                          .delete();
                      await FirebaseFirestore.instance
                          .collection('presence')
                          .where('attendance_id',
                              isEqualTo: widget.attendance.id)
                          .get()
                          .then((value) async {
                        for (int i = 0; i < value.docs.length; i++) {
                          var attendance_id = value.docs[i].id;
                          await FirebaseFirestore.instance
                              .collection('presence')
                              .doc(attendance_id)
                              .delete();
                        }
                      });
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TeacherPage();
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: colorBlue,
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              color: Colors.white,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
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
                                      widget.attendance.data()['class_name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.attendance.id,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      widget.attendance.data()['lecturer_name'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white,
                                    ),
                                    Text(
                                      dateStartString,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      dateEndString,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Student Presence',
                            style: TextStyle(
                                color: colorBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('presence')
                              .where('attendance_id',
                                  isEqualTo: widget.attendance.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Column(
                                children: snapshot.data.docs.map<Widget>((e) {
                                  return buildListTile(e, context);
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    )),
              ),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }

  Column buildListTile(e, BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.data()['student_name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                e.data()['student_id'],
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          subtitle: Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                (e.data()['status'] != 0)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SeeMap(
                                  latitude: e.data()['latitude'],
                                  longitude: e.data()['longitude'],
                                  studentName: e.data()['student_name'],
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'See GPS',
                              style: TextStyle(color: colorBlue),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: colorBlue,
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) => seeMessage(e));
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'See Message',
                              style: TextStyle(color: colorBlue),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: colorBlue,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(7.5),
            child: Container(
              width: 15,
              height: 15,
              color: (e.data()['status'] == 0)
                  ? Colors.red
                  : (e.data()['status'] == 1)
                      ? Colors.green
                      : Colors.yellow[800],
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  AlertDialog seeMessage(e) {
    return AlertDialog(
      elevation: 10,
      title: Text('Absent Message'),
      content: StatefulBuilder(builder: (context, setState) {
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Text((e.data()['message'] != null)
                ? e.data()['message']
                : 'No leave message!'));
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CLOSE',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }
}
