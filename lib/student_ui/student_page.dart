import 'package:attendance_app/auth_services.dart';
import 'package:attendance_app/student_ui/student_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StudentHomePage(),
      ),
    );
  }
}
