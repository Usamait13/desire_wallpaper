import 'package:desire_wallpaper/ApplicationModules/CategoryModule/ViewControllers/category_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/DrawerModule/Views/drawer_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewControllers/home_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/user_model.dart';
import 'package:desire_wallpaper/ApplicationModules/SplashModule/ViewControllers/splash_view_controller.dart';
import 'package:desire_wallpaper/LocalDatabaseHelper/local_database_helper.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';
import '../../AuthenticationModule/Services/google_signin_service.dart';
import '../../AuthenticationModule/ViewControllers/selection_view_controller.dart';
import '../Views/drawer_text_view.dart';
import '../Views/drawer_tile.dart';

class DrawerViewController extends StatefulWidget {
  final int count;
  final UserModel userModel;

  const DrawerViewController(
      {super.key, required this.count, required this.userModel});

  @override
  State<DrawerViewController> createState() => _DrawerViewControllerState();
}

class _DrawerViewControllerState extends State<DrawerViewController> {
  LocalDatabaseHepler db = LocalDatabaseHepler();
  GoogleSignInService googleSignInService = GoogleSignInService();
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
    return Drawer(
      elevation: 10,
      child: Stack(
        children: [
          Container(
            color: AppColors.white,
            height: Dimensions.screenHeight(context: context),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(color: AppColors.black),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: widget.count != 0
                          ? Container(
                              height: 200,
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AddVerticalSpace(55),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: ClipOval(
                                      child: widget.userModel.imageUrl == ""
                                          ? Image.asset(
                                              "assets/Images/user.png",
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              widget.userModel.imageUrl,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  AddVerticalSpace(10),
                                  DrawerTextView(
                                    text: "${widget.userModel.name}",
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  AddVerticalSpace(5),
                                  DrawerTextView(
                                    text: "${widget.userModel.email}",
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 200,
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AddVerticalSpace(55),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: Image.asset(
                                      "assets/Images/user.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AddVerticalSpace(15),
                                  DrawerBTN(
                                    title: "Sign In/Sign Up",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: SelectionViewController(),
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration:
                                                  Duration(milliseconds: 200)));
                                    },
                                    color: AppColors.white,
                                    width: Dimensions.screenWidth(
                                            context: context) /
                                        2.4,
                                    textColor: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                AddVerticalSpace(10),
                DrawerTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: CategoryViewController(),
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                  },
                  icon: Icons.category_outlined,
                  title: "Categories",
                ),
                AddVerticalSpace(2),
                DrawerTile(
                  onTap: () {},
                  icon: Icons.featured_play_list_outlined,
                  title: "Terms & Conditons",
                ),
                AddVerticalSpace(2),
                DrawerTile(
                  onTap: () {},
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                ),
                AddVerticalSpace(2),
                widget.count != 0?DrawerTile(
                  onTap: () async {
                    db.deleteLoginTable();
                    googleSignInService.onGoogleLogout();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomeViewController(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 300)));
                  },
                  icon: Icons.logout,
                  title: "Log Out",
                ):SizedBox(),
                // Container(
                //   height: bannerAd.size.height.toDouble(),
                //   width: bannerAd.size.width.toDouble(),
                //   child: AdWidget(ad: bannerAd),
                // ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            ),
          ),
        ],
      ),
    );
  }
}
