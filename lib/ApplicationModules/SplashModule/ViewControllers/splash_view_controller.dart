import 'dart:async';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewControllers/home_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/SplashModule/Views/splash_text_view.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../../Utils/app_colors.dart';
import '../../AuthenticationModule/ViewControllers/signup_view_controller.dart';

class SplashViewController extends StatefulWidget {
  const SplashViewController({Key? key}) : super(key: key);

  @override
  State<SplashViewController> createState() => _SplashViewControllerState();
}

class _SplashViewControllerState extends State<SplashViewController> {
  LocalDatabaseHepler localDatabaseHepler = LocalDatabaseHepler();
  late BannerAd bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createLocalDB();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: HomeViewController(),
          duration: Duration(milliseconds: 300),
        ),
      );
    });
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

  void createLocalDB() async {
    if (await localDatabaseHepler.databaseExists()) {
      print("exists");
    } else {
      await localDatabaseHepler.initLocalDatabase();
      print("creating");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        height: Dimensions.screenHeight(context: context),
        width: Dimensions.screenWidth(context: context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(200)),
              child: CircleAvatar(
                backgroundColor: AppColors.white,
                backgroundImage: AssetImage("assets/Images/logo.png"),
              ),
            ),
            AddVerticalSpace(20),
            SplashTextView(
              text: "Desire Wallpapers",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            AddVerticalSpace(100),
            SpinKitRotatingCircle(
              color: Colors.white,
              size: 50.0,
            ),
          ],
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
