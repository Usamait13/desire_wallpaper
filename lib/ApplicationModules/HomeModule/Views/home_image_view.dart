import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';

import '../../Models/user_model.dart';
import 'home_text_view.dart';

class HomeProfileImageView extends StatefulWidget {
  final UserModel userModel;

  const HomeProfileImageView({super.key, required this.userModel});

  @override
  State<HomeProfileImageView> createState() => _HomeProfileImageViewState();
}

class _HomeProfileImageViewState extends State<HomeProfileImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 35,
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 3),
            margin: EdgeInsets.symmetric(vertical: 3.5),
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(100),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Icon(
                  size: 20,
                  Icons.currency_bitcoin,
                  color: AppColors.yellow,
                ),
                HomeTextView(
                  text: "20",
                  fontSize: 16,
                  color: AppColors.yellow,
                ),
              ],
            ),
          ),
          AddHorizontalSpace(10),
          Container(
            padding: EdgeInsets.all(3),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(200),
            ),
            child: widget.userModel.imageUrl == ""
                ? CircleAvatar(
                    backgroundImage: AssetImage("assets/Images/user.png"),
                    backgroundColor: AppColors.white,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(widget.userModel.imageUrl),
                    backgroundColor: AppColors.white,
                  ),
          ),
        ],
      ),
    );
  }
}
