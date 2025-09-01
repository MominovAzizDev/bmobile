import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../common/app_text.dart';

class DetailBottomNavigationBar extends StatelessWidget {
  const DetailBottomNavigationBar({super.key, required this.callback, required this.title});

  final VoidCallback callback;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: double.infinity,
        height: 96.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow:[
              BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: Offset(0, -4)
              )
            ]
        ),
        child: Center(
          child: Container(
            height: 48.h,
            width: 343.w,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: AppText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
