import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void FlutterErrorToast({required String error}){
  Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0
  );
}