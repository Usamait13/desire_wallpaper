import 'dart:io';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_image_view.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_text_input_field_view.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_text_view.dart';
import 'package:desire_wallpaper/ApplicationModules/DrawerModule/ViewControllers/drawer_view_controller.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Utils/dimensions.dart';
import '../../HomeModule/ViewControllers/home_view_controller.dart';
import '../Services/upload_user_image.dart';

class SignUPViewController extends StatefulWidget {
  const SignUPViewController({Key? key}) : super(key: key);

  @override
  State<SignUPViewController> createState() => _SignUPViewControllerState();
}

class _SignUPViewControllerState extends State<SignUPViewController> {
  final name = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final ImagePicker picker = ImagePicker();
  var encodedImage;
  String imageUrl = "";

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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddVerticalSpace(80),
              AuthImageView(
                fileImage: encodedImage,
                openCamera: () async {
                  final XFile? photo =
                      await picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    encodedImage = File(photo!.path);
                  });
                  if (photo != null) {
                    uploadUserImage(encodedImage: encodedImage).then((value) {
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
                    uploadUserImage(encodedImage: encodedImage).then((value) {
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
              ),
              AddVerticalSpace(50),
              AuthTextInputFieldView(
                icon: Icons.person,
                hintText: "Full Name",
                controller: name,
              ),
              AddVerticalSpace(20),
              AuthTextInputFieldView(
                icon: Icons.email,
                hintText: "Email",
                controller: email,
              ),
              AddVerticalSpace(20),
              AuthTextInputFieldView(
                icon: Icons.phone,
                hintText: "Phone Number",
                controller: number,
              ),
              AddVerticalSpace(40),
              AuthBTN(
                width: Dimensions.screenWidth(context: context)! - 50,
                title: "Continue",
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: HomeViewController(),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200)));
                },
                color: AppColors.black,
                textColor: AppColors.white,
                fontSize: 18,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd),
      ),
    );
  }
}
