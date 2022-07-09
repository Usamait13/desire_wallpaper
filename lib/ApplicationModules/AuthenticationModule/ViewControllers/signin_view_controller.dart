import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/toast.dart';
import '../Views/auth_btn.dart';
import '../Views/auth_text_input_field_view.dart';
import '../Views/auth_text_view.dart';

class SignInViewController extends StatefulWidget {
  const SignInViewController({Key? key}) : super(key: key);

  @override
  State<SignInViewController> createState() => _SignInViewControllerState();
}

class _SignInViewControllerState extends State<SignInViewController> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool emailvalidate = false;
  bool passvalidate = false;
  bool isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AuthTextView(text: "Sign In"),
        backgroundColor: AppColors.black,
      ),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AddVerticalSpace(50),
                  AuthTextInputFieldView(
                    icon: Icons.email,
                    hintText: emailvalidate ? "Enter Email" : "Email",
                    hintColor: emailvalidate ? AppColors.red : null,
                    controller: email,
                  ),
                  AddVerticalSpace(20),
                  AuthTextInputFieldView(
                    icon: Icons.lock,
                    hintText: passvalidate ? "Enter Password" : "Password",
                    hintColor: passvalidate ? AppColors.red : null,
                    controller: password,
                  ),
                  AddVerticalSpace(40),
                  AuthBTN(
                    width: Dimensions.screenWidth(context: context)! - 50,
                    title: "Continue",
                    onPressed: () {
                      if (email.text.isEmpty) {
                        setState(() {
                          emailvalidate = true;
                        });
                      } else if (password.text.isEmpty) {
                        setState(() {
                          passvalidate = true;
                        });
                      } else {
                        try {
                          setState(() {
                            isLoading = true;
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
                      }
                    },
                    color: AppColors.black,
                    textColor: AppColors.white,
                    fontSize: 18,
                  ),
                  AddVerticalSpace(20),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  height: Dimensions.screenHeight(context: context),
                  width: Dimensions.screenWidth(context: context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.black.withAlpha(200),
                        AppColors.black.withAlpha(200),
                      ],
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
