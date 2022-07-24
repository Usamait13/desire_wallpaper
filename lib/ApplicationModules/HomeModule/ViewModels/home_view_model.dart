import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../Models/user_model.dart';

class HomeViewModel extends GetxController {
  LocalDatabaseHepler localDatabaseHepler = LocalDatabaseHepler();

  // RxList<WallpaperModel> wallpaperList = <WallpaperModel>[].obs;
  // RxInt noOfImageToLoad = 6.obs;
  // RxInt noOfpageToLoad = 5.obs;
  RxString apiKEY =
      "563492ad6f91700001000001cb84e744de8f4f43ba9001c3748007f2".obs;


  // RxInt count = 0.obs;
  LocalDatabaseHepler db = LocalDatabaseHepler();
  RxList<UserModel> currentUser = <UserModel>[].obs;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString number = "".obs;
  RxString imageUrl = "".obs;


  savetoGallery({required String url}) async {
    var response = await get(Uri.parse(url));
    final result = await ImageGallerySaver.saveImage(
      response.bodyBytes,
    );
  }

  Future<int> getCount() async {
    return await db.checkDataExistenceByLength(table: "tbl_login");
  }

  getUser() async {
    List<UserModel> temp = await db.fetchUserFromLocal();
    for (int i = 0; i < temp.length; i++) {
        name.value = temp[i].name;
        email.value = temp[i].email;
        number.value = temp[i].number;
        imageUrl.value = temp[i].imageUrl;
    }
    currentUser.value=temp;
    return currentUser;
  }

}
