import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/view/user_login_screen.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class SelectScreenForService extends StatefulWidget {
  const SelectScreenForService({super.key});

  @override
  State<SelectScreenForService> createState() => _SelectScreenForServiceState();
}

class _SelectScreenForServiceState extends State<SelectScreenForService> {
  @override
  Widget build(BuildContext context) {
    SizeConFig.init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConFig.screenHeight * 7 / 100),
              Text(
                "Welcome to True North",
                style: TextStyle(
                  fontSize: SizeConFig.screenHeight * 3 / 100,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: SizeConFig.screenHeight * 3 / 100),
              SizedBox(
                height: SizeConFig.screenHeight * 30 / 100,
                width: SizeConFig.screenWidth * 50 / 100,
                child: Image.asset(Appimage.splash),
              ),
              SizedBox(height: SizeConFig.screenHeight * 10 / 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customContainer(
                    Colors.grey,
                    context,
                    "Service Management unit",
                    Colors.black,
                    "Service Management Unit",
                    // LoginUi(),
                    (msg) => LoginUi(screenName: msg),
                  ),
                  customContainer(
                    const Color.fromARGB(255, 205, 154, 136),
                    context,
                    "Civil Work Management unit",
                    const Color.fromARGB(255, 219, 213, 160),
                    "Civil Work Management Unit",
                    (msg) => LoginUi(screenName: msg),
                  ),
                  //SizedBox(width: SizeConFig.screenWidth * 5 / 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget customText(String text, BuildContext context) {
  Widget customContainer(
    Color bgColor,
    BuildContext context,
    String text,
    Color textColors,
    String message,
    Widget Function(String) nextScreenBuilder,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreenBuilder(message)),
        );
        // print("working");
      },
      child: Container(
        height: SizeConFig.screenHeight * 13 / 100,
        width: SizeConFig.screenWidth * 40 / 100,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color.fromARGB(255, 220, 213, 213),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: SizeConFig.screenHeight * 2 / 100,
              fontWeight: FontWeight.w600,
              color: textColors,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
