import 'dart:io';

import 'package:attendance_app/firestore_services.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String imagePath;
  Color colorBlue = Colors.blue[900];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (imagePath != null)
                  ? Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                    ),
              TextButton(
                onPressed: () async {
                  if (imagePath != null) {
                    await FirestoreService.deleteImage(imagePath);
                    imagePath = '';
                    File file = await getImage();
                    imagePath = await FirestoreService.uploadImage(file);
                  } else {
                    File file = await getImage();
                    imagePath = await FirestoreService.uploadImage(file);
                  }
                },
                child: Text(
                  '+ Upload Image',
                  style: TextStyle(
                      fontSize: 16,
                      color: colorBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              (imagePath != null)
                  ? Container(
                      margin: EdgeInsets.only(top: 40),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green[800]),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> getImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    return file;
  }
}
