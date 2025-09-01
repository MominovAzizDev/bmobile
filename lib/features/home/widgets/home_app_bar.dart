

import '../../../core/exports.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.callback});
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: SvgPicture.asset(
          AppIcons.logo, width: 105.w, height: 35.h,),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.notification, width: 24.w, height: 24.h,),
            onPressed: callback,
          ),
        ],
      ),
    );
  }
}