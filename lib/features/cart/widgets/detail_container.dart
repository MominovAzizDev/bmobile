import '../../../core/exports.dart';

class DetailContainer extends StatelessWidget {
  const DetailContainer({
    super.key,
    required this.name,
    required this.detail,
    required this.kvPrice,
    required this.price,
    required this.minus,
    required this.plus,
    required this.quantity,
    required this.delete,
  });

  final String name, detail, kvPrice, price;
  final VoidCallback minus, plus, delete;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 189.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            width: 80.w,
            height: 80.h,
            child: Center(
              child: AppImage(
                imageUrl: AppImages.blocsD300,
                width: 77.w,
                height: 48.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Text + Buttons
          Expanded(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + delete icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        text: name,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: AppColors.textBlackColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: delete,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: AppImage(
                            imageUrl: AppIcons.x,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Detail
                AppText(
                  text: detail,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGreyAddress,
                ),
                SizedBox(height: 4.h),
                // kvPrice
                AppText(
                  text: kvPrice,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGreyAddress,
                ),
                SizedBox(height: 8.h),
                Divider(color: AppColors.dividerColor, height: 1),
                SizedBox(height: 8.h),
                // Price
                AppText(
                  text: price,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: AppColors.mainColor,
                ),
                SizedBox(height: 8.h),
                // Counter row
                Container(
                  width: 223.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppColors.counterColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: minus,
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: AppImage(
                              imageUrl: AppIcons.minus,

                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: AppText(
                            text: "$quantity",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: plus,
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: AppImage(
                              imageUrl: AppIcons.plus,

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
