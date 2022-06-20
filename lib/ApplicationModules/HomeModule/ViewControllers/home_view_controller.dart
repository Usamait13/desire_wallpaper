import 'package:desire_wallpaper/ApplicationModules/DrawerModule/ViewControllers/drawer_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/home_text_view.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Views/home_image_view.dart';

class HomeViewController extends StatefulWidget {
  @override
  State<HomeViewController> createState() => _HomeViewControllerState();
}

class _HomeViewControllerState extends State<HomeViewController> {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeTextView(text: "WallPapers"),
            HomeImageView(),
          ],
        ),
        backgroundColor: AppColors.black,
      ),
      drawer: DrawerViewController(),
      body: Container(
        width: Dimensions.screenWidth(context: context),
        height: Dimensions.screenHeight(context: context),
        child: Column(
          children: [

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
