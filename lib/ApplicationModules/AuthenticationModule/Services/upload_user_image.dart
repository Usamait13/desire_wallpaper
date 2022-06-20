import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';



Future<String> uploadUserImage({required encodedImage}) async {
  try {
    final firebaseStorage = FirebaseStorage.instance
        .ref()
        .child('users')
        .child('${DateTime
        .now()
        .millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorage.putFile(encodedImage);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadedUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadedUrl;
  }catch(e){
    return "";
  }
}
