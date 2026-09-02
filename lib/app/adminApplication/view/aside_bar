import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF1F2937), // dark grey
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            child: Text(
              'TrueNO Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildTile(Icons.dashboard, 'Dashboard', 0),
          _buildTile(Icons.people, 'Users', 1),
          _buildTile(Icons.book, 'Form', 2),
          _buildTile(Icons.logout, 'Admin Login', 3),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      hoverColor: Colors.blueGrey[700],
      child: Container(
        color: isSelected ? Colors.blueGrey[700] : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
