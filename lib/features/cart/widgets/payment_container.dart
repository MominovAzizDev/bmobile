import '../../../core/exports.dart';

class PaymentContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isSelected;
  final double width;

  const PaymentContainer({
    super.key,
    required this.onTap,
    required this.text,
    required this.isSelected,
    this.width = 160,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: isSelected ? AppColors.mainColor : Colors.white,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.mainColor : AppColors.grey60Color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}