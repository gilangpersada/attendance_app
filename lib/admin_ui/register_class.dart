import 'dart:math';

import 'package:attendance_app/admin_ui/admin_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class RegisterClass extends StatefulWidget {
  @override
  _RegisterClassState createState() => _RegisterClassState();
}

class _RegisterClassState extends State<RegisterClass> {
  Color colorBlue = Colors.blue[900];
  String valueButton;
  String major_id;
  String major_name;
  String lecturer_name;
  String lecturer_id;
  String class_id;
  final TextEditingController classNameController = TextEditingController();

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
                  return AdminPage();
                },
              ),
            );
          },
        ),
        title: Text(
          'Add Class',
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
          child: Column(
            children: [
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('major').snapshots(),
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
                            Text(
                              'Select Major',
                              style: TextStyle(color: colorBlue, fontSize: 14),
                            ),
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
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'lecturer')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    final List<DropdownMenuItem> data = [];
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      DocumentSnapshot snap = snapshot.data.docs[i];

                      String lecturer_id2 = snap.data()['user_id'];

                      lecturer_name = snap.data()['first_name'] +
                          ' ' +
                          snap.data()['last_name'];
                      data.add(
                        DropdownMenuItem(
                          child: Text(
                            snap.data()['first_name'] +
                                ' ' +
                                snap.data()['last_name'],
                            style: TextStyle(color: colorBlue),
                          ),
                          value: lecturer_id2,
                        ),
                      );
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Lecturer',
                              style: TextStyle(color: colorBlue, fontSize: 14),
                            ),
                            DropdownButton(
                              hint: Text(
                                'Select a lecturer',
                                style: TextStyle(color: colorBlue),
                              ),
                              value: lecturer_id,
                              items: data,
                              focusColor: colorBlue,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  lecturer_id = value;
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
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: buildTextField(
                  Icons.menu_book,
                  'Class name',
                  'class name',
                  classNameController,
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                onPressed: () async {
                  class_id = major_id + (100 + Random().nextInt(99)).toString();
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(lecturer_id)
                      .get()
                      .then((value) {
                    Map<String, dynamic> document = value.data();
                    lecturer_name =
                        document['first_name'] + ' ' + document['last_name'];
                  });
                  await FirebaseFirestore.instance
                      .collection('class')
                      .doc(class_id)
                      .set({
                    'class_name': classNameController.text,
                    'class_id': class_id,
                    'lecturer_name': lecturer_name,
                    'lecturer_id': lecturer_id,
                    'major_id': major_id,
                    'major_name': major_name,
                  });

                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AdminPage();
                      },
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Register'),
              ),
            ],
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
