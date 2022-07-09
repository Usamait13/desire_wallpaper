import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_text_view.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';

class SelectionTIle extends StatelessWidget {
  final String title;
  final String imageUrl;
  final onTap;

  const SelectionTIle({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // radius: 200,
      // splashColor: AppColors.black.withAlpha(100),
      child: Container(
        width: Dimensions.screenWidth(context: context),
        // height: 60,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(200),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddHorizontalSpace(10),
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                imageUrl,
              ),
            ),
            AddHorizontalSpace(20),
            AuthTextView(
              text: title,
              fontSize: 18,
            )
          ],
        ),
      ),
    );
  }
}
