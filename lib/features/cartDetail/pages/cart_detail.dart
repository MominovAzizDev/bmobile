import '../../../core/exports.dart';

class CartDetail extends StatefulWidget {
  const CartDetail({super.key});

  @override
  State<CartDetail> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // ✅ yangi email controller

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
          Navigator.of(context).pop(); // Loading dialogini yopish
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Buyurtma muvaffaqiyatli yuborildi!")),
          );
          Navigator.pop(context); // Sahifadan chiqish
        } else if (state.status == CheckoutStatus.error) {
          Navigator.of(context).pop(); // Loading dialogini yopish
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Buyurtma berishda xatolik yuz berdi")),
          );
        }
      },
      child: Scaffold(
        appBar: AppAppbar(
          title: "Buyurtmani rasmiylashtirish",
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // To'liq ism
                AppText(
                  text: "To'liq Ismingiz",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textBlackColor,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Ismingizni kiriting",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Ism kiritish majburiy";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Telefon raqam
                AppText(
                  text: "Telefon raqam",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textBlackColor,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "+998 XX XXX XX XX",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Telefon raqam kiritish majburiy";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Manzil
                AppText(
                  text: "Manzil",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textBlackColor,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "To'liq manzilni kiriting",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Manzil kiritish majburiy";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // ✅ Email
                AppText(
                  text: "Email",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textBlackColor,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Emailingizni kiriting",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Email kiritish majburiy";
                    }
                    if (!value!.contains('@')) {
                      return "To'g'ri email kiriting";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 32.h),

                // Submit tugmasi
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<CheckoutBloc>().add(
                          CheckoutSubmitted(
                            fullName: _nameController.text.trim(),
                            phoneNumber: _phoneController.text.trim(),
                            address: _addressController.text.trim(),
                            email: _emailController.text.trim(), // ✅ kiritilgan email ishlatiladi
                            isDeliverable: true,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: AppText(
                      text: "Buyurtma berish",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose(); // ✅ email controller ham dispose qilinadi
    super.dispose();
  }
}
