import '../../../core/exports.dart';

class CalculatorImage extends StatelessWidget {
  const CalculatorImage({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 1],
            colors: [Colors.white, Colors.transparent],
          ).createShader(bounds),
          blendMode: BlendMode.srcATop,
          child: AppImage(
            imageUrl: AppImages.calculator,
            height: 186.h,
            width: 343.w,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned(
          top: 16.h,
          left: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Gazobloklar sonini bilasizmi?",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlackColor,
              ),
              SizedBox(height: 4),
              AppText(
                text: "Loyihangiz uchun kerakli gazoblok miqdori\nva narxini onlayn hisoblang!",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.grey60Color,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: InkWell(
            onTap:  callback,
            child: Container(
              width: 144.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "Hisoblash",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  AppImage(imageUrl: AppIcons.rightArrow),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
