import 'package:gazobeton/core/exports.dart';

class MainBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const MainBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        iconSize: 24.h,
        showUnselectedLabels: true,
        elevation: 8,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_sharp),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidFileLines) ,
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUserCircle) ,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
