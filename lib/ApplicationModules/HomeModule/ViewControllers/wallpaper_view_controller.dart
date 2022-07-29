import 'package:cached_network_image/cached_network_image.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Utils/app_colors.dart';
import '../ViewModels/home_view_model.dart';
import '../Views/download_bottom_sheet.dart';
import '../Views/wallpaper_icons_view.dart';

class WallpaperViewController extends StatefulWidget {
  final WallpaperModel wallpaperModel;

  const WallpaperViewController({super.key, required this.wallpaperModel});

  @override
  State<WallpaperViewController> createState() =>
      _WallpaperViewControllerState();
}

class _WallpaperViewControllerState extends State<WallpaperViewController> {
  late BannerAd bannerAd;
  late RewardedAd rewardedAd;
  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  @override
  void initState() {
    super.initState();
    initBannerAds();
  }

  void initRewardedAds() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-5726190159843152/6746282615",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("error");
          print(error);
        }));
  }

  shareWallpaper() async {
    await DefaultCacheManager()
        .getSingleFile(widget.wallpaperModel.src.portrait)
        .then((value) {
      Share.shareFiles(
        [value.path],
        text: 'Great picture',
      );
    });
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
      // backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          Hero(
            tag: widget.wallpaperModel.id,
            child: Container(
              height: Dimensions.screenHeight(context: context),
              width: Dimensions.screenWidth(context: context),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.wallpaperModel.src.portrait,
                  placeholder: (context, url) => Center(
                        child: SpinKitRotatingCircle(
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                  errorWidget: (context, url, error) {
                    // print(error);
                    return Icon(
                      Icons.error,
                      color: AppColors.white,
                    );
                  }),
            ),
          ),
          Container(
            width: Dimensions.screenWidth(context: context),
            height: Dimensions.screenHeight(context: context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.transparent,
                  AppColors.black.withAlpha(180),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 10,
            left: 10,
            child: Container(
              width: Dimensions.screenWidth(context: context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WallpaperIconsView(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: AppColors.transparent,
                        builder: (BuildContext context) {
                          return DownloadBottomSheet(
                            wallpaperModel: widget.wallpaperModel,
                          );
                        },
                      );
                    },
                    iconImage: "assets/Images/download.png",
                  ),
                  WallpaperIconsView(
                    onTap: () {
                      shareWallpaper();
                    },
                    iconImage: "assets/Images/share.png",
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            left: 10,
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
