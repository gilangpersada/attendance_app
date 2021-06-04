import 'package:attendance_app/admin_ui/admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateStudent extends StatefulWidget {
  final QueryDocumentSnapshot data;

  const UpdateStudent({Key key, this.data}) : super(key: key);
  @override
  _UpdateStudentState createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  Color colorBlue = Colors.blue[900];
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.data.data()['first_name'];
    lastNameController.text = widget.data.data()['last_name'];
    emailController.text = widget.data.data()['email'];
    passwordController.text = widget.data.data()['password'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

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
          'Edit Student',
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
              FloatingActionButton.extended(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                onPressed: () {
                  firestore.collection('users').doc(widget.data.id).update({
                    'first_name': firstNameController.text,
                    'last_name': lastNameController.text,
                  });

                  firstNameController.text = '';
                  lastNameController.text = '';

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
