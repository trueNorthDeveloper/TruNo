import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/user_home_page_screen.dart';

import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/user_work_history_screen.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userLogRegsView/user_profile_screen.dart';

class ListOfUiScreen extends StatefulWidget {
  ListOfUiScreen({super.key});

  @override
  State<ListOfUiScreen> createState() => _ListOfUiScreenState();
}

class _ListOfUiScreenState extends State<ListOfUiScreen> {
  static const List<Widget> _screens = [
    UserHomePage(),
    UserWorkHistory(),
    UserProfileUI()
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Consumer<UserDashboardProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              body: IndexedStack(
                index: provider.currentIndex,
                children: _screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: provider.currentIndex,
                onTap: provider.changePostion,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.history), label: 'History'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Profile'),
                ],
              ),
            );
          },
        ));
  }
}
