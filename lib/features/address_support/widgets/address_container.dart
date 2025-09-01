import '../../../core/exports.dart';

class AddressContainer extends StatelessWidget {
  const AddressContainer({
    super.key,
    required this.callback,
    required this.title,
    required this.address,
  });

  final VoidCallback callback;
  final String title, address;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: double.infinity,
        height: 85.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: AppColors.mainColor,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlackColor,
                  ),
                  AppText(
                    text: address,
                    color: AppColors.textGreyAddress,
                    maxLines: 2,
                    fontSize: 14.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            AppImage(
              imageUrl: AppIcons.chevronRight,
              width: 20.w,
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
