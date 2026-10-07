import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/public/config/nav_item.dart';

class AdminBody extends StatelessWidget {
  const AdminBody({super.key, required this.items, required this.selectedIndex});

  final List<NavItem> items;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: [for (final i in items) i.page],
    );
  }
}
