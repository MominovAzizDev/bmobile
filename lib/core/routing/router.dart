import "package:gazobeton/core/exports.dart";

Future<bool> _isAuthenticated(BuildContext context) async{
  var token=await SecureStorage.getToken();
  return token != null && token.isNotEmpty;
}


GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => SplashPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => HomeView(),
        ),
        GoRoute(
          path: Routes.cart,
          builder: (context, state) => CartView(),
          redirect: (context, state) async{
            return await _isAuthenticated(context) ? null : Routes.login;
          },
        ),
        GoRoute(
          path: Routes.orders,
          builder: (context, state) => OrdersView(),
          redirect: (context, state) async{
            return await _isAuthenticated(context) ? null : Routes.login;
          },
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => ProfileView(),
        ),
      ],
    ),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthBloc(
          repository: context.read<AuthRepository>(),
        ),
        child: SignUpPage(),
      ),
    ),
    GoRoute(
      path: Routes.detail,
      builder: (context, state) => DetailView(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthBloc(
          repository: context.read<AuthRepository>(),
        ),
        child: LoginPage(),
      ),
    ),
    GoRoute(
      path: Routes.address,
      builder: (context, state) => AddressView(),
    ),
    GoRoute(
      path: Routes.support,
      builder: (context, state) => SupportView(),
    ),
    GoRoute(
      path: Routes.language,
      builder: (context, state) => LanguagePage(),
    ),
    GoRoute(
      path: Routes.reset,
      builder: (context, state) {
        final phone = state.extra as String;
        return BlocProvider(
          create: (context) => AuthBloc(
            repository: context.read<AuthRepository>(),
          ),
          child: OtpPage(
            phoneNumber: phone,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.checkout,
      builder: (context, state) => CheckoutView(),
    ),
    GoRoute(
      path: Routes.userSettings,
      builder: (context, state) => UserSettingsView(),
    ),
    GoRoute(
      path: Routes.calculator,
      builder: (context, state) => CalculatorView(),
    ),
  ],
);
