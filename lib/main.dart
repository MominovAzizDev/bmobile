import 'package:gazobeton/core/exports.dart';
import 'package:provider/provider.dart';

import 'core/dependency/providers.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiProvider(
        providers: providers,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.backgroundColor,
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.backgroundColor,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.black,
            ),
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
