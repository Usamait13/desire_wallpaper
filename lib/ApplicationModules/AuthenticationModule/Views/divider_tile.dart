import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_text_view.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';

class DividerTile extends StatelessWidget {
  const DividerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth(context: context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 1,
            width: Dimensions.screenWidth(context: context) / 4.5,
            color: AppColors.white,
          ),
          AddHorizontalSpace(10),
          AuthTextView(
            text: "or",
            color: AppColors.white,
          ),
          AddHorizontalSpace(10),
          Container(
            height: 1,
            width: Dimensions.screenWidth(context: context) / 4.5,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
