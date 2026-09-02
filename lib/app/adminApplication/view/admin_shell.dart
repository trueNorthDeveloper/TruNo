import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_all_users_screen.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_createProject_screen.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_dashboad_content.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_screen4.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/controller/logout_provider.dart';
import 'package:truenorthflutterfrontend/public/config/Nav_item.dart';
import 'package:truenorthflutterfrontend/public/config/break_points.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;
  final List<NavItem> _items = [
    NavItem(
        icon: Icons.analytics,
        label: "Analytics",
        page: AdminDashboardContent()),
    NavItem(icon: Icons.people, label: "Login_User", page: AdminAllUsers()),
    NavItem(
        icon: Icons.create,
        label: "Add_Project",
        page: AdminCreateprojectScreen()),
    NavItem(
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        page: AdminUiScreen4()),
    // NavItem(
    //     icon: Icons.people_outline, label: 'Expense', page: AdminExpenseModule()),
  ];
  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<LogoutProvider>(context, listen: false);
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      if (BreakPoint.isWeb(width)) {
        return _WebLayout(
          items: _items,
          selectedIndex: _selectedIndex,
          onSelect: _onSelect,
          onLogout: _logout,
        );
      } else {
        return _MobileLayout(
          items: _items,
          selectedIndex: _selectedIndex,
          onSelect: _onSelect,
          onLogout: _logout,
        );
      }
    });
  }

  // Common logout method
  Future<void> _logout() async {
    print("admin dashboard logged out");
    bool status = await showLogoutConfirmationDialog(context);
    if (!status) return;

    if (!context.mounted) return;
    await context.read<LogoutProvider>().logout(context);
  }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            // title: const Text("Thanks for  your effective work have a good day"),
            content: Container(
              height: MediaQuery.of(context).size.height * 5 / 100,
              width: 30,
              child: Center(
                child: const Text(
                  "are you sure you want to logout ?",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Yes",
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("No"),
                  ),
                ],
              )
            ],
          ),
        ) ??
        false;
  }
}

// ============================================================
// WEB LAYOUT
// ============================================================
class _WebLayout extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;
  const _WebLayout({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LogoutProvider>();
    return Scaffold(
      body: Row(
        children: [
          // =========================
          // SIDE BAR
          // =========================
          Container(
            width: 240,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            // color: Colors.red,
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
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected = index == selectedIndex;
                      return ListTile(
                        leading: Icon(item.icon,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : null),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        selected: selected,
                        onTap: () => onSelect(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // =========================
          // MAIN CONTENT
          // =========================
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(items[selectedIndex].label),
                  automaticallyImplyLeading: false,
                  actions: [
                    Row(
                      children: [
                        const Text("Logout"),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: "Logout",
                          onPressed: onLogout,
                          icon: provider.isLoggingOut
                              ? SizedBox(child: CircularProgressIndicator())
                              : const Icon(
                                  Icons.logout,
                                ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
                Expanded(child: items[selectedIndex].page),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MOBILE LAYOUT
// ============================================================
class _MobileLayout extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;
  const _MobileLayout(
      {required this.items,
      required this.selectedIndex,
      required this.onSelect,
      required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LogoutProvider>();
    return Scaffold(
      // =========================
      // MOBILE APP BAR
      // =========================
      appBar: AppBar(
        title: Text(items[selectedIndex].label),
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: onLogout,
            icon: provider.isLoggingOut
                ? SizedBox(
                    child: CircularProgressIndicator(),
                  )
                : const Icon(
                    Icons.logout,
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Admin Portal',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                )),
            for (int i = 0; i < items.length; i++)
              ListTile(
                leading: Icon(items[i].icon),
                title: Text(items[i].label),
                selected: i == selectedIndex,
                onTap: () {
                  onSelect(i);
                  Navigator.pop(context); // close drawer
                },
              ),
          ],
        ),
      ),
      body: items[selectedIndex].page,
      // Only show bottom nav for the first 4 items to keep it usable;
      // extend via drawer for anything beyond that.
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelect,
        destinations: [
          for (final item in items)
            NavigationDestination(icon: Icon(item.icon), label: item.label),
        ],
      ),
    );
  }
}
