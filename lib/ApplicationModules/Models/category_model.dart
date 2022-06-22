import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  // final int category_id;
  final String category_name;
  final String category_image;

  CategoryModel({
    // required this.category_id,
    required this.category_name,
    required this.category_image,
  });

  factory CategoryModel.fromFirebase(dynamic doc) => CategoryModel(
        // category_id: (doc.data() as dynamic)["cat_name"] ?? 0,
        category_name: (doc.data() as dynamic)["cat_name"] ?? "",
        category_image: (doc.data() as dynamic)["cat_img"] ?? "",
      );

  factory CategoryModel.fromLocal(dynamic json) => CategoryModel(
        // category_id: (doc.data() as dynamic)["category_name"] ?? 0,
        category_name: json["category_name"] ?? "",
        category_image: json["category_image"] ?? "",
      );

  static List<CategoryModel> localToListView(List<dynamic> snapshot) {
    return snapshot.map((e) => CategoryModel.fromLocal(e)).toList();
  }

  static List<CategoryModel> jsonToListView(List<dynamic> snapshot) {
    return snapshot.map((e) => CategoryModel.fromFirebase(e)).toList();
  }
}
