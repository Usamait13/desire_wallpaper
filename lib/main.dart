import 'package:flutter/material.dart';
import 'ApplicationModules/SplashModule/ViewControllers/splash_view_controller.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashViewController(),
    );
  }
}
