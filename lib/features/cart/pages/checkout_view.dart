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
  DropdownMenuEntry(value: Region.toshkentShahri, label: "Toshkent viloyati"),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(repo: context.read<CheckoutRepository>()),
      child: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
           print("📢 Bloc status: ${state.status}");
          if (state.status == CheckoutStatus.loading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            context.pop(context);
          }

          if (state.status == CheckoutStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Buyurtma muvaffaqiyatli yuborildi!")),
            );
            context.pop();
          }

          if (state.status == CheckoutStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Xatolik yuz berdi")),
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
                  validator: (_) => null,
                  isValid: false,
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
                  validator: (_) => null,
                  isValid: false,
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
                      context.read<CheckoutBloc>().add(
                        CheckoutSubmitted(
                          fullName: _fullNameController.text,
                          phoneNumber: _phoneNumberController.text,
                          address: "Olib ketish",
                          email: _emailController.text,
                          isDeliverable: _isDeliverable,
                        ),
                      );
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
                        callback: (value) {},
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
                          context.read<CheckoutBloc>().add(
                            CheckoutSubmitted(
                              fullName: _fullNameController.text,
                              phoneNumber: _phoneNumberController.text,
                              address: _addressController.text,
                              email: _emailController.text,
                              isDeliverable: _isDeliverable,
                            ),
                          );    print("FULLNAME: ${_fullNameController.text}");
                          print("PHONE: ${_phoneNumberController.text}");
                          print("ADDRESS: ${_addressController.text}");
                          print("EMAIL: ${_emailController.text}");
                          print("IS_DELIVERABLE: $_isDeliverable");
                          showDialog(
                            context: context,
                            builder: (context) => Container(
                              width: 200,
                              height: 200,
                              color: Colors.black,
                            ),
                          );
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
      ),
    );
  }
}
