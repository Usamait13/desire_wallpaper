import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../../Utils/app_colors.dart';
import '../../HomeModule/ViewModels/home_view_model.dart';
import '../../HomeModule/Views/wallpaper_item_view.dart';
import '../../Models/wallpaper_model.dart';
import '../Views/category_text_view.dart';

class CategoryWallpaperViewController extends StatefulWidget {
 final String category;

  const CategoryWallpaperViewController({super.key, required this.category});
  @override
  State<CategoryWallpaperViewController> createState() =>
      _CategoryWallpaperViewControllerState();
}

class _CategoryWallpaperViewControllerState
    extends State<CategoryWallpaperViewController> {
  String url = "";
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  List<WallpaperModel> wallpaperList = [];

  @override
  void initState() {
    super.initState();
    getWallpapers();
  }

  getWallpapers() async {
    url = "https://api.pexels.com/v1/search?query=${widget.category}&per_page=18";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: CategoryTextView(text: widget.category),
        backgroundColor: AppColors.black,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10,right: 5,left: 5),
        child: GridView.builder(
          // physics: ClampingScrollPhysics(),
          // shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.4,
            mainAxisExtent: 280,
          ),
          itemCount:  wallpaperList.length ,
          // itemCount: homeViewModel.wallpaperList.value.length,
          itemBuilder: (context, index) {
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
          },
        ),
      ),
    );
  }
}
