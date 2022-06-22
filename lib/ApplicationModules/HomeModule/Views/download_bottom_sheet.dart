import 'dart:io';

import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/download_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper/wallpaper.dart';

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
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  Stream<String>? progressString;
  String? res;
  bool _isDisable = true;
  bool downloading = false;

  @override
  void initState() {
    super.initState();
    dowloadImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  savetoGallery() async {
    var response = await Dio().get(widget.wallpaperModel.src.original,
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  Future<void> setHomeScreenWallpaper() async {
    home = await Wallpaper.homeScreen(
        options: RequestSizeOptions.RESIZE_EXACT,
        width: Dimensions.screenWidth(context: context),
        height: Dimensions.screenHeight(context: context));
    setState(() {
      downloading = false;
      home = home;
    });
    // Navigator.pop(context);
  }

  Future<void> setLockScreenWallpaper() async {
    lock = await Wallpaper.lockScreen(
        options: RequestSizeOptions.RESIZE_EXACT,
        width: Dimensions.screenWidth(context: context),
        height: Dimensions.screenHeight(context: context));
    setState(() {
      downloading = false;
      lock = lock;
    });
    // Navigator.pop(context);
  }

  Future<void> setBothScreenWallpaper() async {
    both = await Wallpaper.bothScreen(
        options: RequestSizeOptions.RESIZE_EXACT,
        width: Dimensions.screenWidth(context: context),
        height: Dimensions.screenHeight(context: context));
    setState(() {
      downloading = false;
      both = both;
    });
    // Navigator.pop(context);
  }

  Future<void> dowloadImage() async {
    progressString =
        Wallpaper.imageDownloadProgress(widget.wallpaperModel.src.original);
    progressString!.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      setState(() {
        downloading = false;
        _isDisable = false;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
        _isDisable = true;
      });
      print("Some Error");
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
          Column(
            children: [
              DownloadBTN(
                title: home,
                icon: Icons.wallpaper_outlined,
                indicator: downloading?Text(res!):SizedBox(),
                onPressed: () async {
                  if (downloading == true) {
                  } else {
                    var status = await Permission.storage.status;
                    if (status.isGranted) {
                      setHomeScreenWallpaper();
                    } else {
                      await Permission.storage.request();
                    }
                  }
                },
              ),
              // AddVerticalSpace(5),
              DownloadBTN(
                indicator: SizedBox(),
                title: lock,
                icon: Icons.lock_outline,
                onPressed: () async {
                  if (downloading == true) {
                  } else {
                    var status = await Permission.storage.status;
                    if (status.isGranted) {
                      setLockScreenWallpaper();
                    } else {
                      await Permission.storage.request();
                    }
                  }
                },
              ),
              DownloadBTN(
                indicator: SizedBox(),
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
                    savetoGallery();
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
