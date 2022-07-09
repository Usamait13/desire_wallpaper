import 'dart:io';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_image_view.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_text_input_field_view.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_text_view.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/user_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:desire_wallpaper/Utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../../Utils/dimensions.dart';
import '../../HomeModule/ViewControllers/home_view_controller.dart';
import '../Services/firebase_services.dart';

class SignUPViewController extends StatefulWidget {
  const SignUPViewController({Key? key}) : super(key: key);

  @override
  State<SignUPViewController> createState() => _SignUPViewControllerState();
}

class _SignUPViewControllerState extends State<SignUPViewController> {
  final name = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final password = TextEditingController();
  final ImagePicker picker = ImagePicker();

  bool namevalidate = false;
  bool emailvalidate = false;
  bool numbervalidate = false;
  bool passvalidate = false;
  bool isLoading = false;
  bool correctEmail = false;
  var encodedImage;
  String imageUrl = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  LocalDatabaseHepler db = LocalDatabaseHepler();

  late BannerAd bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAds();
  }

  void initBannerAds() {
    bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        print("error");
        print(error);
      }),
      request: AdRequest(),
      size: AdSize.banner,
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AuthTextView(text: "Sign Up"),
        backgroundColor: AppColors.black,
      ),
      body: Stack(
        children: [
          Container(
            height: Dimensions.screenHeight(context: context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AddVerticalSpace(50),
                  AuthImageView(
                    fileImage: encodedImage,
                    openCamera: () async {
                      final XFile? photo =
                          await picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        encodedImage = File(photo!.path);
                      });
                      if (photo != null) {
                        uploadUserImage(encodedImage: encodedImage)
                            .then((value) {
                          if (value != "") {
                            setState(() {
                              imageUrl = value;
                              print("imageUrl");
                              print(imageUrl);
                            });
                          }
                        });
                      } else {
                        print('No Image Path Received');
                      }
                    },
                    openGallery: () async {
                      final XFile? photo =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        encodedImage = File(photo!.path);
                      });
                      if (photo != null) {
                        uploadUserImage(encodedImage: encodedImage)
                            .then((value) {
                          if (value != "") {
                            setState(() {
                              imageUrl = value;
                              // print("imageUrl");
                              // print(imageUrl);
                            });
                          }
                        });
                      } else {
                        print('No Image Path Received');
                      }
                    },
                  ),
                  AddVerticalSpace(50),
                  AuthTextInputFieldView(
                    icon: Icons.person,
                    hintText: namevalidate ? "Enter Full Name" : "Full Name",
                    hintColor: namevalidate ? AppColors.red : null,
                    controller: name,
                  ),
                  AddVerticalSpace(20),
                  AuthTextInputFieldView(
                      icon: Icons.email,
                      hintText: emailvalidate ? "Enter Email" : "Email",
                      hintColor: emailvalidate ? AppColors.red : null,
                      controller: email,
                      onChanged: (value) {
                        setState(() {
                          correctEmail = RegExp(
                                  r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                              .hasMatch(value);
                        });
                      }),
                  AddVerticalSpace(20),
                  AuthTextInputFieldView(
                    icon: Icons.phone,
                    hintText:
                        numbervalidate ? "Enter Phone Number" : "Phone Number",
                    hintColor: numbervalidate ? AppColors.red : null,
                    controller: number,
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
                      if (name.text.isEmpty) {
                        setState(() {
                          namevalidate = true;
                        });
                      } else if (email.text.isEmpty) {
                        setState(() {
                          emailvalidate = true;
                        });
                      } else if (number.text.isEmpty) {
                        setState(() {
                          numbervalidate = true;
                        });
                      } else if (password.text.isEmpty) {
                        setState(() {
                          passvalidate = true;
                        });
                      } else if (correctEmail == false) {
                        FlutterErrorToast(
                          error: "Email Badly Formated",
                        );
                      } else {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          createUserWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          ).then((value) {
                            insertUserDatatoFirebase(
                              name: name.text.trim(),
                              email: email.text.trim(),
                              number: number.text.trim(),
                              password: password.text.trim(),
                              imageUrl: imageUrl
                            ).then((value) {
                              db
                                  .insertUsertoLocal(
                                userModel: UserModel(
                                  email: email.text.trim(),
                                  name: name.text.trim(),
                                  number: number.text.trim(),
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
                  AddVerticalSpace(30),
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
      bottomNavigationBar: Container(
        height: 80,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 20,
              left: 20,
              child: Container(
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                child: AdWidget(ad: bannerAd),
              ),
            ),
            Container(
              width: Dimensions.screenWidth(context: context),
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthTextView(text: "Already have an account?"),
                  AddHorizontalSpace(5),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: AuthTextView(
                      text: "Sign In",
                      color: AppColors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
