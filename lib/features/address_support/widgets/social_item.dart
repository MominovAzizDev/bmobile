import '../../../core/exports.dart';

class SocialItem extends StatelessWidget {
  const SocialItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 264.h,
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppImage(imageUrl: AppIcons.instagram, width: 24.w, height: 24.h,),
          AppImage(imageUrl: AppIcons.facebook, width: 24.w, height: 24.h,),
          AppImage(imageUrl: AppIcons.telegram, width: 24.w, height: 24.h,),
          AppImage(imageUrl: AppIcons.youtube, width: 24.w, height: 24.h,),
          AppImage(imageUrl: AppIcons.twitter, width: 24.w, height: 24.h,),
          AppImage(imageUrl: AppIcons.linkedin, width: 24.w, height: 24.h,),
        ],
      ),
    );
  }
}
