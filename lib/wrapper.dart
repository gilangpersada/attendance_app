import 'package:attendance_app/admin_ui/admin_page.dart';

import 'package:attendance_app/login_page.dart';
import 'package:attendance_app/student_ui/student_page.dart';
import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);

    if ((firebaseUser == null)) {
      return LoginPage();
    } else {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.data()['role'] == 'admin') {
              return AdminPage();
            } else if (snapshot.data.data()['role'] == 'student') {
              return StudentPage();
            } else if (snapshot.data.data()['role'] == 'lecturer') {
              return TeacherPage();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }
}
