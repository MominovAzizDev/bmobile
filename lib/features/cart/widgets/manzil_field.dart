import '../../../core/exports.dart';

class ManzilField extends StatelessWidget {
  const ManzilField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Manzil",
          softWrap: true,
          fontWeight: FontWeight.w600,
          fontSize: 16.r,
          color: AppColors.textBlackColor,
        ),
        SizedBox(height: 8.h),
        TextField(
          maxLines: 3,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Manzilni kiriting',
            hintStyle: TextStyle(
                color: AppColors.grey60Color.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w400
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.grey30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.grey30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.textBlackColor, width: 1),
            ),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}