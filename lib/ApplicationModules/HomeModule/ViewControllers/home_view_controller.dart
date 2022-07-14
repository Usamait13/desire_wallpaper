import 'dart:convert';

import 'package:desire_wallpaper/ApplicationModules/DrawerModule/ViewControllers/drawer_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewModels/home_view_model.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/home_category_item_view.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/home_text_view.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/category_model.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../CategoryModule/ViewControllers/category_view_controller.dart';
import '../../CategoryModule/ViewModels/category_view_model.dart';
import '../../Models/user_model.dart';
import '../Views/home_image_view.dart';
import '../Views/wallpaper_item_view.dart';

class HomeViewController extends StatefulWidget {
  @override
  State<HomeViewController> createState() => _HomeViewControllerState();
}

class _HomeViewControllerState extends State<HomeViewController> {
  late BannerAd bannerAd;
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  CategoryViewModel categoryViewModel = Get.put(CategoryViewModel());
  ScrollController scrollController = new ScrollController();
  List<WallpaperModel> wallpaperList = [];
  int noOfImageToLoad = 6;
  String url = "";

  int count = 0;
  LocalDatabaseHepler db = LocalDatabaseHepler();
  List<UserModel> currentUser = <UserModel>[];
  String name = "";
  String email = "";
  String number = "";
  String imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAds();
    categoryViewModel.fetchCategories();
    getWallpapers();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // homeViewModel.getWallpaper();
        noOfImageToLoad++;
        // homeViewModel.noOfImageToLoad.value ++;
        getWallpapers();
        // setState(() {});
      }
    });

    getCount().then((value) {
      setState(() {
        count = value;
      });
      // count = value;
      print(count);
    });
    getUser();
  }

  Future<int> getCount() async {
    return await db.checkDataExistenceByLength(table: "tbl_login");
  }

  getUser() async {
    currentUser = await db.fetchUserFromLocal();
    for (int i = 0; i < currentUser.length; i++) {
      setState(() {
        name = currentUser[i].name;
        email = currentUser[i].email;
        number = currentUser[i].number;
        imageUrl = currentUser[i].imageUrl;
      });
      // name = currentUser[i].name;
      // email = currentUser[i].email;
      // imageUrl = currentUser[i].imageUrl;
    }
  }

  getWallpapers() async {
    url =
        "https://api.pexels.com/v1/curated?page=10&per_page=${noOfImageToLoad}";
    // url = "https://api.pexels.com/v1/search?query=Ocean&per_page=${noOfImageToLoad}}";
    List<WallpaperModel> temp = [];
    await get(
      Uri.parse(url),
      headers: {"Authorization": homeViewModel.apiKEY.value},
    ).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      // wallpaperList.clear();
      jsonData["photos"].forEach((element) {
        WallpaperModel photosModel;
        photosModel = WallpaperModel.fromJson(element);
        temp.add(photosModel);
      });
      wallpaperList.addAll(temp);
      setState(() {});
    });
  }

  void initBannerAds() {
    bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        print("error");
        print(error);
      }),
      request: AdRequest(),
      size: AdSize.banner,
    );
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeTextView(text: "WallPapers"),
            HomeProfileImageView(
              userModel: UserModel(
                email: email,
                name: name,
                number: number,
                imageUrl: imageUrl,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.black,
      ),
      drawer: DrawerViewController(
        count: count,
        userModel: UserModel(
          email: email,
          name: name,
          number: number,
          imageUrl: imageUrl,
        ),
      ),
      body: Container(
        width: Dimensions.screenWidth(context: context),
        height: Dimensions.screenHeight(context: context),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddVerticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeTextView(text: "Categories", fontSize: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: CategoryViewController(),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 300)));
                    },
                    child: HomeTextView(
                      text: "See all",
                      fontSize: 16,
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
              AddVerticalSpace(10),
              Container(
                height: 80,
                child: Obx(() => ListView.builder(
                      itemCount: categoryViewModel.categoryList.value.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CategoryItemView(
                            categoryModel: CategoryModel(
                          category_name: categoryViewModel
                              .categoryList.value[index].category_name,
                          category_image: categoryViewModel
                              .categoryList.value[index].category_image,
                        ));
                      },
                    )),
              ),
              AddVerticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeTextView(text: "Popular", fontSize: 18),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse("https://www.pexels.com/"));
                        },
                        child: HomeTextView(
                          text: "Photos Provided by Pixels",
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              AddVerticalSpace(10),
              Container(
                child: GridView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.4,
                    mainAxisExtent: 280,
                  ),
                  itemCount:
                      wallpaperList == null ? 0 : wallpaperList.length + 1,
                  // itemCount: homeViewModel.wallpaperList.value.length,
                  itemBuilder: (context, index) {
                    if (index == wallpaperList.length) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          boxShadow: [
                            BoxShadow(color: AppColors.grey, blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: SpinKitRotatingCircle(
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      );
                    } else {
                      return WallpaperItemView(
                          wallpaperModel: WallpaperModel(
                        url: wallpaperList[index].url,
                        photographer: wallpaperList[index].photographer,
                        photographerUrl: wallpaperList[index].photographerUrl,
                        photographerId: wallpaperList[index].photographerId,
                        src: wallpaperList[index].src,
                        width: wallpaperList[index].width,
                        height: wallpaperList[index].height,
                        alt: wallpaperList[index].alt,
                        avgColor: wallpaperList[index].avgColor,
                        id: wallpaperList[index].id,
                        liked: wallpaperList[index].liked,
                      ));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd),
      ),
    );
  }
}
