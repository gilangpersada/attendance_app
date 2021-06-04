import 'dart:math';
import 'package:intl/intl.dart';
import 'package:attendance_app/auth_services.dart';
import 'package:attendance_app/main.dart';
import 'package:attendance_app/teacher_ui/teacher_create_qr.dart';
import 'package:attendance_app/teacher_ui/teacher_edit_email.dart';
import 'package:attendance_app/teacher_ui/teacher_edit_password.dart';
import 'package:attendance_app/teacher_ui/teacher_edit_profile.dart';
import 'package:attendance_app/teacher_ui/teacher_list_attendance.dart';

import 'package:attendance_app/teacher_ui/teacher_selected_class.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  Color colorBlue = Colors.blue[900];
  final TextEditingController classNameController = TextEditingController();
  String dateStartString;
  String dateEndString;
  var photo;
  var photoURL;
  bool noPhoto = false;
  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);
    var user;

    if (firebaseUser == null) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              user = snapshot.data;
              if (user.data()['photo'] != null) {
                photoURL = user.data()['photo'];
              }
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    toolbarHeight: 0.0,
                    elevation: 0,
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: -5,
                          blurRadius: 30,
                          offset: Offset(0, -20),
                        ),
                      ],
                    ),
                    child: TabBar(
                      unselectedLabelColor: Colors.white54,
                      indicatorColor: Colors.transparent,
                      tabs: [
                        Tab(
                          text: "Home",
                          icon: Icon(Icons.home),
                        ),
                        Tab(
                          text: "Attendance",
                          icon: Icon(Icons.menu_book),
                        ),
                        Tab(
                          text: "Profile",
                          icon: Icon(Icons.account_circle),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      SafeArea(
                          child: LayoutBuilder(
                        builder: (context, constraints) =>
                            homeBar(context, user, firebaseUser),
                      )),
                      SafeArea(
                          child: LayoutBuilder(
                        builder: (context, constraints) =>
                            attendanceBar(context, user),
                      )),
                      SafeArea(
                          child: LayoutBuilder(
                              builder: (context, constraints) =>
                                  profileBar(context, user, firebaseUser))),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          });
    }
  }

  Container profileBar(context, user, firebaseUser) {
    if (firebaseUser != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (photoURL == null)
                                ? AssetImage('assets/img/photo.jpg')
                                : NetworkImage(user.data()['photo']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Text(
                            user.data()['first_name'] +
                                ' ' +
                                user.data()['last_name'],
                            style: TextStyle(
                                fontSize: 22,
                                color: colorBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.data()['role'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditProfileLecturer(data: user);
                        },
                      ),
                    );
                  },
                  leading: Icon(Icons.account_box, color: colorBlue),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: colorBlue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditEmailTeacher(data: firebaseUser);
                        },
                      ),
                    );
                  },
                  leading: Icon(Icons.email_rounded, color: colorBlue),
                  title: Text(
                    'Change Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: colorBlue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditPasswordTeacher(data: firebaseUser);
                        },
                      ),
                    );
                  },
                  leading: Icon(Icons.vpn_key, color: colorBlue),
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: colorBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Container attendanceBar(context, user) {
    User firebaseUser = Provider.of<User>(context);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference classes = firestore.collection('class');
    CollectionReference attendanceData = firestore.collection('attendance');

    if (user != null) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Class',
                      style: TextStyle(
                          color: colorBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 30, right: 30),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('class')
                      .where('lecturer_id', isEqualTo: user.data()['user_id'])
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.data == null) {
                      return Text('No class');
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          children: snapshot.data.docs
                              .map(
                                (e) => buildCardClass(e, classes),
                              )
                              .toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attendance',
                      style: TextStyle(
                          color: colorBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('attendance')
                        .where('lecturer_id', isEqualTo: user.data()['user_id'])
                        .orderBy('dateStart', descending: true)
                        .limit(10)
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data.docs.isEmpty) {
                          return Text('Attendance data not found!');
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: snapshot.data.docs
                                  .map(
                                    (e) =>
                                        buildAttendanceCard(e, attendanceData),
                                  )
                                  .toList(),
                            ),
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  AlertDialog alertDialog() {
    User firebaseUser = Provider.of<User>(context);
    return AlertDialog(
      elevation: 10,
      title: Text('Create new class'),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextField('Class name', 'class name', classNameController)
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CANCEL',
            style: TextStyle(color: colorBlue),
          ),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser.uid)
                .get()
                .then((value) async {
              Map<String, dynamic> data = value.data();
              String randomId =
                  Random().nextInt(100).toString() + firebaseUser.uid;
              FirebaseFirestore.instance
                  .collection('classes')
                  .doc(randomId)
                  .set({
                'class_id': randomId,
                'teacher_id': firebaseUser.uid,
                'teacher_name': data['first_name'] + ' ' + data['last_name'],
                'class_name': classNameController.text,
              });
            });

            classNameController.text = '';
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'SAVE',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }

  TextField buildTextField(label, hint, controllerName) {
    return TextField(
      controller: controllerName,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        prefixStyle: TextStyle(color: colorBlue),
        labelText: label,
        labelStyle: TextStyle(color: colorBlue),
        hintText: hint,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
      ),
    );
  }

  Container homeBar(context, user, firebaseUser) {
    if (user != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (photoURL == null)
                                  ? AssetImage('assets/img/photo.jpg')
                                  : NetworkImage(user.data()['photo']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ' + user.data()['first_name'],
                              style: TextStyle(
                                  color: colorBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.data()['role'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: colorBlue),
                    onPressed: () {
                      AuthServices.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MyApp();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              Card(
                color: colorBlue,
                margin: EdgeInsets.only(top: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 15,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Let's go make an class attendance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      buildButton(
                        MediaQuery.of(context).size.width / 2,
                        50.0,
                        Colors.grey[800],
                        'Create QR Code',
                        Colors.white,
                        10.0,
                        CreateQR(
                          firebaseUser: firebaseUser.uid,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                alignment: Alignment.centerLeft,
                child: Text(
                  'On Going Class',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('attendance')
                        .where('lecturer_id', isEqualTo: user.data()['user_id'])
                        .orderBy('dateStart', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      var dateNow = DateTime.now();

                      if (snapshot.data != null) {
                        return Column(
                          children: snapshot.data.docs.map<Widget>((e) {
                            if (dateNow
                                .isBefore(e.data()['dateEnd'].toDate())) {
                              return buildGoingClass(e);
                            } else {
                              return Container();
                            }
                          }).toList(),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Card buildGoingClass(e) {
    var progress;
    var totalProgress;

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.orange[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('presence')
                        .where('attendance_id', isEqualTo: e.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data == null) {
                          totalProgress = 0;
                        } else {
                          totalProgress = snapshot.data.docs.length;
                        }
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('presence')
                              .where('attendance_id', isEqualTo: e.id)
                              .where('status', isEqualTo: 1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              if (snapshot.data == null) {
                                progress = 0;
                              } else {
                                progress = snapshot.data.docs.length;
                              }

                              return Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      value: progress / totalProgress,
                                      strokeWidth: 6,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.6),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          colorBlue),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 50,
                                    child: Text(
                                      progress.toString() +
                                          '/' +
                                          totalProgress.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.data()['class_name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              var dataValue = e.data()['class_id'];
                              var keyCode = e.data()['attendance_id'];
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      alertDialogQR(dataValue, keyCode));
                            },
                            child: Text(
                              'See QR Code',
                              style: TextStyle(
                                color: colorBlue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: colorBlue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ListAttendance(attendance: e);
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'See attendance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildButton(width, height, splashColor, buttonText, buttonColor,
      borderRadius, routePage) {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return routePage;
                  },
                ),
              );
            },
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: colorBlue,
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

  Card buildCardClass(QueryDocumentSnapshot e, deleteData) {
    return Card(
      color: colorBlue,
      margin: EdgeInsets.only(right: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.data()['class_name'],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Text(
                    e.data()['lecturer_name'],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SelectedClass(
                                sendedData: e,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'See Class',
                        style: TextStyle(
                          color: colorBlue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildAttendanceCard(QueryDocumentSnapshot e, deleteData) {
    dateStartString = DateFormat('MMM d, yyyy | kk:mm')
        .format(e.data()['dateStart'].toDate());
    dateEndString =
        DateFormat('MMM d, yyyy | kk:mm').format(e.data()['dateEnd'].toDate());
    var progress;
    var totalProgress;

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.data()['class_name'],
                    style: TextStyle(
                      color: colorBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    e.data()['lecturer_name'],
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  Text(
                    'Start : ' + dateStartString,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    'End : ' + dateEndString,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.orange[600],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              var dataValue = e.data()['class_id'];
                              var keyCode = e.data()['attendance_id'];
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      alertDialogQR(dataValue, keyCode));
                            },
                            child: Text(
                              'See QR Code',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: colorBlue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ListAttendance(attendance: e);
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'See attendance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('presence')
                        .where('attendance_id', isEqualTo: e.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data == null) {
                          totalProgress = 0;
                        } else {
                          totalProgress = snapshot.data.docs.length;
                        }
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('presence')
                              .where('attendance_id', isEqualTo: e.id)
                              .where('status', isEqualTo: 1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              if (snapshot.data == null) {
                                progress = 0;
                              } else {
                                progress = snapshot.data.docs.length;
                              }

                              return Stack(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    child: CircularProgressIndicator(
                                      value: progress / totalProgress,
                                      strokeWidth: 6,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.6),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green[500]),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 70,
                                    height: 70,
                                    child: Text(
                                      progress.toString() +
                                          '/' +
                                          totalProgress.toString(),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog alertDialogQR(dataValue, keyCode) {
    var attendance_data;
    return AlertDialog(
      backgroundColor: colorBlue,
      elevation: 10,
      content: StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('attendance')
                      .doc(keyCode)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data.data() == null) {
                      return CircularProgressIndicator();
                    } else {
                      attendance_data = snapshot.data;
                      dateStartString = DateFormat('MMM d, yyyy | kk:mm')
                          .format(snapshot.data.data()['dateStart'].toDate());
                      dateEndString = DateFormat('MMM d, yyyy | kk:mm')
                          .format(snapshot.data.data()['dateEnd'].toDate());
                      return Column(children: [
                        Text(
                          snapshot.data.data()['class_name'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          snapshot.data.data()['lecturer_name'],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Text(
                          dateStartString,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          '-',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          dateEndString,
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
                  size: MediaQuery.of(context).size.width * 0.5,
                  version: QrVersions.auto,
                ),
              ),
              Text(
                'Key Code',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                keyCode,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var code =
                      (100000 + Random().nextInt(999999 - 100000)).toString();
                  keyCode = code;

                  await FirebaseFirestore.instance
                      .collection('attendance')
                      .doc(keyCode)
                      .set(attendance_data.data());
                  await FirebaseFirestore.instance
                      .collection('attendance')
                      .doc(attendance_data.id)
                      .delete();
                  await FirebaseFirestore.instance
                      .collection('attendance')
                      .doc(keyCode)
                      .update({'attendance_id': keyCode});
                  await FirebaseFirestore.instance
                      .collection('presence')
                      .where('attendance_id', isEqualTo: attendance_data.id)
                      .get()
                      .then((value) async {
                    for (int i = 0; i < value.docs.length; i++) {
                      var changedAttendance = value.docs[i].id;
                      await FirebaseFirestore.instance
                          .collection('presence')
                          .doc(changedAttendance)
                          .update({'attendance_id': keyCode});
                    }
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
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Change Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CLOSE',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  AlertDialog alertDialogAttendance(keyCode) {
    return AlertDialog(
      elevation: 10,
      content: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('attendance')
                  .doc(keyCode)
                  .collection('student_attendance')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map<Widget>((e) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              e.data()['student_name'],
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'See GPS',
                                    style: TextStyle(color: colorBlue),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: colorBlue,
                                ),
                              ],
                            ),
                            trailing: ClipRRect(
                              borderRadius: BorderRadius.circular(7.5),
                              child: Container(
                                width: 15,
                                height: 15,
                                color: (e.data()['status'] == 0)
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            )),
      ),
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
