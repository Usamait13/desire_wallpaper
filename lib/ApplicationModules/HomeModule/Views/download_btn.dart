import 'package:desire_wallpaper/ApplicationModules/HomeModule/Views/home_text_view.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Utils/dimensions.dart';

class DownloadBTN extends StatefulWidget {
  final title;
  final splashColor;
  final double? fontSize;
  final color;
  final fontWeight;
  final textColor;
  final fontFamily;
  final onPressed;
  final icon;
  final double? width;
  final double margin;

  const DownloadBTN({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.icon,
    this.splashColor,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textColor,
    this.fontFamily,
    this.width,
    this.margin = 0,
  }) : super(key: key);

  @override
  State<DownloadBTN> createState() => _DownloadBTNState();
}

class _DownloadBTNState extends State<DownloadBTN> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: EdgeInsets.all(widget.margin),
      child: MaterialButton(
        onPressed: widget.onPressed,
        color: widget.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          // padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AddHorizontalSpace(10),
                  Icon(
                    widget.icon,
                    color: AppColors.black,
                  ),
                  AddHorizontalSpace(30),
                  HomeTextView(
                    text: widget.title,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                    color: widget.textColor,
                    fontFamily: widget.fontFamily,
                  ),
                  AddHorizontalSpace(10),
                ],
              ),
            ],
          ),
        ),
        splashColor: widget.splashColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );
  }
}
