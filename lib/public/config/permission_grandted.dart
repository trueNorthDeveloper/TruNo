import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/user_splash_screen.dart';



class UserPermissionHandlerState extends StatefulWidget {
  const UserPermissionHandlerState({super.key});

  @override
  State<UserPermissionHandlerState> createState() =>
      _UserPermissionHandlerStateState();
}

class _UserPermissionHandlerStateState
    extends State<UserPermissionHandlerState> {
  @override
  void initState() {
    super.initState();
    handlePermissions();
  }

  Future<void> handlePermissions() async {
    bool allGranted = await checkPermissions();

    while (!allGranted) {
      bool anyPermanentlyDenied = await isAnyPermissionPermanentlyDenied();

      if (anyPermanentlyDenied) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permissions Required'),
            content: Text(
                'Some permissions are permanently denied. Please enable them in app settings.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings(); // Takes user to system settings
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
        );
      } else {
        allGranted = await checkPermissions();
      }

      await Future.delayed(Duration(seconds: 1));

      allGranted = await checkPermissions();
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ));
  }

  Future<bool> checkPermissions() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.location,
      Permission.storage,
    ].request();

    return status.values.every((permission) => permission.isGranted);
  }

  Future<bool> isAnyPermissionPermanentlyDenied() async {
    return await Permission.camera.isPermanentlyDenied ||
        await Permission.location.isPermanentlyDenied ||
        await Permission.storage.isPermanentlyDenied;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("need permission"),
      ),
    );
  }
}
