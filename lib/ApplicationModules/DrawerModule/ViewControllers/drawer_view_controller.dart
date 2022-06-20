import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewControllers/home_view_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';
import '../Views/drawer_text_view.dart';
import '../Views/drawer_tile.dart';

class DrawerViewController extends StatefulWidget {
  const DrawerViewController({Key? key}) : super(key: key);

  @override
  State<DrawerViewController> createState() => _DrawerViewControllerState();
}

class _DrawerViewControllerState extends State<DrawerViewController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(color: AppColors.black),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AddVerticalSpace(55),
                        Container(
                            height: 60,
                            width: 60,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Image.asset(
                              "assets/Images/user.png",
                              fit: BoxFit.cover,
                            )),
                        AddVerticalSpace(10),
                        DrawerTextView(
                          text: "Usama",
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        AddVerticalSpace(5),
                        DrawerTextView(
                          text: "usamamustafa@gamil.com",
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AddVerticalSpace(10),
            DrawerTile(
              onTap: () {},
              icon: Icons.chat_outlined,
              title: "Inbox",
            ),
            AddVerticalSpace(2),
            DrawerTile(
              onTap: () {},
              icon: Icons.featured_play_list_outlined,
              title: "Terms & Conditons",
            ),
            AddVerticalSpace(2),
            DrawerTile(
              onTap: () {},
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
            ),
            AddVerticalSpace(2),
            DrawerTile(
              onTap: () async {},
              icon: Icons.logout,
              title: "Log Out",
            ),
          ],
        ),
      ),
    );
  }
}
