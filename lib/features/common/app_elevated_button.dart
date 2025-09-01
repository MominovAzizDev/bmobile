import '../../core/exports.dart';

// class AppElevatedButton extends StatelessWidget {
//   const AppElevatedButton({
//     super.key,
//     required this.callback,
//     required this.text,
//     this.icon,
//     this.backgroundColor = AppColors.mainColor,
//     this.foregroundColor = Colors.white,
//     this.width = 343,
//     this.height = 48,
//     this.radius = 14,
//   });
//
//   final VoidCallback callback;
//   final String text;
//   final IconData? icon;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final double width, height, radius;
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: callback,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor,
//         foregroundColor: foregroundColor,
//         alignment: Alignment.center,
//         minimumSize: Size(width.w, height.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(radius.r),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           AppText(
//             text: text,
//             size: 16,
//             weight: FontWeight.w600,
//             color: foregroundColor,
//           ),
//           if (icon != null) ...[
//             const SizedBox(width: 8),
//             Icon(icon, color: foregroundColor),
//           ],
//         ],
//       ),
//     );
//   }
// }

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.onPressed,
    this.text,
    this.child,
    this.icon,
    this.leadIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.radius,
    this.spacing = 8,
    this.borderColor,
    this.borderWidth = 1,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
  });

  final VoidCallback onPressed;

  /// Text ko‘rsatish uchun (child berilmasa ishlatiladi)
  final String? text;

  /// Custom widget (text o‘rniga)
  final Widget? child;

  /// Tugma oxirida chiqadigan icon (optional)
  final IconData? icon;

  /// Tugma boshida chiqadigan icon yoki svg yoki Icon widget
  final dynamic leadIcon;

  /// Orqa fon rangi
  final Color? backgroundColor;

  /// Matn yoki icon rangi
  final Color? foregroundColor;

  /// O‘lchamlar
  final double? width;
  final double? height;

  /// Tugma radiusi
  final double? radius;

  /// Iconlar orasidagi bo‘shliq
  final double spacing;

  /// Border rangini o‘zgartirish
  final Color? borderColor;

  /// Border qalinligi (default: 1)
  final double borderWidth;

  /// Splash rangini boshqarish
  final Color? splashColor;

  /// Highlight (bosilgan) rang
  final Color? highlightColor;

  /// Splash turini boshqarish (InkRipple, InkSparkle, NoSplash, etc.)
  final InteractiveInkFeatureFactory? splashFactory;

  Widget? _buildLeadIcon(Color color) {
    if (leadIcon == null) return null;

    if (leadIcon is IconData) {
      return Icon(leadIcon as IconData, color: color);
    } else if (leadIcon is Icon) {
      return leadIcon as Icon;
    } else if (leadIcon is String) {
      return SvgPicture.asset(
        leadIcon,
        width: 20.w,
        height: 20.h,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      );
    } else if (leadIcon is Widget) {
      return leadIcon as Widget;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? AppColors.mainColor;
    final Color fgColor = foregroundColor ?? Colors.white;
    final Color borderCol = borderColor ?? Colors.white;

    final Widget? leadingIcon = _buildLeadIcon(fgColor);

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(bgColor),
        foregroundColor: WidgetStatePropertyAll(fgColor),
        minimumSize: WidgetStatePropertyAll(Size((width ?? 343).w, (height ?? 48).h)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(color: borderCol, width: borderWidth),
            borderRadius: BorderRadius.circular((radius ?? 100).r),
          ),
        ),
        elevation: WidgetStatePropertyAll(0),
        splashFactory: splashFactory ?? InkRipple.splashFactory,
        overlayColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return splashColor ?? fgColor.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
            return highlightColor ?? fgColor.withValues(alpha: 0.05);
          }
          return Colors.white;
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon,
            SizedBox(width: spacing.w),
          ],
          child ??
              AppText(
                text: text ?? '',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
          if (icon != null) ...[
            SizedBox(width: spacing.w),
            Icon(icon, color: fgColor),
          ],
        ],
      ),
    );
  }
}
