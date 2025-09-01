import '../../../core/exports.dart';

class CheckoutFormField extends StatefulWidget {
  CheckoutFormField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
    required this.validator,
    required this.isValid,
    this.autoValidateMode = AutovalidateMode.onUnfocus,
    required this.fontWeight,
    required this.color,
    required this.size,
    this.svg = AppIcons.phone,
    this.isIcon = false,
  });

  final TextEditingController controller;
  final String title, hintText;
  final String? Function(String?) validator;
  final FontWeight fontWeight;
  final Color color;
  final bool? isValid;
  final AutovalidateMode autoValidateMode;
  final double size;
  final String svg;
  final bool isIcon;

  @override
  State<CheckoutFormField> createState() => _CheckoutFormFieldState();
}

class _CheckoutFormFieldState extends State<CheckoutFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: widget.color,
            fontSize: 16.r,
            fontWeight: widget.fontWeight,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          autovalidateMode: widget.autoValidateMode,
          style: TextStyle(
            color: AppColors.textBlackColor,
            fontSize: 16.r,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            hintStyle: TextStyle(color: AppColors.grey60Color, fontSize: 16.r),
            errorStyle: TextStyle(
              fontSize: widget.size,
              fontWeight: FontWeight.w500,
            ),
            suffixIconConstraints: BoxConstraints.loose(
              Size(double.infinity, double.infinity),
            ),
            suffixIcon: Visibility.maintain(
              visible: widget.isValid != null ? true : false,
              child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: SvgPicture.asset(
                  "assets/icons/validation_${widget.isValid != null && widget.isValid! ? 'success' : 'error'}.svg",
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            hintText: widget.hintText,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey30),
            ),
            prefixIcon: widget.isIcon == true
                ? Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 8.w),
                    child: SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: Center(
                        child: AppImage(
                          imageUrl: AppIcons.email,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : null,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
