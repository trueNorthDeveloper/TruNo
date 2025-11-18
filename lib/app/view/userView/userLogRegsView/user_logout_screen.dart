import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/login_controller_provider.dart';

class Logoutui extends StatefulWidget {
  const Logoutui({super.key});

  @override
  State<Logoutui> createState() => _Logoutscreenui();
}

class _Logoutscreenui extends State<Logoutui> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Consumer<LoginProvider>(builder: (context, log, child) {
          return ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.setString('empId', apiResponse['EmpID'] ?? '');
              // await prefs.setString('empName', apiResponse['empName'] ?? '');
              // await prefs.setString('empRole', apiResponse['empRole'] ?? '');
              // await prefs.setString('sessionId', apiResponse['sessionId'] ?? '');
              // await prefs.setInt('uuid', apiResponse['uuid'] ?? 0);
              int? uuid = prefs.getInt("uuid");
              String? sessionId = prefs.getString("sessionId");
              // print(uuid);
              // print(sessionId);
              log.userlLogout(uuid, sessionId, context);
          //    prefs.clear();
          //      Navigator.pushReplacement(
          // context,
          // MaterialPageRoute(
          //   builder: (context) => SelectScreenForService(),
          // ),
        //);
            },
            child: log.isLoggingOut
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: Color(0xfffb934d),
                      size: 50,
                    ),
                  )
                : Icon(Icons.logout),
          );
        })));
  }
}
