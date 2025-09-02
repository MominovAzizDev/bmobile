import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/models/auth_models/product_model.dart';
import '../../common/app_text.dart';

class ItemContainer extends StatelessWidget {
  final ProductModel product;

  const ItemContainer({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Mahsulot nomi (safe conversion)
    String productName = '';
    try {
      final nameMap = product.translations.name;
      if (nameMap.containsKey('uz') && nameMap['uz'] != null) {
        productName = nameMap['uz'].toString();
      } else if (nameMap.values.isNotEmpty && nameMap.values.first != null) {
        productName = nameMap.values.first.toString();
      }
    } catch (e) {
      productName = 'Gazobeton bloklari';
    }
    
    if (productName.isEmpty) {
      productName = 'Gazobeton bloklari';
    }

    // Narx formatlash
    final formattedPrice = "${product.price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]} ',
    )} UZS/${product.unit}";

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: productName,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            maxLines: 2,
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: formattedPrice,
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
                SizedBox(height: 8.h),
                
                // Texnik ma'lumotlarni ko'rsatish
                if (product.technicalData.isNotEmpty)
                  ...product.technicalData.map((tech) {
                    final key = tech.key['uz'] ?? tech.key.values.first;
                    final value = tech.value['uz'] ?? tech.value.values.first;
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: AppText(
                        text: '$key: $value',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey60Color,
                        maxLines: 2,
                      ),
                    );
                  }).toList()
                else
                  // Agar texnik ma'lumot bo'lmasa, default ko'rsatish
                  ...List.generate(5, (index) {
                    final defaultSpecs = [
                      'Zichligi, marka: D300',
                      'O\'lcham: 600x50x300 mm',
                      'Og\'irlik: 15-20 kg/dona',
                      'Issiqlik o\'tkazuvchanligi: 0.08-0.10',
                      'Mustahkamlik sinfi: B1.5-B2.5',
                    ];
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: AppText(
                        text: index < defaultSpecs.length 
                            ? defaultSpecs[index] 
                            : 'Zichligi, marka: D300',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey60Color,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}