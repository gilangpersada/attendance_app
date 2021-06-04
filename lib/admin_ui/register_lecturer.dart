import 'dart:math';

import 'package:attendance_app/admin_ui/admin_page.dart';
import 'package:attendance_app/auth_services.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterLecturer extends StatefulWidget {
  final admin;

  const RegisterLecturer({Key key, this.admin}) : super(key: key);
  @override
  _RegisterLecturerState createState() => _RegisterLecturerState();
}

class _RegisterLecturerState extends State<RegisterLecturer> {
  Color colorBlue = Colors.blue[900];
  String valueButton;
  String major_name;
  String major_id;

  DateTime selectedDate = DateTime.now();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var formattedDate = DateFormat.yMMMd().format(selectedDate);

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
                  return AdminPage();
                },
              ),
            );
          },
        ),
        title: Text(
          'Add Lecturer',
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: buildTextField(
                    Icons.account_box,
                    'First name',
                    'first name',
                    firstNameController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: buildTextField(
                    Icons.account_box,
                    'Last name',
                    'last name',
                    lastNameController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: "M",
                            activeColor: colorBlue,
                            groupValue: valueButton,
                            onChanged: hendleChange,
                          ),
                          Text(
                            "Male",
                            style: TextStyle(
                              color: colorBlue,
                            ),
                          ),
                          Radio<String>(
                            value: "F",
                            activeColor: colorBlue,
                            groupValue: valueButton,
                            onChanged: hendleChange,
                          ),
                          Text(
                            "Female",
                            style: TextStyle(
                              color: colorBlue,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: colorBlue,
                        thickness: 1.3,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text(
                              "Date of Birth -",
                              style: TextStyle(
                                color: colorBlue,
                              ),
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: colorBlue,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: colorBlue,
                        thickness: 1.3,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: buildTextField(
                    Icons.email,
                    'Email address',
                    'email@email.com',
                    emailController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: buildTextField(
                    Icons.vpn_key,
                    'Password',
                    'password',
                    passwordController,
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('major')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      final List<DropdownMenuItem> data = [];
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data.docs[i];
                        major_name = snap.data()['major_name'];
                        data.add(
                          DropdownMenuItem(
                            child: Text(
                              snap.data()['major_name'],
                              style: TextStyle(color: colorBlue),
                            ),
                            value: snap.data()['major_id'],
                          ),
                        );
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButton(
                                hint: Text(
                                  'Select a major',
                                  style: TextStyle(color: colorBlue),
                                ),
                                value: major_id,
                                items: data,
                                focusColor: colorBlue,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    major_id = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Text('Data not found!');
                    }
                  },
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  onPressed: () async {
                    var adminUser;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.admin.uid)
                        .get()
                        .then((value) {
                      adminUser = value.data();
                    });
                    var result = await AuthServices.signUp(
                        emailController.text, passwordController.text);

                    String user_id = 'L' +
                        valueButton +
                        major_id +
                        (1000 + Random().nextInt(999)).toString();

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(result.uid)
                        .set({
                      'user_id': user_id,
                      'first_name': firstNameController.text,
                      'last_name': lastNameController.text,
                      'gender': valueButton,
                      'birth': formattedDate,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'role': 'lecturer',
                      'major_id': major_id,
                      'major_name': major_name,
                    });
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return UploadImage();
                    //     },
                    //   ),
                    // );
                    await AuthServices.signOut();
                    await AuthServices.signIn(
                        adminUser['email'], adminUser['password']);
                  },
                  icon: Icon(Icons.add),
                  label: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void hendleChange(String value) {
    setState(() {
      valueButton = value;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1945, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  TextField buildTextField(icon, label, hint, controllerName) {
    return TextField(
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
