import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../common/app_text.dart';

class ItemContainer extends StatelessWidget {
  const ItemContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppText(
            text: "Gazobeton bloklari - D300, 600x50x300",
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 24.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 16.h),
            width: 343.w,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "600 000 UZS/m3",
                  fontSize: 20,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 12.h),
                AppText(
                  text: "Texnik xususiyatlari",
                  fontSize: 16,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w700,
                ),
                ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      spacing: 4.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Zichligi, marka: D300',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey60Color,
                        ),
                      ],
                    );
                  },
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
