import 'package:gazobeton/core/exports.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.inputType = TextInputType.text,
    this.isObscure = false,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.enableObscureToggleForNumbers = false,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final TextInputType inputType;
  final bool isObscure;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool enableObscureToggleForNumbers;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> with WidgetsBindingObserver {
  late bool _obscureText;
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscure || widget.enableObscureToggleForNumbers;
    _focusNode = FocusNode();

    // Unfocus qilamiz page lifecycle'da
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  // App lifecycle'da focusni yo'qotish (page yopilganda)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _focusNode.unfocus();
    }
  }

  void _toggleObscure() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    final isPhone = widget.inputType == TextInputType.phone;

    final validator = widget.validator ??
        (isPhone
            ? (String? value) {
          final cleaned = value?.replaceAll(RegExp(r'\D'), '');
          if (value == null || value.isEmpty) return 'Raqamni kiriting';
          if (!RegExp(r'^(998\d{9})$').hasMatch(cleaned!)) return '998 bilan 12 xonali raqam';
          return null;
        }
            : null);

    return Focus(
      focusNode: _focusNode,
      onFocusChange: (_) => setState(() {}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.inputType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            inputFormatters: isPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: Colors.grey.shade900,
            ),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: Colors.black, width: 1.4),
              ),
              prefixIcon: widget.icon != null
                  ? Icon(widget.icon, color: Colors.grey.shade600)
                  : null,
              suffixIcon: (widget.isObscure || widget.enableObscureToggleForNumbers)
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: _toggleObscure,
              )
                  : null,
              hintText: widget.hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade400,
              ),
              errorText: _errorText,
              errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
            validator: (value) {
              final error = validator?.call(value);
              setState(() {
                _errorText = error;
              });
              return null;
            },
            onChanged: (value) {
              widget.onChanged?.call(value);
              setState(() {
                _errorText = validator?.call(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
