import 'package:gazobeton/core/exports.dart';
class HomeColumn extends StatelessWidget {
  const HomeColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: "Mahsulotlar",
            fontSize: 20,
            color: AppColors.textBlackColor,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return HomeDetail(
                image: AppImages.blocs,
                text: "GazaBloc kley",
                callback: () {},
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 167 / 186,
            ),
          ),
          AppText(
            text: "Kalkulyator",
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 12),
          CalculatorImage(callback: () {  },),
        ],
      ),
    );
  }
}