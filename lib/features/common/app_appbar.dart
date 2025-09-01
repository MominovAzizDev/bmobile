import 'package:gazobeton/core/exports.dart'; // Sizning umumiy eksportlaringiz

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppbar({
    super.key,
    this.title,
    this.height = kToolbarHeight,
    this.actions,
    this.centerTitle = false,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
    this.systemOverlayStyle,
  });

  final String? title;
  final double height;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      actions: actions,
      actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
      actionsIconTheme: IconThemeData(
        color: AppColors.textBlackColor,
      ),
      leading: leading ?? _defaultBackButton(context),
      title: title != null
          ? AppText(
              text: title!,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppColors.textBlackColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      systemOverlayStyle:
          systemOverlayStyle ??
          SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: backgroundColor ?? AppColors.backgroundColor,
            statusBarIconBrightness: Brightness.dark,
          ),
    );
  }

  Widget _defaultBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: AppColors.textBlackColor,
        size: 20,
      ),
      onPressed: () => context.pop(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.h);
}
