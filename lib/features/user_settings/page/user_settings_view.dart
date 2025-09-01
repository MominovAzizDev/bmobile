import 'package:gazobeton/features/cart/widgets/gazobeton_container.dart';

import '../../../core/exports.dart';
import '../../cart/widgets/checkout_form_field.dart';
import '../../cart/widgets/manzil_field.dart';
import '../../cart/widgets/phone_numbers.dart';
import '../widgets/image_picker_profile.dart';

class UserSettingsView extends StatefulWidget {
  const UserSettingsView({super.key});

  @override
  State<UserSettingsView> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: Center(
          child: GestureDetector(
            onTap: () => context.pop(),
            child: AppImage(
              imageUrl: AppIcons.backArrow,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: AppText(
              text: "Delete Account",
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.mainColor,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.h),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: AppText(
                text: "User settings",
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackColor,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileImagePicker(
              callback: () async {
                File? pickedImage;
                final imagePicker = ImagePicker();
                final image = await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  pickedImage = File(image.path);
                }
              },
            ),
            SizedBox(height: 32.h),
            CheckoutFormField(
              controller: nameController,
              title: "To'liq ismingiz",
              hintText: "Sohib",
              validator: (_) {
                return null;
              },
              isValid: false,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackColor,
              size: 14,
            ),
            SizedBox(height: 24.h),
            PhoneNumbers(controller: phoneController),
            SizedBox(height: 24.h),
            CheckoutFormField(
              controller: emailController,
              title: "Email",
              hintText: "Emailni kiritng",
              validator: (_) {
                return null;
              },
              isValid: false,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackColor,
              size: 14,
              isIcon: true,
            ),
            SizedBox(height: 16.h),
            ManzilField(
              controller: TextEditingController(),
            ),
            SizedBox(height: 32.h),
            GazobetonContainer(
              callback: () {},
              width: double.infinity,
              height: 48.h,
              title: "Save",
            ),
          ],
        ),
      ),
    );
  }
}
