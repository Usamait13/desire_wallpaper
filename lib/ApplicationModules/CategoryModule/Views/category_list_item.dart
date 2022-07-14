import 'package:desire_wallpaper/ApplicationModules/CategoryModule/Views/category_text_view.dart';
import 'package:desire_wallpaper/ApplicationModules/Models/category_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:desire_wallpaper/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../ViewControllers/category_wallpaper_view_controller.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryListItem({
    super.key,
    required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    double categoryHeight = Dimensions.screenHeight(context: context);
    double categoryWidth = Dimensions.screenWidth(context: context);
    double radius = 10;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: CategoryWallpaperViewController(category: categoryModel.category_name),
            duration: Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        width: categoryWidth,
        height: categoryHeight,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: AppColors.black),
        child: Stack(
          children: [
            SizedBox(
              width: categoryWidth,
              height: categoryHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.network(
                  categoryModel.category_image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: categoryHeight,
              width: categoryWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  colors: [
                    AppColors.black.withAlpha(100),
                    AppColors.black.withAlpha(100),
                    // AppColors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(
              width: categoryWidth,
              height: categoryHeight,
              child: Center(
                child: CategoryTextView(
                  text: categoryModel.category_name,
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
