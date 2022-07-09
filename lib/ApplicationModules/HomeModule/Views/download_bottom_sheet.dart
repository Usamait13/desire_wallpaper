import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewModels/home_view_model.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/download_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  bool setting = false;

  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  Future<void> setHomeScreenWallpaper() async {
    String url = widget.wallpaperModel.src.original;
    try {
      String val =
          await AsyncWallpaper.setWallpaper(url, AsyncWallpaper.HOME_SCREEN);
      home = "${val} Successfully";
      print("result");
      print(home);
    } catch (e) {
      home = 'Failed to get wallpaper.';
      print(e.toString());
    }

    if (!mounted) return;
    setState(() {
      home = home;
      downloading = false;
    });
  }

  Future<void> setLockScreenWallpaper() async {
    String url = widget.wallpaperModel.src.original;
    try {
      String val =
          await AsyncWallpaper.setWallpaper(url, AsyncWallpaper.LOCK_SCREEN);
      lock = "${val} Successfully";
      print("result");
      print(lock);
    } catch (e) {
      lock = 'Failed to get wallpaper.';
      print(e.toString());
    }

    if (!mounted) return;
    setState(() {
      lock = lock;
      downloading = false;
    });
  }

  Future<void> setBothScreenWallpaper() async {
    String url = widget.wallpaperModel.src.original;
    try {
      String val =
          await AsyncWallpaper.setWallpaper(url, AsyncWallpaper.BOTH_SCREENS);
      both = "${val} Successfully";
      print("result");
      print(both);
    } catch (e) {
      both = 'Failed to get wallpaper.';
      print(e.toString());
    }

    if (!mounted) return;
    setState(() {
      both = both;
      downloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.screenWidth(context: context)! - 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
          setting
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    DownloadBTN(
                      title: home,
                      icon: Icons.wallpaper_outlined,
                      indicator: downloading
                          ? CircularProgressIndicator()
                          : SizedBox(),
                      onPressed: () async {
                        if (downloading == true) {
                        } else {
                          var status = await Permission.storage.status;
                          if (status.isGranted) {
                            setState(() {
                              downloading = true;
                            });
                            setHomeScreenWallpaper();
                          } else {
                            await Permission.storage.request();
                          }
                        }
                      },
                    ),
                    // AddVerticalSpace(5),
                    DownloadBTN(
                      indicator: downloading ? Text(res) : SizedBox(),
                      title: lock,
                      icon: Icons.lock_outline,
                      onPressed: () async {
                        if (downloading == true) {
                        } else {
                          var status = await Permission.storage.status;
                          if (status.isGranted) {
                            setState(() {
                              setting = true;
                            });
                            setLockScreenWallpaper();
                          } else {
                            await Permission.storage.request();
                          }
                        }
                      },
                    ),
                    DownloadBTN(
                      indicator: downloading ? Text(res) : SizedBox(),
                      title: both,
                      icon: Icons.add_chart_outlined,
                      onPressed: () async {
                        if (downloading == true) {
                        } else {
                          var status = await Permission.storage.status;
                          if (status.isGranted) {
                            setBothScreenWallpaper();
                          } else {
                            await Permission.storage.request();
                          }
                        }
                      },
                    ),
                    DownloadBTN(
                      indicator: SizedBox(),
                      title: "Save to Gallery",
                      icon: Icons.download_outlined,
                      onPressed: () async {
                        var status = await Permission.storage.status;
                        if (status.isGranted) {
                          homeViewModel.savetoGallery(
                              url: widget.wallpaperModel.src.original);
                          Navigator.pop(context);
                        } else {
                          await Permission.storage.request();
                        }
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
