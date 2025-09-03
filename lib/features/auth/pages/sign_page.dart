import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/features/auth/bloc/auth_bloc.dart';
import 'package:gazobeton/features/auth/bloc/auth_event.dart';

import '../../common/app_dialogs.dart';
import '../../common/app_text_form_field.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool _isInit = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final phone = phoneNumberController.text.trim();
      final password = passwordController.text.trim();
      final confirm = confirmController.text.trim();

      // Additional validation for phone number
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanPhone.length < 9) {
        showCustomDialog(
          context: context,
          title: "Xatolik",
          content: "Telefon raqami noto'g'ri formatda kiritilgan",
          type: DialogType.error,
        );
        return;
      }

      // Validate password match
      if (password != confirm) {
        showCustomDialog(
          context: context,
          title: "Xatolik", 
          content: "Parollar mos emas",
          type: DialogType.error,
        );
        return;
      }

      context.read<AuthBloc>().add(
        SignUpSubmitted(
          firstName: firstName,
          lastName: lastName,
          phone: cleanPhone,
          password: password,
          confirmPassword: confirm,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        final phone = extra['phone'] as String?;
        final password = extra['password'] as String?;

        if (phone != null && phoneNumberController.text.isEmpty) {
          phoneNumberController.text = _formatPhoneForDisplay(phone);
        }
        if (password != null && passwordController.text.isEmpty) {
          passwordController.text = password;
          confirmController.text = password;
        }
      }
      _isInit = true;
    }
  }

  String _formatPhoneForDisplay(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length >= 12 && cleaned.startsWith('998')) {
      final code = cleaned.substring(3, 5);
      final first = cleaned.substring(5, 8);
      final second = cleaned.substring(8, 10);
      final third = cleaned.substring(10);
      return '+998 $code $first $second $third';
    } else if (cleaned.length == 9) {
      final code = cleaned.substring(0, 2);
      final first = cleaned.substring(2, 5);
      final second = cleaned.substring(5, 7);
      final third = cleaned.substring(7);
      return '$code $first $second $third';
    }
    
    return phone;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(text: "Sign Up", fontSize: 30),
              8.verticalSpace,
              AppText(
                text: "Please fill in the form below to register.",
                fontSize: 16,
                color: AppColors.grey60Color,
              ),
              32.verticalSpace,
              Form(
                key: _formKey,
                child: Column(
                  spacing: 24.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// First Name
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: "Ismingiz",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        AppTextFormField(
                          controller: firstNameController,
                          hint: "Ismingizni kiriting",
                          icon: null,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Iltimos ismingizni kiriting!";
                            }
                            if (value.trim().length < 2) {
                              return "Ism kamida 2 ta harfdan iborat bo'lishi kerak!";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    
                    /// Last Name
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: "Familyangiz",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        AppTextFormField(
                          controller: lastNameController,
                          hint: "Familyangizni kiriting",
                          icon: null,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Iltimos familyangizni kiriting!";
                            }
                            if (value.trim().length < 2) {
                              return "Familiya kamida 2 ta harfdan iborat bo'lishi kerak!";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    /// Phone Number
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: "Telefon raqamingiz",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        AppTextFormField(
                          controller: phoneNumberController,
                          hint: "Telefon raqamingizni kiriting",
                          icon: Icons.phone,
                          inputType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Iltimos telefon raqam kiriting!";
                            }
                            
                            final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
                            if (cleaned.length < 9) {
                              return "Telefon raqam kamida 9 raqamdan iborat bo'lishi kerak!";
                            }
                            
                            if (cleaned.length == 9) {
                              return null;
                            } else if (cleaned.length == 12 && cleaned.startsWith('998')) {
                              return null;
                            } else {
                              return "Telefon raqami noto'g'ri formatda!";
                            }
                          },
                        ),
                      ],
                    ),
                    
                    /// Password
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: "Parol",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        AppTextFormField(
                          controller: passwordController,
                          hint: "Parolingizni kiriting",
                          icon: null,
                          enableObscureToggleForNumbers: true,
                          inputType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Iltimos parol kiriting!";
                            } else if (value.trim().length < 6) {
                              return "Parol kamida 6 ta belgidan iborat bo'lishi kerak!";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    
                    /// Confirm Password
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: "Parolni tasdiqlash",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        AppTextFormField(
                          controller: confirmController,
                          hint: "Parolni qayta kiriting",
                          icon: null,
                          enableObscureToggleForNumbers: true,
                          inputType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Iltimos parolni qayta kiriting!";
                            } else if (value != passwordController.text) {
                              return "Parollar mos emas!";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              32.verticalSpace,
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthStatus.error:
                      showCustomDialog(
                        context: context,
                        title: "Xatolik",
                        content: "Ro'yxatdan o'tishda xatolik yuz berdi. Ma'lumotlaringizni tekshiring va qaytadan urinib ko'ring.",
                        type: DialogType.error,
                      );
                      break;
                    case AuthStatus.verify:
                      showCustomDialog(
                        context: context,
                        title: "Muvaffaqiyatli",
                        content: "Telefon raqamingizga tasdiqlash kodi yuborildi",
                        type: DialogType.success,
                        onConfirm: () {
                          final cleanPhone = phoneNumberController.text.replaceAll(RegExp(r'[^\d]'), '');
                          context.push(Routes.reset, extra: cleanPhone);
                        },
                      );
                      break;
                    case AuthStatus.alreadyExists:
                      showCustomDialog(
                        context: context,
                        title: "Diqqat",
                        content: "Bu telefon raqami allaqachon ro'yxatdan o'tgan. Login sahifasiga o'ting.",
                        type: DialogType.warning,
                        onConfirm: () => context.pushReplacement(Routes.home),
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: AppElevatedButton(
                  onPressed: _submitForm,
                  text: "Ro'yxatdan o'tish",
                  icon: Icons.arrow_forward,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}