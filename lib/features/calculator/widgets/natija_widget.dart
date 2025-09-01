import '../../../core/exports.dart';

class NatijaWidget extends StatelessWidget {
  const NatijaWidget({super.key, required this.dona, required this.hajm});

  final String dona, hajm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      height: 136.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: "Natija",
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.textBlackColor,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              AppText(
                text: "Kerakli gazobloklar soni:",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              AppText(
                text: dona,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              AppText(
                text: "Umumiy hajmi:",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              AppText(
                text: hajm,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}