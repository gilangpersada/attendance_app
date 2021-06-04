import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:attendance_app/teacher_ui/teacher_selected_student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ListStudent extends StatefulWidget {
  final classData;

  const ListStudent({Key key, this.classData}) : super(key: key);
  @override
  _ListStudentState createState() => _ListStudentState();
}

class _ListStudentState extends State<ListStudent> {
  Color colorBlue = Colors.blue[900];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          widget.classData.data()['class_name'],
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
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
                              widget.classData.data()['class_name'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.classData.id,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.classData.data()['lecturer_name'],
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
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Student List',
                    style: TextStyle(
                        color: colorBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.topLeft,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('class')
                          .doc(widget.classData.id)
                          .collection('joinedStudent')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Column(
                            children: snapshot.data.docs
                                .map<Widget>((e) => buildListTile(e, context))
                                .toList(),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildListTile(value, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(value.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              var value = snapshot.data;
              var photoURL;
              if (value.data()['photo'] != null) {
                photoURL = value.data()['photo'];
              }

              return ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectedStudent(
                          studentData: value,
                        );
                      },
                    ),
                  );
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (photoURL == null)
                            ? AssetImage('assets/img/photo.jpg')
                            : NetworkImage(value.data()['photo']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorBlue,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.data()['first_name'] +
                          ' ' +
                          value.data()['last_name'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorBlue),
                    ),
                    Text(
                      value.data()['user_id'],
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      (value.data()['gender'] == 'M') ? 'Male' : 'Female',
                      style: TextStyle(fontSize: 14, color: colorBlue),
                    ),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
