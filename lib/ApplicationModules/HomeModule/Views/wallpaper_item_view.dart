import 'package:cached_network_image/cached_network_image.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../ViewControllers/wallpaper_view_controller.dart';
import '../ViewModels/home_view_model.dart';

class WallpaperItemView extends StatefulWidget {
  final WallpaperModel wallpaperModel;

  const WallpaperItemView({super.key, required this.wallpaperModel});

  @override
  State<WallpaperItemView> createState() => _WallpaperItemViewState();
}

class _WallpaperItemViewState extends State<WallpaperItemView> {
  final HomeViewModel homeViewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WallpaperViewController(wallpaperModel: widget.wallpaperModel),
          ),
          // PageTransition(
          //     child: WallpaperViewController(
          //         wallpaperModel: widget.wallpaperModel),
          //     type: PageTransitionType.rightToLeft)
        );
      },
      child: Hero(
        tag: widget.wallpaperModel.src.portrait,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.black,
            boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 2)],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
