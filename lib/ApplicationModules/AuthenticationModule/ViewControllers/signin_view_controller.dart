import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/ViewControllers/signup_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/user_model.dart';
import 'package:desire_wallpaper/LocalDatabaseHelper/local_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/toast.dart';
import '../../HomeModule/ViewControllers/home_view_controller.dart';
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
  late BannerAd bannerAd;
  LocalDatabaseHepler db = LocalDatabaseHepler();

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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: AuthTextView(text: "Sign In"),
            backgroundColor: AppColors.black,
          ),
          body: Container(
            // height: Dimensions.screenHeight(context: context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AddVerticalSpace(50),
                  Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(200)),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/Images/logo.png"),
                      backgroundColor: AppColors.white,
                    ),
                  ),
                  AddVerticalSpace(80),
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
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: password.text)
                              .then((value) async {
                            DocumentSnapshot doc = await FirebaseFirestore
                                .instance
                                .collection("users")
                                .doc(email.text)
                                .get();
                            db.insertUsertoLocal(
                              userModel: UserModel(
                                email: email.text,
                                name: (doc.data() as dynamic)["name"] ?? "",
                                number: (doc.data() as dynamic)["number"] ?? "",
                                imageUrl:
                                    (doc.data() as dynamic)["imageUrl"] ?? "",
                              ),
                            ).then((value) {
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
                      AuthTextView(text: "Don't have an account?"),
                      AddHorizontalSpace(5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SignUPViewController(),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 300)));
                        },
                        child: AuthTextView(
                          text: "Sign Up",
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
                  child: SpinKitRotatingCircle(
                    color: Colors.black,
                    size: 50.0,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
