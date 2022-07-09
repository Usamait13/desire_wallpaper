import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/ViewControllers/signin_view_controller.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Utils/app_colors.dart';
import '../Views/auth_text_view.dart';
import '../Views/divider_tile.dart';
import '../Views/selection_tile.dart';

class SelectionViewController extends StatefulWidget {
  const SelectionViewController({Key? key}) : super(key: key);

  @override
  State<SelectionViewController> createState() =>
      _SelectionViewControllerState();
}

class _SelectionViewControllerState extends State<SelectionViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AuthTextView(text: "Sign In / Sign Up"),
        backgroundColor: AppColors.black,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectionTIle(
              title: "Sign In with Email/Password",
              imageUrl: "assets/Images/user.png",
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: SignInViewController(),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 300)));
              },
            ),
            AddVerticalSpace(10),
            DividerTile(),
            AddVerticalSpace(10),
            SelectionTIle(
              title: "Sign In with Facebook",
              imageUrl: "assets/Images/user.png",
              onTap: () {},
            ),
            AddVerticalSpace(10),
            DividerTile(),
            AddVerticalSpace(10),
            SelectionTIle(
              title: "Sign In with Google",
              imageUrl: "assets/Images/user.png",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
