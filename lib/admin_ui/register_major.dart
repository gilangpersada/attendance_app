import 'dart:math';

import 'package:attendance_app/admin_ui/admin_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class RegisterMajor extends StatefulWidget {
  @override
  _RegisterMajorState createState() => _RegisterMajorState();
}

class _RegisterMajorState extends State<RegisterMajor> {
  Color colorBlue = Colors.blue[900];

  final TextEditingController majorNameController = TextEditingController();

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
          'Add Major',
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
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: buildTextField(
                  Icons.bookmark,
                  'Major name',
                  'major name',
                  majorNameController,
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                onPressed: () async {
                  String major_id = (100 + Random().nextInt(99)).toString();
                  await FirebaseFirestore.instance
                      .collection('major')
                      .doc(major_id)
                      .set({
                    'major_id': major_id,
                    'major_name': majorNameController.text,
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
