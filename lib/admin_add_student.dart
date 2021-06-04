import 'package:attendance_app/admin_ui/admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  Color colorBlue = Colors.blue[900];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

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
          'Add Student',
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
                margin: EdgeInsets.only(bottom: 10),
                child: buildTextField(Icons.account_box, 'First name',
                    'first name', firstNameController),
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
                child: buildTextField(
                  Icons.email,
                  'Email address',
                  'email@email.com',
                  emailController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: buildTextField(
                  Icons.vpn_key,
                  'Password',
                  'password',
                  passwordController,
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                onPressed: () {
                  users.add({
                    'first_name': firstNameController.text,
                    'last_name': lastNameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                    'role': 'student',
                  });

                  firstNameController.text = '';
                  lastNameController.text = '';
                  emailController.text = '';
                  passwordController.text = '';

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
                label: Text('Add student'),
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
