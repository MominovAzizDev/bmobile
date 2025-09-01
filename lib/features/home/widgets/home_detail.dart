import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../common/app_image.dart';
import '../../common/app_text.dart';

class HomeDetail extends StatelessWidget {
  const HomeDetail({super.key, required this.callback, required this.image, required this.text});
  final VoidCallback callback;
  final String image, text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 167.w,
        height: 186.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 10.h,
          children: [
            AppImage(
              imageUrl: image,
              width: 119.w,
              height: 110.h,
            ),
            AppText(
              text: text,
              fontSize: 15,
              color: AppColors.textBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}