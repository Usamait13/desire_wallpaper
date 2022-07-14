import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../Models/category_model.dart';

class CategoryViewModel extends GetxController {
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  fetchCategories() {
    Stream<QuerySnapshot<Map<String, dynamic>>> categoryStream =
    FirebaseFirestore.instance.collection("Category").snapshots();
    categoryStream.listen((event) {
      if (CategoryModel.jsonToListView(event.docs).isNotEmpty) {
        categoryList.value = CategoryModel.jsonToListView(event.docs);
      }
    });
  }
}