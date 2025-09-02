import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/models/auth_models/product_model.dart';
import '../../common/app_text.dart';

class ProductAbout extends StatelessWidget {
  final ProductModel product;

  const ProductAbout({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // API dan kelgan tavsif (safe conversion)
    String description = '';
    try {
      final descMap = product.translations.description;
      if (descMap.containsKey('uz') && descMap['uz'] != null) {
        description = descMap['uz'].toString();
      } else if (descMap.values.isNotEmpty && descMap.values.first != null) {
        description = descMap.values.first.toString();
      }
    } catch (e) {
      description = '';
    }

    // Agar tavsif bo'lmasa, default matnni ishlatish
    final displayDescription = description.isNotEmpty 
        ? description 
        : "Gazobloklar (avtoklavlangan gazobeton bloklari) zamonaviy qurilish sanoatida eng ko'p talab qilinadigan materiallardan biri hisoblanadi.";

    return SizedBox(
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
            text: displayDescription,
            fontSize: 14,
            maxLines: 10,
            textAlign: TextAlign.start,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 20.h),

          // Afzalliklari (har doim ko'rsatiladi)
          AppText(
            text: "Afzalliklari:",
            fontSize: 16,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 12.h),

          // Bullet list
          ...[
            "Yuqori issiqlik izolyatsiyasi – energiya sarfini kamaytiradi va bino ichidagi haroratni barqaror saqlaydi.",
            "Yengil vazni tufayli tashish va o'rnatish oson.",
            "Yong'inga chidamli va ekologik toza material.",
            "Mustahkam va uzoq muddatli xizmat qiladi.",
            "Ishlov berish va kesish oson.",
          ].map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.h),
                    width: 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10.w),
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

          // Qo'shimcha ma'lumot (agar kerak bo'lsa)
          if (product.technicalData.isNotEmpty) ...[
            SizedBox(height: 20.h),
            AppText(
              text: "Qo'llash sohalari:",
              fontSize: 16,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 12.h),
            AppText(
              text: "• Turar-joy va tijorat binolarini qurishda\n"
                   "• Issiqlik izolyatsiyasi sifatida\n"
                   "• Ichki va tashqi devorlarda\n"
                   "• Kichik qavatli qurilishlarda",
              fontSize: 14,
              maxLines: 10,
              color: AppColors.grey60Color,
              fontWeight: FontWeight.w600,
            ),
          ],
          
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}