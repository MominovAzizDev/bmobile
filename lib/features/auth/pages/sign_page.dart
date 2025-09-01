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
  bool _isInit = false; //
  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final phone = phoneNumberController.text.trim();
      final password = passwordController.text.trim();
      final confirm = confirmController.text.trim();

      context.read<AuthBloc>().add(
        SignUpSubmitted(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
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
          phoneNumberController.text = phone;
        }
        if (password != null && passwordController.text.isEmpty) {
          passwordController.text = password;
          confirmController.text = password;
        }
      }
      _isInit = true;
    }
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
                            return null;
                          },
                        ),
                      ],
                    ),
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
                            return null;
                          },
                        ),
                      ],

                    ),

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
                            } else if (value.length < 9) {
                              return "Telefon raqam to‘liq emas!";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
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
                            } else if (value.length < 6) {
                              return "Parol kamida 6 ta belgidan iborat bo‘lishi kerak!";
                            }
                            return null;
                          },
                        ),
                      ],

                    ),
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: "Qayta Parol",
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
                  if (state.status == AuthStatus.error) {
                    showCustomDialog(
                      context: context,
                      title: "Xatolik",
                      content: "Ro‘yxatdan o‘tishda xatolik yuz berdi",
                      type: DialogType.error,
                    );
                  } else if (state.status == AuthStatus.submit) {
                    showCustomDialog(
                      context: context,
                      title: "SMS yuborildi",
                      content: "Telefon raqamingizga tasdiqlash kodi yuborildi",
                      type: DialogType.success,
                      onConfirm: () => context.push(Routes.reset, extra: phoneNumberController.text.trim()),
                    );
                  } else if (state.status == AuthStatus.userNotFound) {
                    showCustomDialog(
                      context: context,
                      title: "Diqqat",
                      content: "Bu raqam oldin ro‘yxatdan o‘tgan!",
                      type: DialogType.warning,
                      onConfirm: () => context.push(Routes.login, extra: {
                        "phone": phoneNumberController.text.trim(),
                      }),
                    );
                  }
                },
                child: AppElevatedButton(
                  onPressed: () => _submitForm(context),
                  text: "Continue",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
