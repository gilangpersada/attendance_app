import 'package:attendance_app/admin_ui/register_class.dart';
import 'package:attendance_app/admin_ui/register_lecturer.dart';
import 'package:attendance_app/admin_ui/register_major.dart';
import 'package:attendance_app/admin_ui/register_student.dart';
import 'package:attendance_app/admin_update_student.dart';
import 'package:attendance_app/admin_update_teacher.dart';
import 'package:attendance_app/auth_services.dart';
import 'package:attendance_app/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Color colorBlue = Colors.blue[900];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 10),
          color: Colors.blue[900],
          child: TabBar(
            unselectedLabelColor: Colors.white54,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5),
            indicatorColor: Colors.white30,
            tabs: [
              Tab(
                text: "Home",
                icon: Icon(Icons.home),
              ),
              Tab(
                text: "Major",
                icon: Icon(Icons.menu_book),
              ),
              Tab(
                text: "Class",
                icon: Icon(Icons.people),
              ),
              Tab(
                text: "Lecturer",
                icon: Icon(Icons.menu_book),
              ),
              Tab(
                text: "Student",
                icon: Icon(Icons.people),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            homeBar(context),
            majorBar(context),
            classBar(context),
            lecturerBar(context),
            studentBar(context),
          ],
        ),
      ),
    );
  }

  Container majorBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query major = firestore.collection('major');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Major',
                style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterMajor();
                      },
                    ),
                  );
                },
                child: Text(
                  'Add Major',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: major.snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map(
                              (e) => buildMajorCard(
                                  e, UpdateStudent(data: e), major),
                            )
                            .toList(),
                      );
                    } else {
                      return Text('Data not found!');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container classBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query classes = firestore.collection('class');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Class',
                style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterClass();
                      },
                    ),
                  );
                },
                child: Text(
                  'Add Class',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: classes.snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map(
                              (e) => buildClassCard(
                                  e, UpdateStudent(data: e), classes),
                            )
                            .toList(),
                      );
                    } else {
                      return Text('Data not found!');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container studentBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User firebaseUser = Provider.of<User>(context);
    Query students =
        firestore.collection('users').where('role', isEqualTo: 'student');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student',
                style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterStudent(
                          admin: firebaseUser,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Add Student',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: students.snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map(
                              (e) => buildCard(
                                  e, UpdateStudent(data: e), students),
                            )
                            .toList(),
                      );
                    } else {
                      return Text('Data not found!');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container lecturerBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User firebaseUser = Provider.of<User>(context);
    Query lecturer =
        firestore.collection('users').where('role', isEqualTo: 'lecturer');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lecturer',
                style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterLecturer(
                          admin: firebaseUser,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Add Lecturer',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: lecturer.snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map(
                              (e) => buildCard(
                                  e, UpdateTeacher(data: e), lecturer),
                            )
                            .toList(),
                      );
                    } else {
                      return Text('Data not found!');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card buildCard(QueryDocumentSnapshot e, updateData, deleteData) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return updateData;
              },
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 5, 5, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.data()['first_name'] + ' ' + e.data()['last_name'],
                    style: TextStyle(
                      color: colorBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    e.data()['major_name'],
                    style: TextStyle(color: colorBlue, fontSize: 14),
                  ),
                  Text(
                    e.data()['user_id'],
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ],
              ),
              // TextButton(
              //   onPressed: () {
              //     deleteData.doc(e.id).delete();
              //   },
              //   child: Text(
              //     'x',
              //     style: TextStyle(
              //       color: Colors.red,
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildClassCard(QueryDocumentSnapshot e, updateData, deleteData) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return updateData;
              },
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 5, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.data()['class_name'],
                    style: TextStyle(
                        color: colorBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    e.data()['major_name'],
                    style: TextStyle(color: colorBlue, fontSize: 14),
                  ),
                  Text(
                    e.data()['lecturer_name'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  deleteData.doc(e.id).delete();
                },
                child: Text(
                  'x',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildMajorCard(QueryDocumentSnapshot e, updateData, deleteData) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return updateData;
              },
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 5, 5, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.data()['major_name'],
                    style: TextStyle(color: colorBlue, fontSize: 14),
                  ),
                  Text(
                    e.data()['major_id'],
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  deleteData.doc(e.id).delete();
                },
                child: Text(
                  'x',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container homeBar(context) {
    User firebaseUser = Provider.of<User>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      color: colorBlue,
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(firebaseUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final user = snapshot;

                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ' + user.data.data()['first_name'],
                                style: TextStyle(
                                    color: colorBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
                        return Wrapper();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          Card(
            margin: EdgeInsets.only(top: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 15,
            child: Container(
              padding: EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Student',
                        style: TextStyle(
                          color: colorBlue,
                          fontSize: 16,
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('role', isEqualTo: 'student')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            var total = snapshot.data.docs.length.toString();
                            return Text(
                              total,
                              style: TextStyle(
                                color: colorBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 1,
                    height: 40,
                    child: Container(
                      color: Colors.grey[800],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Total Lecturer',
                        style: TextStyle(
                          color: colorBlue,
                          fontSize: 16,
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('role', isEqualTo: 'lecturer')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            var total = snapshot.data.docs.length.toString();
                            return Text(
                              total,
                              style: TextStyle(
                                color: colorBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 15,
            child: Container(
              padding: EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Major',
                        style: TextStyle(
                          color: colorBlue,
                          fontSize: 16,
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('major')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            var total = snapshot.data.docs.length.toString();
                            return Text(
                              total,
                              style: TextStyle(
                                color: colorBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 1,
                    height: 40,
                    child: Container(
                      color: Colors.grey[800],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Total Class',
                        style: TextStyle(
                          color: colorBlue,
                          fontSize: 16,
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('class')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            var total = snapshot.data.docs.length.toString();
                            return Text(
                              total,
                              style: TextStyle(
                                color: colorBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
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
