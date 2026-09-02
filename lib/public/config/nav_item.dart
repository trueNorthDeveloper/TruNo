import 'package:flutter/material.dart';

/// Simple model for a nav destination, shared between sidebar,
/// drawer, and bottom nav so you don't repeat yourself.
class NavItem {
  final IconData icon;
  final String label;
  final Widget page;

  const NavItem({required this.icon, required this.label, required this.page});
}
