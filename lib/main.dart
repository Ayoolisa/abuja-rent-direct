import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/listings/screens/home_screen.dart';
import 'features/listings/screens/post_listing_screen.dart';
import 'features/listings/screens/saved_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() {
  runApp(const AbujaRentDirectApp());
}

class AbujaRentDirectApp extends StatelessWidget {
  const AbujaRentDirectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abuja Rent Direct',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Color(0xFF121212),
          background: Color(0xFF0A0A0A),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
            .apply(bodyColor: Colors.white, displayColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  String userRole = 'tenant';
  int _currentIndex = 0;

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
            _currentIndex = 0; // Reset to Home when role changes
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