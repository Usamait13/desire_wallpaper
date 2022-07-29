import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewModels/home_view_model.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/download_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadBottomSheet extends StatefulWidget {
  final WallpaperModel wallpaperModel;

  const DownloadBottomSheet({
    super.key,
    required this.wallpaperModel,
  });

  @override
  State<DownloadBottomSheet> createState() => _DownloadBottomSheetState();
}

class _DownloadBottomSheetState extends State<DownloadBottomSheet> {
  String home = "Home Screen";
  String lock = "Lock Screen";
  String both = "Both Screen";
  String system = "System";
  Stream<String>? progressString;
  String res = "";
  bool downloading = false;

  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  // late RewardedAd rewardedAd;
  late InterstitialAd interstitialAd;
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
    // initRewardedAds();
    initInterstitialAd();
    initBannerAds();
  }

  void initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
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

  //
  // void initRewardedAds() {
  //   RewardedAd.load(
  //       // adUnitId: RewardedAd.testAdUnitId,
  //       adUnitId: "ca-app-pub-5726190159843152/6746282615",
  //       request: AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //           onAdLoaded: (ad) {
  //             rewardedAd = ad;
  //           },
  //           onAdFailedToLoad: (LoadAdError error) {
  //             print("error");
  //             print(error);
  //           }));
  // }

  Future<void> setHomeScreenWallpaper() async {
    String url = widget.wallpaperModel.src.original;
    bool result = false;
    File cachedimage = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManager.HOME_SCREEN;
    try {
      result = await WallpaperManager.setWallpaperFromFile(
          cachedimage.path, location);
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      if (result == true) {
        home = "Wallpaper Updated";
      }
      downloading = false;
    });
  }

  Future<void> setLockScreenWallpaper() async {
    String url = widget.wallpaperModel.src.original;
    bool result = false;
    File cachedimage = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManager.LOCK_SCREEN;
    try {
      result = await WallpaperManager.setWallpaperFromFile(
          cachedimage.path, location);
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      if (result == true) {
        lock = "Wallpaper Updated";
      }
      downloading = false;
    });
  }

  Future<void> setBothScreenWallpaper() async {
    String url = widget.wallpaperModel.src.original;
    bool result = false;
    File cachedimage = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManager.BOTH_SCREEN;
    try {
      result = await WallpaperManager.setWallpaperFromFile(
          cachedimage.path, location);
    } catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      if (result == true) {
        both = "Wallpaper Updated";
      }
      downloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Container(
            height: Dimensions.screenWidth(context: context),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 8,
                  width: 80,
                  decoration: BoxDecoration(
                      color: AppColors.grey.withAlpha(200),
                      borderRadius: BorderRadius.circular(100)),
                ),
                Column(
                  children: [
                    DownloadBTN(
                      title: home,
                      icon: Icons.wallpaper_outlined,
                      onPressed: () async {
                        if (downloading == true) {
                        } else {
                          var status = await Permission.storage.status;
                          if (status.isGranted) {
                            setState(() {
                              downloading = true;
                            });
                            // RewardedAd.load;
                            setHomeScreenWallpaper();
                          } else {
                            await Permission.storage.request();
                          }
                        }
                      },
                    ),
                    // AddVerticalSpace(5),
                    DownloadBTN(
                      title: lock,
                      icon: Icons.lock_outline,
                      onPressed: () async {
                        if (downloading == true) {
                        } else {
                          var status = await Permission.storage.status;
                          if (status.isGranted) {
                            setState(() {
                              downloading = true;
                            });
                            setLockScreenWallpaper();
                          } else {
                            await Permission.storage.request();
                          }
                        }
                      },
                    ),
                    DownloadBTN(
                      title: both,
                      icon: Icons.add_chart_outlined,
                      onPressed: () async {
                        if (downloading == true) {
                        } else {
                          var status = await Permission.storage.status;
                          if (status.isGranted) {
                            setState(() {
                              downloading = true;
                            });
                            setBothScreenWallpaper();
                          } else {
                            await Permission.storage.request();
                          }
                        }
                      },
                    ),
                    DownloadBTN(
                      title: "Save to Gallery",
                      icon: Icons.download_outlined,
                      onPressed: () async {
                        var status = await Permission.storage.status;
                        if (status.isGranted) {
                          homeViewModel.savetoGallery(
                              url: widget.wallpaperModel.src.original);
                          // Navigator.pop(context);
                          interstitialAd.show();
                        } else {
                          await Permission.storage.request();
                        }
                      },
                    ),
                    AddVerticalSpace(20),
                    Container(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        downloading
            ? Container(
                height: Dimensions.screenWidth(context: context),
                // width: Dimensions.screenWidth(context: context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
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
