import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Services/google_signin_service.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/ViewControllers/signin_view_controller.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/toast.dart';
import '../../HomeModule/ViewControllers/home_view_controller.dart';
import '../../Models/user_model.dart';
import '../Services/firebase_services.dart';
import '../Views/auth_text_view.dart';
import '../Views/divider_tile.dart';
import '../Views/selection_tile.dart';

class SelectionViewController extends StatefulWidget {
  const SelectionViewController({Key? key}) : super(key: key);

  @override
  State<SelectionViewController> createState() =>
      _SelectionViewControllerState();
}

class _SelectionViewControllerState extends State<SelectionViewController> {
  String name = "";
  String email = "";
  String imageUrl = "";
  GoogleSignInService googleSignInService = GoogleSignInService();
  LocalDatabaseHepler db = LocalDatabaseHepler();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AuthTextView(text: "Sign In / Sign Up"),
        backgroundColor: AppColors.black,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(200)),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/Images/user.png"),
              ),
            ),
            AddVerticalSpace(80),
            SelectionTIle(
              title: "Sign In with Email/Password",
              imageUrl: "assets/Images/email.png",
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: SignInViewController(),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 300)));
              },
            ),
            AddVerticalSpace(10),
            DividerTile(),
            AddVerticalSpace(10),
            SelectionTIle(
              title: "Sign In with Google",
              imageUrl: "assets/Images/google.png",
              onTap: () async {
                UserCredential userCredential =
                    await googleSignInService.onGoogleSignIn();
                // print(userCredential);
                // print(userCredential);
                setState(() {
                  imageUrl = userCredential.user!.providerData.first.photoURL!;
                  email = userCredential.user!.providerData.first.email!;
                  name = userCredential.user!.providerData.first.displayName!;
                });

                try {
                  setState(() {
                    isLoading = true;
                  });
                    insertUserDatatoFirebase(
                      name: name,
                      email: email,
                      number: "",
                      password: "",
                      imageUrl: imageUrl,
                    ).then((value) {
                      db
                          .insertUsertoLocal(
                        userModel: UserModel(
                          email: email,
                          name: name,
                          number: "",
                          imageUrl: imageUrl
                        ),
                      )
                          .then((value) {
                        print("value");
                        print(value.toString());
                        Navigator.push(
                            context,
                            PageTransition(
                                child: HomeViewController(),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 200)));
                      });
                    });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    FlutterErrorToast(
                      error: 'The password provided is too weak.',
                    );
                  } else if (e.code == 'email-already-in-use') {
                    FlutterErrorToast(
                      error:
                      "The account already exists for this email.",
                    );
                  }
                }

              },
            ),
            AddVerticalSpace(10),
            DividerTile(),
            AddVerticalSpace(10),
            SelectionTIle(
              title: "Sign In with Facebook",
              imageUrl: "assets/Images/facebook.png",
              onTap: () {},
            ),
            AddVerticalSpace(80),

          ],
        ),
      ),
    );
  }
}
