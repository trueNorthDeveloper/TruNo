import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/view/user_login_screen.dart';
import 'package:truenorthflutterfrontend/public/config/break_points.dart';

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

    // 1. Detect if the screen is web/desktop size using your BreakPoint class
    final bool isWebLayout = BreakPoint.isWeb(SizeConFig.screenWidth);

// 2. Build the main content of your screen
    Widget mainContent = SingleChildScrollView(
      child: Column(
        children: [
          // SizeConFig.verticalBox(
          //     0.07), // Replaced with your native helper method
          // Extra top padding inside the web frame to clear the mock camera notch
          // isWebLayout
          //     ? const SizedBox(height: 40)
          //     : SizeConFig.verticalBox(0.07),
               SizeConFig.verticalBox(0.07),

          Text(
            "Welcome to True North",
            style: TextStyle(
              fontSize: isWebLayout ? 22 : (SizeConFig.screenHeight * 3 / 100),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizeConFig.verticalBox(0.03),
          SizedBox(
            height: isWebLayout ? 180 : (SizeConFig.screenHeight * 30 / 100),
            width: isWebLayout ? 180 : (SizeConFig.screenWidth * 50 / 100),
            child: Image.asset(Appimage.splash, fit: BoxFit.contain),
          ),
          SizeConFig.verticalBox(0.10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              customContainer(
                Colors.grey,
                context,
                "Service Management unit",
                Colors.black,
                "Service Management Unit",
                isWebLayout,
                (msg) => LoginUi(screenName: msg),
              ),
              customContainer(
                const Color.fromARGB(255, 205, 154, 136),
                context,
                "Civil Work Management unit",
                const Color.fromARGB(255, 219, 213, 160),
                "Civil Work Management Unit",
                isWebLayout,
                (msg) => LoginUi(screenName: msg),
              ),
              if(isWebLayout)const SizedBox(height: 24,)
            ],
          ),
        ],
      ),
    );
    return Scaffold(
        backgroundColor: isWebLayout ? const Color(0xFFF3F4F6) : Colors.white,
        body: SafeArea(
          child: isWebLayout
              ? Center(
                  child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      // width: 450, // Standard native mobile simulation width
                      // height: 850,
                      // Standard native mobile simulation height
                      width: 380,
                      height: 780,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(48),
                        // border: Border.all(
                        //   color: const Color(
                        //       0xFF1F2937), // Phone body bezel ring outline
                        //   width: 12,
                        // ),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            body: mainContent,
                          )),
                    ),
                    // Top Circle/Island Hardware Camera Notch
                    Positioned(
                      top: 38,
                      child: Container(
                        width: 110,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2937),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Bottom Navigation Software Bar Indicator
                    Positioned(
                      bottom: 32,
                      child: Container(
                        width: 130,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9CA3AF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ))
              : mainContent,
        ));
    // return Scaffold(
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           SizedBox(height: SizeConFig.screenHeight * 7 / 100),
    //           Text(
    //             "Welcome to True North",
    //             style: TextStyle(
    //               fontSize: SizeConFig.screenHeight * 3 / 100,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //           SizedBox(height: SizeConFig.screenHeight * 3 / 100),
    //           SizedBox(
    //             height: SizeConFig.screenHeight * 30 / 100,
    //             width: SizeConFig.screenWidth * 50 / 100,
    //             child: Image.asset(Appimage.splash),
    //           ),
    //           SizedBox(height: SizeConFig.screenHeight * 10 / 100),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               customContainer(
    //                 Colors.grey,
    //                 context,
    //                 "Service Management unit",
    //                 Colors.black,
    //                 "Service Management Unit",
    //                 // LoginUi(),
    //                 (msg) => LoginUi(screenName: msg),
    //               ),
    //               customContainer(
    //                 const Color.fromARGB(255, 205, 154, 136),
    //                 context,
    //                 "Civil Work Management unit",
    //                 const Color.fromARGB(255, 219, 213, 160),
    //                 "Civil Work Management Unit",
    //                 (msg) => LoginUi(screenName: msg),
    //               ),
    //               //SizedBox(width: SizeConFig.screenWidth * 5 / 100),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget customContainer(
    Color bgColor,
    BuildContext context,
    String text,
    Color textColors,
    String message,
    bool isWebLayout,
    Widget Function(String) nextScreenBuilder,
  ) {
    // Dynamic sizing configuration based on target device screen environment
    final double containerHeight =
        isWebLayout ? 110 : (SizeConFig.screenHeight * 13 / 100);
    final double containerWidth =
        isWebLayout ? 180 : (SizeConFig.screenWidth * 40 / 100);
    final double textFontSize =
        isWebLayout ? 14 : (SizeConFig.screenHeight * 2 / 100);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreenBuilder(message)),
        );
      },
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color.fromARGB(255, 220, 213, 213),
            width: 1,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: textFontSize,
                fontWeight: FontWeight.w600,
                color: textColors,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
  // Widget customText(String text, BuildContext context) {
  // Widget customContainer(
  //   Color bgColor,
  //   BuildContext context,
  //   String text,
  //   Color textColors,
  //   String message,
  //   Widget Function(String) nextScreenBuilder,
  // ) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => nextScreenBuilder(message)),
  //       );
  //       // print("working");
  //     },
  //     child: Container(
  //       height: SizeConFig.screenHeight * 13 / 100,
  //       width: SizeConFig.screenWidth * 40 / 100,
  //       decoration: BoxDecoration(
  //         color: bgColor,
  //         borderRadius: BorderRadius.circular(18),
  //         border: Border.all(
  //           color: const Color.fromARGB(255, 220, 213, 213),
  //           width: 1,
  //         ),
  //       ),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             fontSize: SizeConFig.screenHeight * 2 / 100,
  //             fontWeight: FontWeight.w600,
  //             color: textColors,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
