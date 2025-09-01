import '../../../core/exports.dart';

class ProfileViewContainer extends StatelessWidget {
  const ProfileViewContainer({
    super.key,
    required this.title,
    this.leadSvg,
    this.leadIcon,
    required this.callback,
  });

  final String title;
  final String? leadSvg;
  final IconData? leadIcon;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 64.h,
        padding: EdgeInsets.all(11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 3),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                  child: leadSvg != null
                      ? SvgPicture.asset(
                    leadSvg!,
                    width: 18.33.w,
                    height: 16.67.h,

                  )
                      : Icon(
                    leadIcon ?? Icons.error,
                    color: AppColors.mainColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 10.w),
                AppText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 24,
              color: const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
