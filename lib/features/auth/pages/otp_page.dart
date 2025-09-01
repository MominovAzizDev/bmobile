import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gazobeton/features/auth/bloc/auth_event.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/exports.dart';
import '../../common/app_dialogs.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  late final StreamController<ErrorAnimationType> _errorController;
  late Timer _timer;
  int _secondsRemaining = 59;

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _errorController.close();
    _timer.cancel();
    super.dispose();
  }

  void _verifyCode() {
    context.read<AuthBloc>().add(
      VerifySubmitted(
        phone: widget.phoneNumber,
        code: _otpController.text,
      ),
    );
  }

  void _resendCode() {
    if (_secondsRemaining == 0) {
      setState(() => _secondsRemaining = 59);
      _startResendTimer();
      // Optional: resend event
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.verify:
            showCustomDialog(
              context: context,
              title: "Muvaffaqiyatli",
              content: "Siz muvaffaqiyatli ro‘yxatdan o‘tdingiz",
              type: DialogType.success,
              onConfirm: () => context.pushReplacement(Routes.home),
            );
            break;
          case AuthStatus.error:
            _errorController.add(ErrorAnimationType.shake);
            showCustomDialog(
              context: context,
              title: "Xatolik",
              content: "Tasdiqlash kodi xato!",
              type: DialogType.error,
            );
            break;
          case AuthStatus.alreadyExists:
            showCustomDialog(
              context: context,
              title: "Eslatma",
              content: "Siz allaqachon ro‘yxatdan o‘tgansiz!",
              type: DialogType.warning,
              onConfirm: () => context.pushReplacement(Routes.login),
            );
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppAppbar(title: "Verify Phone"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: "Verification Code",
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
              8.verticalSpace,
              AppText(
                text: "A verification code has been sent to",
                fontSize: 16,
                color: AppColors.grey60Color,
              ),
              8.verticalSpace,
              AppText(
                text: "+${widget.phoneNumber}",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              30.verticalSpace,

              /// OTP FIELD
              PinCodeTextField(
                appContext: context,
                controller: _otpController,
                length: 6,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                errorAnimationController: _errorController,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 56,
                  fieldWidth: 45,
                  activeColor: Colors.grey,
                  selectedColor: Colors.black,
                  inactiveColor: AppColors.grey60Color,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.grey.shade300,
                  inactiveFillColor: Colors.white,
                ),
                animationDuration: const Duration(milliseconds: 250),
                enableActiveFill: true,
                onChanged: (_) {},
                onCompleted: (_) {},
              ),

              Center(
                child: TextButton(
                  onPressed: _resendCode,
                  child: AppText(
                    text: _secondsRemaining > 0 ? "00:${_secondsRemaining.toString().padLeft(2, '0')}" : "Resend Code",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _secondsRemaining > 0 ? AppColors.grey60Color : AppColors.mainColor,
                  ),
                ),
              ),

              const Spacer(),
              AppElevatedButton(
                onPressed: _verifyCode,
                text: "Tasdiqlash",
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
