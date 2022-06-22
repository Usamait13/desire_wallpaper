import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../Models/wallpaper_model.dart';

class HomeViewModel extends GetxController {
  LocalDatabaseHepler localDatabaseHepler = LocalDatabaseHepler();
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  // RxList<WallpaperModel> wallpaperList = <WallpaperModel>[].obs;
  RxInt noOfImageToLoad = 9.obs;
  RxString apiKEY =
      "563492ad6f91700001000001cb84e744de8f4f43ba9001c3748007f2".obs;

  // getWallpaper() async {
  //   List<WallpaperModel> wallList = <WallpaperModel>[];
  //
  //   final response = await get(
  //     Uri.parse(
  //         "https://api.pexels.com/v1/curated?page=5&per_page=${noOfImageToLoad}"),
  //     headers: {"Authorization": apiKEY.value},
  //   );
  //
  //   try {
  //     if (response.statusCode == 200) {
  //       wallpaperList.value = WallpaperModel.jsonToListView(jsonDecode(response.body)["photos"]);
  //     } else {
  //       print("Something went wrong");
  //     }
  //   } catch (e) {}
  //
  //   return wallpaperList.value;
  // }

  fetchCategories() {
    Stream<QuerySnapshot<Map<String, dynamic>>> wallpaperStream =
        FirebaseFirestore.instance.collection("Category").snapshots();
    wallpaperStream.listen((event) {
      if (CategoryModel.jsonToListView(event.docs).isNotEmpty) {
        categoryList.value = CategoryModel.jsonToListView(event.docs);
      }
    });
  }

//firebase implementation
////////////////////////////
/*RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<WallpaperModel> wallpaperList = <WallpaperModel>[].obs;
  fetchCategories() async {
    List<CategoryModel> categoryList2 = <CategoryModel>[];

    if ((await localDatabaseHepler
            .checkDataExistenceByLength("tbl_category")) ==
        0) {
      categoryList2 =await  homeServices.fetchCategoriesfromFireBase();
      print("1st tiem");
    } else {
      categoryList2 = await localDatabaseHepler.fetchCategoryFromLocal();
      print("local");
      homeServices.fetchCategoriesfromFireBase().then((value) {
        if (value.isNotEmpty) {
          categoryList.value = value;
          print("update");
        }
      });
    }
    categoryList.value = categoryList2;
    return categoryList2;
  }
  fetchWallpapers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> wallpaperStream =
        FirebaseFirestore.instance.collection("Wallpapers").snapshots();
    wallpaperStream.listen((event) {
      if (WallpaperModel.jsonToListView(event.docs).isNotEmpty) {
        wallpaperList.value = WallpaperModel.jsonToListView(event.docs);
      }
    });
  }
   */
}
