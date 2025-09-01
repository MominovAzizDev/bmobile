
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_icons.dart';
import '../../common/app_image.dart';

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key, required this.backTap, required this.uploadTap, required this.backgroundColor});

  final VoidCallback backTap;
  final VoidCallback uploadTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: 16),
      child: AppBar(
        backgroundColor: backgroundColor,
        leading: GestureDetector(
          onTap: backTap,
          child: Center(
            child: AppImage(
              imageUrl: AppIcons.backArrow,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: uploadTap,
            child: AppImage(
              imageUrl: AppIcons.upload,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
