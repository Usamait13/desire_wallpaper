import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String number;
  final String password;
  final String imageUrl;

  UserModel({
    required this.email,
    required this.name,
    required this.number,
    required this.password,
    required this.imageUrl,
  });

  factory UserModel.fromFirebase(dynamic doc) => UserModel(
    email: (doc.data() as dynamic)["cat_name"] ?? "",
    name: (doc.data() as dynamic)["name"] ?? "",
    number: (doc.data() as dynamic)["number"] ?? "",
    password: (doc.data() as dynamic)["password"] ?? "",
    imageUrl: (doc.data() as dynamic)["imageUrl"] ?? "",
  );

  factory UserModel.fromLocal(dynamic json) => UserModel(
    email: json["email"] ?? "",
    name: json["name"] ?? "",
    number: json["number"] ?? "",
    password: json["password"] ?? "",
    imageUrl: json["imageUrl"] ?? "",
  );

  static List<UserModel> localToListView(List<dynamic> snapshot) {
    return snapshot.map((e) => UserModel.fromLocal(e)).toList();
  }

  static List<UserModel> jsonToListView(List<dynamic> snapshot) {
    return snapshot.map((e) => UserModel.fromFirebase(e)).toList();
  }
}
