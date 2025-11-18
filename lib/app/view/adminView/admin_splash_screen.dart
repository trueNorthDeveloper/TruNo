import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/view/adminView/admin_dashboard_page.dart';
import 'package:truenorthflutterfrontend/app/view/adminView/admin_login_screen.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';

class AdminSplashScreen extends StatefulWidget {
  const AdminSplashScreen({super.key});

  @override
  State<AdminSplashScreen> createState() => _AdminSplashScreenState();
}

class _AdminSplashScreenState extends State<AdminSplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
    //  Future.delayed(const Duration(seconds: 3), () {
    //       if (!mounted) return;
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (_) => AdminLoginScreenUi()),
    //       );
    //     });
  }

  Future<void> _checkAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('empId');
      final empName = prefs.getString('empName');

      if (id != null && empName != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminDashboardPage()),
          );
        });
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminLoginScreenUi()),
          );
        });
      }
    } catch (e) {
      debugPrint("Auto-login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Appimage.splash, fit: BoxFit.fill),
      ),
    );
  }
}
