import '../../../core/exports.dart';

class PhoneNumbers extends StatefulWidget {
  const PhoneNumbers({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<PhoneNumbers> createState() => _PhoneNumbersState();
}

class _PhoneNumbersState extends State<PhoneNumbers> {
  String selectedCountryCode = 'UZ';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone Number",
          style: TextStyle(
            color: AppColors.textBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1),
        IntlPhoneField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          showCountryFlag: true,
          showDropdownIcon: true,
          initialCountryCode: selectedCountryCode,
          dropdownIconPosition: IconPosition.trailing,
          dropdownIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.grey60Color,
            size: 20,
          ),
          flagsButtonPadding: EdgeInsets.only(left: 8),
          onCountryChanged: (country) {
            setState(() {
              selectedCountryCode = country.code;
            });
          },
          style: TextStyle(
            color: AppColors.textBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: selectedCountryCode == 'UZ' ? '90 123 45 67' : '',
            hintStyle: TextStyle(
              color: AppColors.grey60Color,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey30),
            ),
          ),
        ),
      ],
    );
  }
}

