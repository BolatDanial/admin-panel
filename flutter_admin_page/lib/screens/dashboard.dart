// screens/dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_admin_page/components/side_navigation.dart';
import 'package:flutter_admin_page/screens/products_screen.dart';
// import 'package:flutter_admin_page/screens/users_screen.dart';
// import 'package:flutter_admin_page/screens/orders_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProductsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Row(
        children: [
          // Side Navigation
          SideNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          // Main Content
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
    );
  }
}