import 'dart:convert';

import 'package:desire_wallpaper/ApplicationModules/DrawerModule/Views/drawer_btn.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewControllers/home_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/user_model.dart';
import 'package:desire_wallpaper/LocalDatabaseHelper/local_database_helper.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math';

import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';
import '../../AuthenticationModule/Services/google_signin_service.dart';
import '../../AuthenticationModule/ViewControllers/selection_view_controller.dart';
import '../Views/drawer_text_view.dart';
import '../Views/drawer_tile.dart';

class DrawerViewController extends StatefulWidget {
  const DrawerViewController({Key? key}) : super(key: key);

  @override
  State<DrawerViewController> createState() => _DrawerViewControllerState();
}

class _DrawerViewControllerState extends State<DrawerViewController> {
  LocalDatabaseHepler db = LocalDatabaseHepler();
  GoogleSignInService googleSignInService = GoogleSignInService();
  int count=0;
  List<UserModel> currentUser = <UserModel>[];
  String name = "";
  String email = "";
  String imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount().then((value) {
      setState((){
        count = value;
      });
      // count = value;
    });
    getUser();
  }

  getUser() async {
    currentUser = await db.fetchUserFromLocal();
    for (int i = 0; i < currentUser.length; i++) {
      setState((){
        name = currentUser[i].name;
        email = currentUser[i].email;
        imageUrl = currentUser[i].imageUrl;
      });
      // name = currentUser[i].name;
      // email = currentUser[i].email;
      // imageUrl = currentUser[i].imageUrl;
    }
  }

  Future<int> getCount() async {
    return await db.checkDataExistenceByLength(table: "tbl_login");
  }

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
                  child: count != 0
                      ? Container(
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
                                child: ClipOval(
                                  child: imageUrl == ""
                                      ? Image.asset(
                                          "assets/Images/user.png",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          imageUrl,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              AddVerticalSpace(10),
                              DrawerTextView(
                                text: "${name}",
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              AddVerticalSpace(5),
                              DrawerTextView(
                                text: "${email}",
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        )
                      : Container(
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
                                ),
                              ),
                              AddVerticalSpace(15),
                              DrawerBTN(
                                title: "Sign In/Sign Up",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: SelectionViewController(),
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              Duration(milliseconds: 200)));
                                },
                                color: AppColors.white,
                                width:
                                    Dimensions.screenWidth(context: context) /
                                        2.4,
                                textColor: AppColors.black,
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
              onTap: () async {
                db.deleteLoginTable();
                googleSignInService.onGoogleLogout();
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    PageTransition(
                        child: SelectionViewController(),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 200)));
              },
              icon: Icons.logout,
              title: "Log Out",
            ),
          ],
        ),
      ),
    );
  }
}
