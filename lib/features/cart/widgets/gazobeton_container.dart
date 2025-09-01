import '../../../core/exports.dart';

class GazobetonContainer extends StatelessWidget {
  const GazobetonContainer({super.key, required this.callback, required this.width, required this.height, required this.title});

  final VoidCallback callback;
  final double width, height;

  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.mainColor),
        child: Center(
          child: AppText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
