import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/login_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

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
    return PopScope(
        canPop: !context.watch<LoginControll>().isLoggingOut,
        onPopInvoked: (didPop) {
          if (!didPop) {
            ShowTaostMessage.toastMessage(
              context,
              "Please wait, logging out...",
            );
          }
        },
        child: Scaffold(
            appBar: AppBar(),
            body: Center(
                child: Consumer<LoginControll>(builder: (context, log, child) {
              return ElevatedButton(
                onPressed: () async {
                  log.logout(context);
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
            }))));
  }
}
