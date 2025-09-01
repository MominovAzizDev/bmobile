import '../../../core/exports.dart';

class SupportText extends StatelessWidget {
  const SupportText({super.key, required this.title, required this.desc});
  final String title, desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.mainColor,
        ),
        AppText(
          text: desc,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.grey60Color,
          maxLines: 2,
        ),
      ],
    );
  }
}
