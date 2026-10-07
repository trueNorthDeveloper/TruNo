import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/adminLayout/admin_body.dart';
import 'package:truenorthflutterfrontend/public/config/nav_item.dart';

class AdminMobileLayout extends StatelessWidget {
  const AdminMobileLayout({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
  });

  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  // NavigationBar supports 2..5 destinations. More than that => drawer.
  bool get _useBottomNav => items.length <= 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(items[selectedIndex].label),
        actions: [
         // LogoutButton(onPressed: onLogout),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _useBottomNav
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Admin Portal',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  for (int i = 0; i < items.length; i++)
                    ListTile(
                      leading: Icon(items[i].icon),
                      title: Text(items[i].label),
                      selected: i == selectedIndex,
                      onTap: () {
                        onSelect(i);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
      body: AdminBody(items: items, selectedIndex: selectedIndex),
      bottomNavigationBar: _useBottomNav
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelect,
              destinations: [
                for (final i in items)
                  NavigationDestination(icon: Icon(i.icon), label: i.label),
              ],
            )
          : null,
    );
  }
}