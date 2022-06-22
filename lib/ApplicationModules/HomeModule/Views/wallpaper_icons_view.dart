import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:flutter/material.dart';

class WallpaperIconsView extends StatefulWidget {
  final iconImage;
  final onTap;

  const WallpaperIconsView({
    super.key,
    required this.iconImage,
    required this.onTap,
  });

  @override
  State<WallpaperIconsView> createState() => _WallpaperIconsViewState();
}

class _WallpaperIconsViewState extends State<WallpaperIconsView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      splashColor: AppColors.white,
      child: Container(
        width: 60,
        height: 60,
        child: ClipRRect(
          child: Image.asset(widget.iconImage),
        ),
      ),
    );
  }
}
