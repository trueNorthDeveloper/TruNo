
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/controller/admin_dashBoard_provider.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_all_users_screen.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_dashboad_content.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_login_screen.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/aside_bar.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/atop_bar.dart';
import 'package:truenorthflutterfrontend/public/utils/adminUtil/formLayout_reuseable.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adpro = Provider.of<AdminDashboardProvider>(context);
    final List<Widget> pages = [
      const AdminDashboardContent(),
      AdminAllUsers(),
      FormlayoutReuseable(),
      const AdminLoginScreenUi(),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;

          return Row(
            children: [
              if (!isMobile)
                Sidebar(
                  selectedIndex: adpro.selectScreen,
                  onItemSelected: adpro.onMenuItemSelected,
                ),
              Expanded(
                child: Column(
                  children: [
                    TopBar(isMobile: isMobile),
                    const Divider(height: 1),
                    Expanded(
                      child: pages[adpro.selectScreen],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
