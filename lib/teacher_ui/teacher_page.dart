import 'package:attendance_app/auth_services.dart';
import 'package:attendance_app/teacher_ui/teacher_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TeacherHomePage(),
      ),
    );
  }
}
