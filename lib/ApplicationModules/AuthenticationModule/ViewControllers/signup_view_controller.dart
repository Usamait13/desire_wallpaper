import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_image_view.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_text_input_field_view.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/dimensions.dart';

class SignUPViewController extends StatefulWidget {
  const SignUPViewController({Key? key}) : super(key: key);

  @override
  State<SignUPViewController> createState() => _SignUPViewControllerState();
}

class _SignUPViewControllerState extends State<SignUPViewController> {
  final ImagePicker picker = ImagePicker();
  var encodedImage;
  String imageURL="";
  storeUserImage() async {
    imageURL = "";
    final firebaseStorage = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorage.putFile(encodedImage);
    TaskSnapshot taskSnapshot = await uploadTask;

    await taskSnapshot.ref.getDownloadURL().then((value) async {
      if (value != null) {
        setState(() {
          imageURL = value;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AddVerticalSpace(50),
            AuthImageView(
              fileImage: encodedImage,
              openCamera: () async {
                final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                setState(() {
                  encodedImage = File(photo!.path);
                });
                if (photo != null) {
                  storeUserImage();
                } else {
                  print('No Image Path Received');
                }
              },
              openGallery: (){

              },

            ),
            AddVerticalSpace(50),
            AuthTextInputFieldView(icon: Icons.person, hintText: "Full Name"),
            AddVerticalSpace(20),
            AuthTextInputFieldView(icon: Icons.email, hintText: "Email"),
            AddVerticalSpace(20),
            AuthTextInputFieldView(icon: Icons.phone, hintText: "Phone Number"),
            AddVerticalSpace(40),
            AuthBTN(
              width: Dimensions.screenWidth(context: context)!-50,
              title: "Continue",
              onPressed: () {},
              color: AppColors.black,
              textColor: AppColors.white,
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
