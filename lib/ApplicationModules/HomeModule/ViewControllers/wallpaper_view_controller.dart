import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wallpaper/wallpaper.dart';
import '../../../Utils/app_colors.dart';
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

  shareWallpaper() async {
    // var response = await get(Uri.parse(widget.wallpaperModel.src.portrait));
    // final result = await ImageGallerySaver.saveImage(
    //   response.bodyBytes,
    // );
    // await FlutterShare.shareFile(
    //   title: 'Example share',
    //   text: 'Example share text',
    //   filePath: result,
    // );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.wallpaperModel.src.portrait,
            child: Container(
              height: Dimensions.screenHeight(context: context),
              width: Dimensions.screenWidth(context: context),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.wallpaperModel.src.portrait,
                  placeholder: (context, url) => Center(
                        child: SpinKitRotatingCircle(
                          color: Colors.white,
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
            bottom: 30,
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
        ],
      ),
    );
  }
}
