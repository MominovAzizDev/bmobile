import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gazobeton/features/auth/bloc/auth_event.dart';

import '../../../core/exports.dart';
import '../../common/app_dialogs.dart';
import '../../common/app_text_form_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final PhoneNumber _initialNumber = PhoneNumber(isoCode: 'UZ');
  String? _phoneNumber;

  void _submit(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      final cleanedPhone = _phoneNumber?.replaceAll("+", "").trim() ?? "";
      context.read<AuthBloc>().add(
        LoginSubmitted(
          login: cleanedPhone,
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: InkWell(
              onTap: () => context.push(Routes.language),
              child: Container(
                width: 96.w,
                height: 42.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppImage(imageUrl: AppIcons.english),
                    AppText(text: "English", fontSize: 14, fontWeight: FontWeight.w600),
                  ],
                ),

              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 44.h,
          left: 15.w,
          right: 15.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: AppImage(imageUrl: AppIcons.logo)),
              40.verticalSpace,
              /// PHONE FIELD
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: context.tr("Telefon raqamingiz", "Ваш номер телефона", "Phone Number"),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,

                  ),
                  8.verticalSpace,
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _phoneNumber = number.phoneNumber;
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                      showFlags: true,
                    ),
                    initialValue: _initialNumber,
                    textFieldController: _controller,
                    inputDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // Background rang – oq
                      hintText: context.tr("(00) 000-00-00", "(00) 000-00-00", "(00) 000-00-00"),
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // Border – qora
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(color: AppColors.textBlackColor, width: 1.3),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      errorStyle: TextStyle(fontSize: 12.sp),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr(
                          "Iltimos, telefon raqam kiriting",
                          "Пожалуйста, введите номер",
                          "Please enter phone number",
                        );
                      }
                      return null;
                    },
                  ),
                  16.verticalSpace,
                ],
              ),

              /// PAROL FIELD
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: "Parol", fontSize: 14, fontWeight: FontWeight.w600),
                  const SizedBox(height: 7),
                  AppTextFormField(
                    controller: _passwordController,
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
              20.verticalSpace,

              /// BUTTON
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthStatus.userNotFound:
                      context.push(
                        Routes.signUp,
                        extra: {
                          "phone": _phoneNumber?.replaceAll("+", "").trim(),
                          "password": _passwordController.text.trim(),
                        },
                      );
                      break;
                    case AuthStatus.submit:
                      showCustomDialog(
                        context: context,
                        title: "Xush kelibsiz!",
                        content: "Muvaffaqiyatli kirdingiz!",
                        type: DialogType.success,
                        onConfirm: () => context.pushReplacement(Routes.home),
                      );
                      break;
                    case AuthStatus.error:
                      showCustomDialog(
                        context: context,
                        title: "Xatolik",
                        content: "Login amalga oshmadi. Qaytadan urinib ko‘ring.",
                        type: DialogType.error,
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: AppElevatedButton(
                  onPressed: () => _submit(context),
                  text: context.tr("Kirish", "Войти", "Login"),
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

extension ContextLocaleX on BuildContext {
  String tr(String uz, String ru, String en) {
    final code = Localizations.localeOf(this).languageCode;
    if (code == 'ru') return ru;
    if (code == 'en') return en;
    return uz;
  }
}



