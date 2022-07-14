import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:wallpaper/wallpaper.dart';
import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../../Utils/dimensions.dart';
import '../../Models/wallpaper_model.dart';

class HomeViewModel extends GetxController {
  LocalDatabaseHepler localDatabaseHepler = LocalDatabaseHepler();

  // RxList<WallpaperModel> wallpaperList = <WallpaperModel>[].obs;
  // RxInt noOfImageToLoad = 6.obs;
  // RxInt noOfpageToLoad = 5.obs;
  RxString apiKEY =
      "563492ad6f91700001000001cb84e744de8f4f43ba9001c3748007f2".obs;

  savetoGallery({required String url}) async {
    var response = await get(Uri.parse(url));
    final result = await ImageGallerySaver.saveImage(
      response.bodyBytes,
    );
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
