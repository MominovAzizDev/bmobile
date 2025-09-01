import 'package:gazobeton/features/profile/widgets/profile_view_container.dart';

import '../../../core/exports.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textBlackColor,
      body: Column(
        children: [
          30.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: "Profile", fontWeight: FontWeight.w500, color: Colors.white),
                IconButton(
                  onPressed: () {
                    context.push(Routes.userSettings);
                  },
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 12.w,
              children: [
                AppImage.circle(imageUrl: AppImages.logo, size: 56),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Alisher Ahmedov",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    AppText(
                      text: "+998(94)598-79-05",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          27.verticalSpace,
          Expanded(
            child: Container(
              width: 375.w,
              height: 600.h,
              padding: EdgeInsetsGeometry.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              child: Column(
                spacing: 8.h,
                children: [
                  ProfileViewContainer(
                    title: "Shaxsiy ma'lumotlar",
                    leadIcon: Icons.person,
                    callback: () => context.push(Routes.userSettings),
                  ),
                  ProfileViewContainer(
                    title: "Tilni o'zgartrish",
                    leadIcon: Icons.translate,
                    callback: () => context.push(Routes.language),
                  ),
                  ProfileViewContainer(
                    title: "Biz bilan bog'lanish",
                    leadIcon: Icons.phone,
                    callback: () => context.push(Routes.support),
                  ),
                  ProfileViewContainer(
                    title: "Manzillar",
                    leadSvg: AppIcons.marker,
                    callback: () => context.push(Routes.address),
                  ),
                  AppElevatedButton(
                    onPressed: () {},
                    leadIcon: Icons.logout_outlined,
                    radius: 14,
                    text: "Log out",
                    borderColor: Colors.transparent,
                    backgroundColor: Color(0xFFFFF1F2),
                    foregroundColor: AppColors.mainColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
