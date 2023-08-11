import 'package:flutter/material.dart';
import 'package:flutter_library_managent/features/Home/presentation/screen/cart_screen.dart';
import 'package:flutter_library_managent/features/Home/presentation/screen/home_screen.dart';
import '../../../profile/presentation/profile_screen.dart';

class NavigationDrawers extends StatefulWidget {
  const NavigationDrawers({Key? key}) : super(key: key);

  @override
  State<NavigationDrawers> createState() => _NavigationDrawersState();
}

class _NavigationDrawersState extends State<NavigationDrawers> {
  int _selectedIndex = 0;
  final List<Widget> lstWidget = [HomeScreen(), CartScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(
            255, 78, 20, 16), // Use your desired background color
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromARGB(
            255, 12, 22, 112), // Change to your unselected icon color
        selectedItemColor: Color.fromARGB(
            255, 0, 240, 128), // Change to your selected icon color
        elevation: 10,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Add label for better user understanding
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart', // Add label for better user understanding
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile', // Add label for better user understanding
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          // Use other transition effects for smoother animations
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: lstWidget[_selectedIndex],
      ),
    );
  }
}
