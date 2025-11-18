import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/controller/adminController/admin_dashBoard_provider.dart';
import 'package:truenorthflutterfrontend/app/view/adminView/admin_dashboard_page.dart';
import 'package:truenorthflutterfrontend/app/view/adminView/admin_all_users_screen.dart';
import 'package:truenorthflutterfrontend/app/view/adminView/admin_login_screen.dart';
import 'package:truenorthflutterfrontend/app/view/adminView/admin_screen4.dart';
import 'package:truenorthflutterfrontend/app/view/adminView/admin_screen5.dart';

class AdminSelectUiSelectScreen extends StatefulWidget {
  const  AdminSelectUiSelectScreen({super.key});

  @override
  State<AdminSelectUiSelectScreen> createState() =>
      __AdminSelectUiSelectScreenStateState();
}

class __AdminSelectUiSelectScreenStateState
    extends State<AdminSelectUiSelectScreen> {
    List<Widget> selectAdminScreen = [
      AdminDashboardPage(),
      AdminAllUsers(),
      AdminLoginScreenUi(),
      AdminUiScreen4(),
      AdminUiScreen5(),
    ];
  @override
  Widget build(BuildContext context) {
    

    return Consumer<AdminDashboardProvider>(
      builder: (context, adprovider, child) {
        return Scaffold(
          body: IndexedStack(
            index: adprovider.selectScreen,
            children: selectAdminScreen,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items:const [
              BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.black,), label: 'Home',backgroundColor:Colors.amberAccent),
              BottomNavigationBarItem(icon: Icon(Icons.accessibility_new,color: Colors.black,), label: 'one'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined,color: Colors.black,), label: 'two'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.ads_click_sharp,color: Colors.black,), label: 'four'),
              BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings_sharp,color: Colors.black,), label: 'five')
            ],
            currentIndex: adprovider.selectScreen,
            onTap: adprovider.onMenuItemSelected,
          ),
        );
      },
    );
  }
}
