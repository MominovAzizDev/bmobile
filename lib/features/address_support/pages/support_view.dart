import '../../../core/exports.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Biz bilan bog’lanish",
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackColor,
            ),
            SizedBox(height: 32.h),
            SupportContainer(
              callback: () {},
              number: "+998 (99) 150-22-22",
            ),
            SizedBox(height: 12.h),
            SupportContainer(
              callback: () {},
              number: "+998 (99) 150-22-22",
            ),
            SizedBox(height: 24),
            SupportText(title: "Email:", desc: "info@bsgroup.uz"),
            SizedBox(height: 16.h),
            SupportText(title: "Bosh ofis:", desc: "Sirdaryo viloyati, Sirdaryo tumani, Sobir Rahimov SIU,\nChibantay qo'rg'oni"),
            SocialItem(),
          ],
        ),
      ),
    );
  }
}
