import "package:gazobeton/core/exports.dart";


class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final TextAlign? textAlign;

  const AppText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      softWrap: softWrap ?? true,
      textAlign: textAlign ?? TextAlign.start,
      style: GoogleFonts.plusJakartaSans(
        color: color ?? AppColors.textBlackColor,
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
    );
  }
}
