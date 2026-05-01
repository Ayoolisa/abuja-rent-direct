import 'package:flutter/material.dart';
import '../features/listings/screens/home_screen.dart';
import '../features/listings/screens/post_listing_screen.dart';
import '../features/listings/screens/saved_screen.dart';
import '../features/profile/screens/profile_screen.dart';

class MainNavigator extends StatefulWidget {
  final String initialRole;

  const MainNavigator({super.key, this.initialRole = 'tenant'});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  late String userRole;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    userRole = widget.initialRole;
  }

  List<Widget> get _screens {
    return [
      const HomeScreen(),
      if (userRole == 'landlord') const PostListingScreen(),
      const SavedScreen(),
      ProfileScreen(
        currentRole: userRole,
        onRoleChanged: (newRole) {
          setState(() {
            userRole = newRole;
            _currentIndex = 0;
          });
        },
      ),
    ];
  }

  List<NavigationDestination> get _destinations {
    return [
      const NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      if (userRole == 'landlord')
        const NavigationDestination(icon: Icon(Icons.add_home_outlined), label: 'Post'),
      const NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Saved'),
      const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0A0A0A),
        indicatorColor: Colors.white24,
        selectedIndex: _currentIndex < _screens.length ? _currentIndex : 0,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: _destinations,
      ),
    );
  }
}