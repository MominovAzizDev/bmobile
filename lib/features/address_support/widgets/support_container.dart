
import '../../../core/exports.dart';

class SupportContainer extends StatelessWidget {
  const SupportContainer({super.key, required this.callback, required this.number});

  final VoidCallback callback;
  final String number;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: double.infinity,
        height: 64.h,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AppImage(
                  imageUrl: AppIcons.phone,
                  width: 40.w,
                  height: 40.h,
                ),
              ),
              SizedBox(width: 16.w),
              Center(
                child: SizedBox(
                  width: 223.w,
                  child: AppText(
                    text: number,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Center(
                child: AppImage(
                  imageUrl: AppIcons.chevronRight,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
