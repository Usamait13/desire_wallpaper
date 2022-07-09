import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_btn.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';

class AuthImageView extends StatefulWidget {
  final double? height;
  final double? width;
  final fileImage;
  final Function openCamera;
  final openGallery;

  const AuthImageView({
    Key? key,
    this.height,
    this.width,
    required this.fileImage,
    required this.openCamera,
    required this.openGallery,
  }) : super(key: key);

  @override
  State<AuthImageView> createState() => _AuthImageViewState();
}

class _AuthImageViewState extends State<AuthImageView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: 150,
            height: 150,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(200)
            ),
            child: ClipOval(
                child: widget.fileImage != null
                    ? Image.file(
                        widget.fileImage,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/Images/user.png",
                        fit: BoxFit.cover,
                      ))),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.white,
            ),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: AppColors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AuthBTN(
                            width: Dimensions.screenWidth(context: context),
                            title: "Camera",
                            color: AppColors.white,
                            margin: 5,
                            onPressed: () async {
                              var status = await Permission.camera.status;
                              if (status.isGranted) {
                                widget.openCamera();
                                Navigator.pop(context);
                              } else {
                                await Permission.camera.request();
                              }
                            },
                          ),
                          AuthBTN(
                            width: Dimensions.screenWidth(context: context),
                            title: "Gallery",
                            color: AppColors.white,
                            margin: 5,
                            onPressed: () async {
                              var status = await Permission.storage.status;

                              if (status.isGranted) {
                                widget.openGallery();
                                Navigator.pop(context);
                              } else {
                                await Permission.storage.request();
                              }
                            },
                          ),
                          AddVerticalSpace(5),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.camera_alt,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
