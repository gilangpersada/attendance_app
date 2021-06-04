import 'package:attendance_app/auth_services.dart';

import 'package:attendance_app/teacher_ui/teacher_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEmailTeacher extends StatefulWidget {
  final User data;

  const EditEmailTeacher({Key key, this.data}) : super(key: key);
  @override
  _EditEmailTeacherState createState() => _EditEmailTeacherState();
}

class _EditEmailTeacherState extends State<EditEmailTeacher> {
  Color colorBlue = Colors.blue[900];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    emailController.text = widget.data.email;

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
          'Edit Email',
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        color: Colors.white,
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: buildTextField(Icons.email_rounded, 'Email',
                    'your_email@email.com', emailController, false),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 60),
                child: buildTextField(Icons.vpn_key, 'Confirm Password',
                    'yourpassword', passwordController, true),
              ),
              Container(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  onPressed: () async {
                    User firebaseUser = await AuthServices.getCredential(
                        widget.data.email, passwordController.text);
                    AuthServices.updateEmail(emailController.text,
                        passwordController.text, firebaseUser);

                    emailController.text = '';
                    passwordController.text = '';

                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TeacherPage();
                        },
                      ),
                    );
                  },
                  label: Container(
                    child: Text(
                      'Save',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextField(icon, label, hint, controllerName, obscure) {
    return TextField(
      obscureText: obscure,
      controller: controllerName,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: colorBlue,
        ),
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
}
