// components/side_navigation.dart
import 'package:flutter/material.dart';

class SideNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SideNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color.fromARGB(255, 50, 72, 132),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Admin Panel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          _buildNavItem(Icons.shopping_bag, 'Products', 0),
          _buildNavItem(Icons.people, 'Users', 1),
          _buildNavItem(Icons.receipt, 'Orders', 2),
          const Spacer(),
          const Divider(color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon, color: currentIndex == index ? Colors.white : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: currentIndex == index ? Colors.white : Colors.white70,
          fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: currentIndex == index,
      selectedTileColor: Colors.blueGrey[700],
      onTap: () => onTap(index),
    );
  }
}