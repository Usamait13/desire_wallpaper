import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../AuthenticationModule/ViewControllers/signup_view_controller.dart';

class SplashViewController extends StatefulWidget {
  const SplashViewController({Key? key}) : super(key: key);

  @override
  State<SplashViewController> createState() => _SplashViewControllerState();
}

class _SplashViewControllerState extends State<SplashViewController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: SignUPViewController(),
          duration: Duration(milliseconds: 200),
        ),
      );
    });
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
