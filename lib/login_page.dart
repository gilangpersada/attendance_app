import 'package:attendance_app/admin_ui/admin_page.dart';
import 'package:attendance_app/auth_services.dart';
import 'package:attendance_app/student_ui/student_page.dart';
import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color colorBlue = Colors.blue[900];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool exist = false;
  bool email = false;
  bool password = false;

  void toggleObscure() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/img/circle_blur.png', fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/Attendance.png',
                      width: 120,
                      height: 120,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: buildTextField(
                                Icons.email,
                                'Email',
                                'youremail@email.com',
                                emailController,
                                'email'),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 60),
                            child: buildPasswordField(
                                Icons.vpn_key,
                                'Password',
                                'yourpassword',
                                obscureText,
                                passwordController,
                                'password'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: buildButton(colorBlue, 'Login', Colors.blue[700],
                          colorBlue, 15.0, emailController, passwordController),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox buildButton(splashColor, buttonText, buttonColorBegin,
      buttonColorEnd, borderRadius, emailController, passwordController) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Container(
        child: Material(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: splashColor,
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: emailController.text)
                  .get()
                  .then((value) async {
                if (!value.docs.isEmpty) {
                  email = true;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .where('password', isEqualTo: passwordController.text)
                      .get()
                      .then((value) {
                    if (!value.docs.isEmpty) {
                      password = true;
                      exist = true;
                    } else {
                      password = false;
                    }
                  });
                } else {
                  email = false;
                }
              });

              if (!email) {
                return ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Email is invalid / not found!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (!password) {
                return ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password is invalid!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (exist) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Login successfull! Please wait...'),
                    backgroundColor: Colors.green,
                  ),
                );
                await AuthServices.signIn(
                    emailController.text, passwordController.text);

                return StreamBuilder(
                    stream: AuthServices.firebaseUserStream,
                    builder: (context, snapshot) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(snapshot.data.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final user = snapshot.data.data();
                            if (user['role'] == 'admin') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AdminPage();
                                  },
                                ),
                              );
                            } else if (user['role'] == 'student') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return StudentPage();
                                  },
                                ),
                              );
                            } else if (user['role'] == 'lecturer') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return TeacherPage();
                                  },
                                ),
                              );
                            }
                          }
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
                    });
              }
            },
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
              colors: [buttonColorBegin, buttonColorEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
      ),
    );
  }

  TextFormField buildTextField(icon, label, hint, controllerName, validator) {
    return TextFormField(
      controller: controllerName,
      onChanged: (value) {},
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

  TextFormField buildPasswordField(
      icon, label, hint, obscureText, controllerName, validator) {
    return TextFormField(
      controller: controllerName,
      onChanged: (value) {},
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: colorBlue,
        ),
        suffixIcon: IconButton(
            icon: (obscureText)
                ? Icon(Icons.visibility_off, color: colorBlue)
                : Icon(Icons.visibility, color: colorBlue),
            onPressed: () {
              toggleObscure();
            }),
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
