import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../common/app_text.dart';

class ProductAbout extends StatelessWidget {
  const ProductAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 344.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: "Mahsulot haqida",
            fontSize: 20,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 12.h),
          AppText(
            text:
            "Gazobloklar (avtoklavlangan gazobeton bloklari) zamonaviy qurilish sanoatida eng ko‘p talab qilinadigan materiallardan biri hisoblanadi. Ular quyidagi afzalliklarga ega:",
            fontSize: 14,
            maxLines: 5,
            textAlign: TextAlign.start,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400,
          ),
          20.verticalSpace,

          /// To'g'rilangan bullet list
          ...[
            "Yuqori issiqlik izolyatsiyasi – energiya sarfini kamaytiradi va bino ichidagi haroratni barqaror saqlaydi.",
            "Yengil vazni tufayli tashish va o‘rnatish oson.",
            "Yong‘inga chidamli va ekologik toza material.",
          ].map(
                (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "●",
                    fontSize: 10,
                    color: AppColors.grey60Color,
                  ),
                  7.horizontalSpace,
                  Expanded(
                    child: AppText(
                      text: item,
                      fontSize: 14,
                      maxLines: 5,
                      softWrap: true,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey60Color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          50.verticalSpace,
        ],
      ),
    );
  }
}
