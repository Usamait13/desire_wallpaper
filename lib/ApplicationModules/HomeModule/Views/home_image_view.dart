import 'package:cached_network_image/cached_network_image.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import '../../ProfileModule/ViewControllers/profile_view_controller.dart';
import '../ViewModels/home_view_model.dart';

class HomeProfileImageView extends StatefulWidget {
  @override
  State<HomeProfileImageView> createState() => _HomeProfileImageViewState();
}

class _HomeProfileImageViewState extends State<HomeProfileImageView> {
  int count = 0;
  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeViewModel.getCount().then((value) {
      setState(() {
        count = value;
      });
      // count = value;
      print(count);
      homeViewModel.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 35,
      height: 35,
      child: Obx(() => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   height: 35,
              //   padding: EdgeInsets.symmetric(horizontal: 3),
              //   margin: EdgeInsets.symmetric(vertical: 3.5),
              //   decoration: BoxDecoration(
              //     color: AppColors.white.withAlpha(100),
              //     borderRadius: BorderRadius.circular(100),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(
              //         size: 20,
              //         Icons.currency_bitcoin,
              //         color: AppColors.yellow,
              //       ),
              //       HomeTextView(
              //         text: "20",
              //         fontSize: 16,
              //         color: AppColors.yellow,
              //       ),
              //     ],
              //   ),
              // ),
              // AddHorizontalSpace(10),
              GestureDetector(
                onTap: () {
                  count != 0
                      ? Navigator.push(
                          context,
                          PageTransition(
                              child: ProfileViewController(),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 300)))
                      : null;
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: homeViewModel.imageUrl.value == ""
                      ? CircleAvatar(
                          backgroundImage: AssetImage("assets/Images/user.png"),
                          backgroundColor: AppColors.white,
                        )
                      : ClipOval(
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: homeViewModel.imageUrl.value,
                              placeholder: (context, url) => Center(
                                    child: SpinKitRotatingCircle(
                                      color: Colors.black,
                                      size: 20.0,
                                    ),
                                  ),
                              errorWidget: (context, url, error) {
                                // print(error);
                                return Icon(
                                  Icons.error,
                                  color: AppColors.black,
                                );
                              }),
                        ),
                ),
              ),
            ],
          )),
    );
  }
}
