import 'dart:convert';

import 'package:desire_wallpaper/ApplicationModules/DrawerModule/ViewControllers/drawer_view_controller.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewModels/home_view_model.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/category_item_view.dart';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/home_text_view.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/category_model.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/wallpaper_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';

import '../Views/home_image_view.dart';
import '../Views/wallpaper_item_view.dart';

class HomeViewController extends StatefulWidget {
  @override
  State<HomeViewController> createState() => _HomeViewControllerState();
}

class _HomeViewControllerState extends State<HomeViewController> {
  late BannerAd bannerAd;
  final HomeViewModel homeViewModel = Get.put(HomeViewModel());
  ScrollController scrollController = new ScrollController();
  List<WallpaperModel> wallpaperList = [];
  int noOfImageToLoad = 9;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAds();
    homeViewModel.fetchCategories();
    // homeViewModel.getWallpaper();
    getWallpapers();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // homeViewModel.getWallpaper();
        getWallpapers();
        noOfImageToLoad = noOfImageToLoad + 9;
        // setState(() {});
      }
    });
  }

  getWallpapers() async {
    final value = await get(
      Uri.parse(
          "https://api.pexels.com/v1/curated?page=5&per_page=${noOfImageToLoad}"),
      headers: {"Authorization": homeViewModel.apiKEY.value},
    ).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        WallpaperModel photosModel;
        photosModel = WallpaperModel.fromJson(element);
        wallpaperList.add(photosModel);
      });
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
            HomeImageView(),
          ],
        ),
        backgroundColor: AppColors.black,
      ),
      drawer: DrawerViewController(),
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
                    onTap: () {},
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
                  height: Dimensions.screenWidth(context: context)! / 3.2,
                  child: ListView.builder(
                    itemCount: homeViewModel.categoryList.value.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoryItemView(
                          categoryModel: CategoryModel(
                        // category_id:
                        // homeViewModel.categoryList.value[index].category_id,
                        category_name: homeViewModel
                            .categoryList.value[index].category_name,
                        category_image: homeViewModel
                            .categoryList.value[index].category_image,
                      ));
                    },
                  )),
              AddVerticalSpace(10),
              HomeTextView(text: "Popular", fontSize: 18),
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
