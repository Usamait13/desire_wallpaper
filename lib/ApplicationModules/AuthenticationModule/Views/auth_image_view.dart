import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_btn.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';

class AuthImageView extends StatefulWidget {
  final double? height;
  final double? width;
  final  fileImage;
  final openCamera;
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
        SizedBox(
            width: 150,
            height: 150,
            child: ClipOval(
              child: widget.fileImage!=null?Image.file(widget.fileImage):Image.network("https://images.unsplash.com/photo-1655365225179-fbc453d3bd58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60")
            )),
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
                      height: 130,
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
                                widget.openCamera;
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
                                widget.openGallery;
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
