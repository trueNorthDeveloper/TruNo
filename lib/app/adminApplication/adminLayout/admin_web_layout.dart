import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/adminLayout/admin_body.dart';
import 'package:truenorthflutterfrontend/public/config/nav_item.dart';

class AdminWebLayout extends StatelessWidget {
  const AdminWebLayout({
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 240,
            child: ColoredBox(
              color: scheme.surfaceContainerLow,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, size: 28),
                        SizedBox(width: 8),
                        Text('Admin Portal',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final selected = i == selectedIndex;
                        final color = selected ? scheme.primary : null;
                        return ListTile(
                          leading: Icon(items[i].icon, color: color),
                          title: Text(
                            items[i].label,
                            style: TextStyle(
                              color: color,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          selected: selected,
                          onTap: () => onSelect(i),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            // Nested Scaffold = proper AppBar + body constraints
            child: Scaffold(
              appBar: AppBar(
                title: Text(items[selectedIndex].label),
                automaticallyImplyLeading: false,
                actions: [
                  const Center(child: Text('Logout')),
               //   LogoutButton(onPressed: onLogout),
                  const SizedBox(width: 16),
                ],
              ),
              body: AdminBody(items: items, selectedIndex: selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}