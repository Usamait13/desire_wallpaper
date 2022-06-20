import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';

import 'home_text_view.dart';

class HomeImageView extends StatefulWidget {
  const HomeImageView({Key? key}) : super(key: key);

  @override
  State<HomeImageView> createState() => _HomeImageViewState();
}

class _HomeImageViewState extends State<HomeImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 35,
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.currency_bitcoin,
            color: AppColors.yellow,
          ),
          HomeTextView(
            text: "20",
            fontSize: 16,
            color: AppColors.yellow,
          ),
          AddHorizontalSpace(10),
          CircleAvatar(
            backgroundImage: AssetImage("assets/Images/user.png"),
          ),
        ],
      ),
    );
  }
}
