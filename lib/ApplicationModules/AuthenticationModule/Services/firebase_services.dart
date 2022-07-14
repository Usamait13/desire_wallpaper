import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadUserImage({required encodedImage}) async {
  try {
    final firebaseStorage = FirebaseStorage.instance
        .ref()
        .child('users')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorage.putFile(encodedImage);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadedUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadedUrl;
  } catch (e) {
    return "";
  }
}

Future<void> createUserWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<void> insertUserDatatoFirebase({
  required String name,
  required String email,
  required String number,
  required String imageUrl,
}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .set({
    "name": name,
    "email": email,
    "number": number,
    "imageUrl": imageUrl,
  });
}
