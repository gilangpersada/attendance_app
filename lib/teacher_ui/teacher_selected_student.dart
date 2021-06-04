import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectedStudent extends StatefulWidget {
  final studentData;

  const SelectedStudent({Key key, this.studentData}) : super(key: key);
  @override
  _SelectedStudentState createState() => _SelectedStudentState();
}

class _SelectedStudentState extends State<SelectedStudent> {
  Color colorBlue = Colors.blue[900];
  var photoURL;
  var major_id;

  @override
  void initState() {
    if (widget.studentData.data()['photo'] != null) {
      photoURL = widget.studentData.data()['photo'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    major_id = widget.studentData.data()['major_id'];
    print(major_id);
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (photoURL == null)
                          ? AssetImage('assets/img/photo.jpg')
                          : NetworkImage(widget.studentData.data()['photo']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: colorBlue,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return TeacherPage();
                            },
                          ),
                        );
                      }),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height / 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.studentData.data()['first_name'] +
                              ' ' +
                              widget.studentData.data()['last_name'],
                          style: TextStyle(
                              color: colorBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    (widget.studentData.data()['gender'] == 'M')
                                        ? 'Male'
                                        : 'Female',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.date_range),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    widget.studentData.data()['birth'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Student Information',
                          style: TextStyle(
                              color: colorBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Student Id:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    widget.studentData.data()['user_id'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Major:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('major')
                                          .doc(major_id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return Text(
                                            snapshot.data.data()['major_name'],
                                            style: TextStyle(fontSize: 16),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
