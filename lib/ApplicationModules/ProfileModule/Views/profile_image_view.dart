import 'package:cached_network_image/cached_network_image.dart';
import 'package:desire_wallpaper/ApplicationModules/AuthenticationModule/Views/auth_btn.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/spaces.dart';

class ProfileImageView extends StatefulWidget {
  final double? height;
  final double? width;
  final fileImage;
  final profileImage;
  final Function openCamera;
  final openGallery;

  const ProfileImageView({
    Key? key,
    this.height,
    this.width,
    required this.fileImage,
    required this.profileImage,
    required this.openCamera,
    required this.openGallery,
  }) : super(key: key);

  @override
  State<ProfileImageView> createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppColors.black, borderRadius: BorderRadius.circular(200)),
          child: ClipOval(
            child: widget.fileImage != null
                ? Image.file(
                    widget.fileImage,
                    fit: BoxFit.cover,
                  )
                : widget.profileImage != ""
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.profileImage,
                        placeholder: (context, url) => Center(
                              child: SpinKitRotatingCircle(
                                color: Colors.white,
                                size: 50.0,
                              ),
                            ),
                        errorWidget: (context, url, error) {
                          // print(error);
                          return Icon(
                            Icons.error,
                            color: AppColors.white,
                          );
                        })
                    : Image.asset(
                        "assets/Images/user.png",
                        fit: BoxFit.cover,
                      ),
          ),
        ),
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
