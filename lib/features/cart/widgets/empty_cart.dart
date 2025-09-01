import '../../../core/exports.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(
          text: "Empty cart!",
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.grey60Color,
        ),
      ),
    );
  }
}