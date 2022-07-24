import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';
import '../../AuthenticationModule/Services/firebase_services.dart';
import '../Views/profile_btn.dart';
import '../Views/profile_image_view.dart';
import '../Views/profile_text_input_field_view.dart';
import '../Views/profile_text_view.dart';

class ProfileViewController extends StatefulWidget {
  const ProfileViewController({Key? key}) : super(key: key);

  @override
  State<ProfileViewController> createState() => _ProfileViewControllerState();
}

class _ProfileViewControllerState extends State<ProfileViewController> {
  final name = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final password = TextEditingController();
  final ImagePicker picker = ImagePicker();

  String currentEmail = "";

  bool isLoading = false;
  bool correctEmail = false;
  var encodedImage;
  String imageUrl = "";
  String profileImageUrl = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  LocalDatabaseHepler db = LocalDatabaseHepler();
  late BannerAd bannerAd;
  bool updateAble = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAds();
    getCurrentUser();
    initInterstitialAd();
  }

  Future<void> getCurrentUser() async {
    currentEmail = auth.currentUser!.email!;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentEmail)
        .get();
    setState(() {
      email.text = (doc.data() as dynamic)["email"] ?? "";
      name.text = (doc.data() as dynamic)["name"] ?? "";
      number.text = (doc.data() as dynamic)["number"] ?? "";
      profileImageUrl = (doc.data() as dynamic)["imageUrl"] ?? "";
    });
  }

  void initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("error");
          print(error);
        },
      ),
    );
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
            title: ProfileTextView(text: "Profile"),
            backgroundColor: AppColors.black,
          ),
          body: Container(
            height: Dimensions.screenHeight(context: context),
            width: Dimensions.screenWidth(context: context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddVerticalSpace(50),
                  ProfileImageView(
                    fileImage: encodedImage,
                    profileImage: profileImageUrl,
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
                  ProfileTextInputFieldView(
                    icon: Icons.person,
                    hintText: "Name",
                    controller: name,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) async {
                      DocumentSnapshot snapshot = await FirebaseFirestore
                          .instance
                          .collection("users")
                          .doc(currentEmail)
                          .get();

                      setState(() {
                        value == (snapshot.data() as dynamic)["name"]
                            ? updateAble = false
                            : updateAble = true;
                      });
                    },
                  ),
                  AddVerticalSpace(20),
                  ProfileTextInputFieldView(
                    icon: Icons.email,
                    hintText: "Email",
                    controller: email,
                    readOnly: true,
                  ),
                  AddVerticalSpace(20),
                  ProfileTextInputFieldView(
                    icon: Icons.phone,
                    hintText: "Phone Number",
                    controller: number,
                    keyboardType: TextInputType.number,
                    onChanged: (value) async {
                      DocumentSnapshot snapshot = await FirebaseFirestore
                          .instance
                          .collection("users")
                          .doc(currentEmail)
                          .get();

                      setState(() {
                        value == (snapshot.data() as dynamic)["number"]
                            ? updateAble = false
                            : updateAble = true;
                      });
                    },
                  ),
                  AddVerticalSpace(40),
                  updateAble
                      ? ProfileBTN(
                          title: "Update",
                          textColor: AppColors.white,
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(email.text)
                                .update({
                              "name": name.text,
                              "number": number.text,
                            });
                            setState(() {
                              updateAble = false;
                            });
                          },
                          width: 200,
                          color: AppColors.black,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: bannerAd.size.height.toDouble(),
            width: bannerAd.size.width.toDouble(),
            child: AdWidget(ad: bannerAd),
          ),
        ),
      ],
    );
  }
}
