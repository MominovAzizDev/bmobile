import '../../core/exports.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState
        .of(context)
        .uri
        .toString();
    int selectedIndex = 0;

    if (location.startsWith(Routes.home)/* || location.startsWith(Routes.home)*/) {
      selectedIndex = 0;
    } else if (location.startsWith(Routes.cart)) {
      selectedIndex = 1;
    }
    else if (location.startsWith(Routes.orders)) {
      selectedIndex = 2;
    }
    else if (location.startsWith(Routes.profile)) {
      selectedIndex = 3;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: MainBottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(Routes.home);
              break;
            case 1:
              context.go(Routes.cart);
              break;
            case 2:
              context.go(Routes.orders);
              break;
            case 3:
              context.go(Routes.profile);
              break;
          }
        },
      ),
    );
  }
}