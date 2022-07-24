import 'package:desire_wallpaper/ApplicationModules/CategoryModule/Views/category_list_item.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../Utils/app_colors.dart';
import '../../Models/category_model.dart';
import '../ViewModels/category_view_model.dart';
import '../Views/category_text_view.dart';

class CategoryViewController extends StatefulWidget {
  const CategoryViewController({Key? key}) : super(key: key);

  @override
  State<CategoryViewController> createState() => _CategoryViewControllerState();
}

class _CategoryViewControllerState extends State<CategoryViewController> {
  CategoryViewModel categoryViewModel = Get.put(CategoryViewModel());
  late BannerAd bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryViewModel.fetchCategories();
    initBannerAds();
    initInterstitialAd();
  }

  void initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("error");
          print(error);
        },
      ),
    );
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
        // automaticallyImplyLeading: false,
        title: CategoryTextView(text: "Categories"),
        backgroundColor: AppColors.black,
      ),
      body: Container(
        height: Dimensions.screenHeight(context: context),
        width: Dimensions.screenWidth(context: context),
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
            // mainAxisExtent: 150,
          ),
          itemCount: categoryViewModel.categoryList.value.length,
          itemBuilder: (context, index) {
            return CategoryListItem(
              categoryModel: CategoryModel(
                category_name:
                    categoryViewModel.categoryList.value[index].category_name,
                category_image:
                    categoryViewModel.categoryList.value[index].category_image,
              ),
            );
          },
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
