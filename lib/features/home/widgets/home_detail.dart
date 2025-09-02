import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gazobeton/core/utils/app_images.dart';

import '../../../core/utils/app_colors.dart';
import '../../common/app_image.dart';
import '../../common/app_text.dart';

class HomeDetail extends StatelessWidget {
  const HomeDetail({
    super.key, 
    required this.callback, 
    required this.image, 
    required this.text
  });
  
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image.startsWith('http') 
                        ? Image.network(
                            image,
                            width: 119.w,
                            height: 110.h,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return AppImage(
                                imageUrl: AppImages.blocs,
                                width: 119.w,
                                height: 110.h,
                                fit: BoxFit.contain,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: AppColors.mainColor,
                                ),
                              );
                            },
                          )
                        : AppImage(
                            imageUrl: image.isNotEmpty ? image : AppImages.blocs,
                            width: 119.w,
                            height: 110.h,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                flex: 1,
                child: Center(
                  child: AppText(
                    text: text.isNotEmpty ? text : "Mahsulot",
                    fontSize: 15,
                    color: AppColors.textBlackColor,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}