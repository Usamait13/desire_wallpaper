import 'dart:async';
import 'package:desire_wallpaper/ApplicationModules/HomeModule/ViewControllers/home_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../LocalDatabaseHelper/local_database_helper.dart';
import '../../AuthenticationModule/ViewControllers/signup_view_controller.dart';

class SplashViewController extends StatefulWidget {
  const SplashViewController({Key? key}) : super(key: key);

  @override
  State<SplashViewController> createState() => _SplashViewControllerState();
}

class _SplashViewControllerState extends State<SplashViewController> {
  LocalDatabaseHepler localDatabaseHepler = LocalDatabaseHepler();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createLocalDB();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: HomeViewController(),
          duration: Duration(milliseconds: 200),
        ),
      );
    });
  }

  void createLocalDB() async {
    if (await localDatabaseHepler.databaseExists()) {
      print("exists");
    } else {
      await localDatabaseHepler.initLocalDatabase();
      print("creating");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}
