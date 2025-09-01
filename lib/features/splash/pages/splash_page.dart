import "package:gazobeton/core/exports.dart";


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacement(Routes.login);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              AppIcons.logo,
              width: 160.w,
              height: 50.h,
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 3,
                backgroundColor: Colors.red.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
