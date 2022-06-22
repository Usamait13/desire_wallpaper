import 'package:desire_wallpaper/ApplicationModules/Models/category_model.dart';
import 'package:desire_wallpaper/Utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../Utils/dimensions.dart';
import 'home_text_view.dart';

class CategoryItemView extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryItemView({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    double categoryHeight = Dimensions.screenWidth(context: context)! / 3.2;
    double radius = 10;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: categoryHeight,
        height: categoryHeight,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: AppColors.black
        ),
        child: Stack(
          children: [
            SizedBox(
              width: categoryHeight,
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
              width: categoryHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  colors: [
                    AppColors.black.withAlpha(150),
                    AppColors.black.withAlpha(150),
                    // AppColors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(
              width: categoryHeight,
              height: categoryHeight,
              child: Center(
                child: HomeTextView(
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
