import 'dart:io';

import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  static Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(imageFile);

    return ref.getDownloadURL();
  }

  static Future<void> deleteImage(String fileName) async {
    var image = FirebaseStorage.instance.refFromURL(fileName);
    await image.delete();
  }
}
