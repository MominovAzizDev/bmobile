import '../../../core/exports.dart';

enum Region {
  andijon,
  buxoro,
  fargona,
  jizzax,
  xorazm,
  namangan,
  navoiy,
  qashqadaryo,
  qoraqalpogiston,
  samarqand,
  sirdaryo,
  surxondaryo,
  toshkentViloyati,
  toshkentShahri,
}

final List<DropdownMenuEntry<Region>> regionEntries = [
  DropdownMenuEntry(value: Region.andijon, label: "Andijon"),
  DropdownMenuEntry(value: Region.buxoro, label: "Buxoro"),
  DropdownMenuEntry(value: Region.fargona, label: "Fargʻona"),
  DropdownMenuEntry(value: Region.jizzax, label: "Jizzax"),
  DropdownMenuEntry(value: Region.xorazm, label: "Xorazm"),
  DropdownMenuEntry(value: Region.namangan, label: "Namangan"),
  DropdownMenuEntry(value: Region.navoiy, label: "Navoiy"),
  DropdownMenuEntry(value: Region.qashqadaryo, label: "Qashqadaryo"),
  DropdownMenuEntry(value: Region.qoraqalpogiston, label: "Qoraqalpogʻiston"),
  DropdownMenuEntry(value: Region.samarqand, label: "Samarqand"),
  DropdownMenuEntry(value: Region.sirdaryo, label: "Sirdaryo"),
  DropdownMenuEntry(value: Region.surxondaryo, label: "Surxondaryo"),
  DropdownMenuEntry(value: Region.toshkentViloyati, label: "Toshkent viloyati"),
  DropdownMenuEntry(value: Region.toshkentShahri, label: "Toshkent shahri"),
];

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isDeliverable = false;
  int selectedPaymentIndex = 0;
  Region? selectedRegion;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state.status == CheckoutStatus.success) {
          // Loading dialogini yopish
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Buyurtma muvaffaqiyatli yuborildi!")),
          );
          context.pop();
        } else if (state.status == CheckoutStatus.error) {
          // Loading dialogini yopish
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Xatolik yuz berdi")),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          leading: Center(
            child: GestureDetector(
              onTap: () => context.pop(),
              child: AppImage(imageUrl: AppIcons.backArrow),
            ),
          ),
          title: AppText(
            text: "Buyurtmani rasmiylashtirish",
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckoutFormField(
                controller: _fullNameController,
                title: "To'liq ismingiz",
                hintText: "Sohib",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ismni kiriting";
                  }
                  return null;
                },
                isValid: _fullNameController.text.isNotEmpty,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor,
                size: 14,
              ),
              SizedBox(height: 24.h),
              PhoneNumbers(controller: _phoneNumberController),
              SizedBox(height: 24.h),
              CheckoutFormField(
                controller: _emailController,
                title: "Email",
                hintText: "Emailni kiriting",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email kiriting";
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return "Email formatini tekshiring";
                  }
                  return null;
                },
                isValid: _emailController.text.isNotEmpty && 
                         RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text),
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor,
                size: 14,
                isIcon: true,
              ),
              SizedBox(height: 16.h),
              AppText(
                text: "Yetkazib berish",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textBlackColor,
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  PaymentContainer(
                    onTap: () {
                      setState(() {
                        selectedPaymentIndex = 0;
                        _isDeliverable = true;
                      });
                    },
                    isSelected: selectedPaymentIndex == 0,
                    text: "Yetkazib berish",
                    width: 133.w,
                  ),
                  SizedBox(width: 8.w),
                  PaymentContainer(
                    onTap: () {
                      setState(() {
                        selectedPaymentIndex = 1;
                        _isDeliverable = false;
                      });
                    },
                    isSelected: selectedPaymentIndex == 1,
                    text: "Zavoddan olib ketish",
                    width: 170.w,
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              
              if (selectedPaymentIndex == 1)
                GazobetonContainer(
                  title: "Yuborish",
                  callback: () {
                    _submitOrder();
                  },
                  width: double.infinity,
                  height: 48.h,
                ),
                
              if (selectedPaymentIndex == 0)
                Column(
                  children: [
                    DropdownSelector(
                      title: "Hudud",
                      menuEntries: regionEntries,
                      callback: (Region? value) {
                        setState(() {
                          selectedRegion = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return "Iltimos, viloyatni tanlang";
                        return null;
                      },
                      height: 48.h,
                      width: double.infinity,
                      hintText: "Hududni tanlang",
                    ),
                    SizedBox(height: 24),
                    ManzilField(
                      controller: _addressController,
                    ),
                    SizedBox(height: 32.h),
                    GazobetonContainer(
                      title: "Yuborish",
                      callback: () {
                        _submitOrder();
                      },
                      width: double.infinity,
                      height: 48.h,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitOrder() {
    // Validatsiya
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ismni kiriting")),
      );
      return;
    }

    if (_phoneNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Telefon raqamni kiriting")),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email kiriting")),
      );
      return;
    }

    if (selectedPaymentIndex == 0 && _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Manzilni kiriting")),
      );
      return;
    }

    if (selectedPaymentIndex == 0 && selectedRegion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hududni tanlang")),
      );
      return;
    }

    // Buyurtmani yuborish
    context.read<CheckoutBloc>().add(
      CheckoutSubmitted(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        address: selectedPaymentIndex == 0 
            ? _addressController.text.trim() 
            : "Zavoddan olib ketish",
        email: _emailController.text.trim(),
        isDeliverable: _isDeliverable,
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}