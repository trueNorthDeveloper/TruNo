import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/unUsedButImp/login_controller_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/controller/login_provider.dart';
import 'package:truenorthflutterfrontend/public/config/break_points.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/login_app_button.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class LoginUi extends StatefulWidget {
  final String screenName;
  const LoginUi({super.key, required this.screenName});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  TextEditingController loginIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    loginIdController.dispose();
    passwordController.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   // Provider.of<LoginProvider>(context, listen: false);
  //   return GestureDetector(
  //     onTap: () {
  //       FocusScope.of(context).unfocus();
  //     },
  //     // ignore: deprecated_member_use
  //     child:
  //         // WillPopScope(
  //         //   onWillPop: () async {
  //         //     final isLoading = context.read<LoginControll>().isLogin;
  //         //     if (isLoading) {
  //         //       ShowTaostMessage.toastMessage(
  //         //         context,
  //         //         "Please wait, logging in...",
  //         //       );
  //         //       return false; // ❌ block back
  //         //     }
  //         //     return true; //
  //         //   },
  //         PopScope(
  //       canPop: !context.watch<LoginControll>().isLogin,
  //       // ignore: deprecated_member_use
  //       onPopInvoked: (didPop) {
  //         if (!didPop) {
  //           ShowTaostMessage.toastMessage(context, "Please wait...");
  //         }
  //       },
  //       child: Scaffold(
  //         // backgroundColor: Color(#ff914c)
  //         resizeToAvoidBottomInset: true,
  //         body: SingleChildScrollView(
  //           child: SafeArea(
  //             child: Center(
  //               child: Container(
  //                 color: Color(0xff080808),
  //                 width: SizeConFig.screenWidth * 100 / 100,
  //                 height: SizeConFig.screenHeight * 100 / 100,
  //                 child: Column(
  //                   children: [
  //                     SizedBox(height: SizeConFig.screenHeight * 7 / 100),
  //                     SizedBox(
  //                       width: SizeConFig.screenWidth * 70 / 100,
  //                       //height: SizeConFig.screenHeight * 40 / 100,
  //                       child: Text(
  //                         widget.screenName,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: SizeConFig.screenHeight * 3 / 100,
  //                           fontWeight: FontWeight.w700,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: SizeConFig.screenHeight * 3 / 100),
  //                     Container(
  //                       height: SizeConFig.screenHeight * 15 / 100,
  //                       width: SizeConFig.screenWidth * 30 / 100,
  //                       decoration: BoxDecoration(
  //                         color: Color(0xfff7f7f7),
  //                         shape: BoxShape.circle,
  //                         image: DecorationImage(
  //                           image: AssetImage(Appimage.splash),
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: SizeConFig.screenHeight * 4 / 100),
  //                     Text(
  //                       "True North Engineering Consultants",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w700,
  //                       ),
  //                     ),
  //                     SizedBox(height: SizeConFig.screenHeight * 5 / 100),
  //                     Column(
  //                       children: [
  //                         costomTextfiled(
  //                           "Login_id",
  //                           Icons.login,
  //                           loginIdController,
  //                         ),
  //                         SizedBox(height: SizeConFig.screenHeight * 3 / 100),
  //                         costomTextfiled(
  //                           "Password",
  //                           Icons.password,
  //                           passwordController,
  //                           isPasswordHideShow: true,
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: SizeConFig.screenHeight * 7 / 100),
  //                     Consumer<LoginControll>(
  //                       builder: (context, controller, child) {
  //                         return LoadingAppButton(
  //                           text:
  //                               controller.isLogin ? 'Please wait...' : 'Login',
  //                           onPressed: controller.isLogin
  //                               ? null // 🔥 disable button while loading
  //                               : () async {
  //                                   FocusScope.of(context).unfocus();

  //                                   final loginId =
  //                                       loginIdController.text.trim();
  //                                   final password =
  //                                       passwordController.text.trim();

  //                                   controller.loginPerformance(
  //                                       loginId, password, context);
  //                                 },
  //                           buttonColor: Color(0xfffb934d),
  //                           borderRadius: 80,
  //                           elevation: 4,
  //                           padding: 12,
  //                           fontSize: 12,
  //                           textColor: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           width: MediaQuery.of(context).size.width * 0.8,
  //                           height: 40,
  //                           borderWidth: 0,

  //                           // 👇 ADD THIS (if your AppButton supports child)
  //                           child: controller.isLogin
  //                               ? SizedBox(
  //                                   height: 20,
  //                                   width: 20,
  //                                   child: CircularProgressIndicator(
  //                                     color: Colors.white,
  //                                     strokeWidth: 2,
  //                                   ),
  //                                 )
  //                               : Text(
  //                                   "Login",
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                         );
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    SizeConFig.init(context);

    final bool isWebLayout = BreakPoint.isWeb(SizeConFig.screenWidth);

    Widget mainContent = PopScope(
      canPop: !context.watch<LoginControll>().isLogin,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ShowTaostMessage.toastMessage(
            context,
            "Please wait...",
          );
        }
      },
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: isWebLayout ? 356 : SizeConFig.screenWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      231,
                      229,
                      229,
                    ),
                    width: 5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizeConFig.verticalBox(0.05),

                    // Screen title
                    SizedBox(
                      width: isWebLayout ? 300 : SizeConFig.screenWidth * 0.90,
                      child: Text(
                        widget.screenName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              isWebLayout ? 20 : SizeConFig.screenHeight * 0.03,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: SizeConFig.screenHeight * 0.002,
                    ),

                    // Logo
                    Container(
                      height:
                          isWebLayout ? 100 : SizeConFig.screenHeight * 0.25,
                      width: isWebLayout ? 100 : SizeConFig.screenWidth * 0.50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(Appimage.splash),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: SizeConFig.screenHeight * 0.001,
                    ),

                    // Company name
                    const Text(
                      "True North Engineering Consultants",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(
                      height: SizeConFig.screenHeight * 0.08,
                    ),

                    // Login ID
                    costomTextfiled(
                      "Login_id",
                      Icons.login,
                      loginIdController,
                      isWebLayout,
                    ),

                    SizedBox(
                      height: SizeConFig.screenHeight * 0.03,
                    ),

                    // Password
                    costomTextfiled(
                      "Password",
                      Icons.password,
                      passwordController,
                      isWebLayout,
                      isPasswordHideShow: true,
                    ),

                    SizedBox(
                      height: SizeConFig.screenHeight * 0.07,
                    ),

                    // Login button
                    Consumer<LoginControll>(
                      builder: (
                        context,
                        controller,
                        child,
                      ) {
                        return LoadingAppButton(
                          text: controller.isLogin ? "Please wait..." : "Login",
                          onPressed: controller.isLogin
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();

                                  final String loginId =
                                      loginIdController.text.trim();

                                  final String password =
                                      passwordController.text.trim();

                                  controller.loginCrentail(
                                    loginId,
                                    password,
                                    context,
                                  );
                                },
                          buttonColor: const Color(0xfffb934d),
                          borderRadius: 80,
                          elevation: 4,
                          padding: 12,
                          fontSize: 12,
                          textColor: isWebLayout ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          width: isWebLayout
                              ? 300
                              : MediaQuery.of(context).size.width * 0.80,
                          height: 40,
                          borderWidth: 0,
                          child: controller.isLogin
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: isWebLayout
                                        ? Colors.black
                                        : Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: isWebLayout
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),

                    SizeConFig.verticalBox(0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor:
        //     isWebLayout ? const Color(0xFFF3F4F6) : const Color(0xff080808),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: isWebLayout
              ? Center(
                  child: SizedBox(
                    width: 380,
                    height: 780,
                    child: Stack(
                      children: [
                        Container(
                          width: 380,
                          height: 780,
                          margin: const EdgeInsets.symmetric(
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(48),
                            border: Border.all(
                              color: const Color(0xFF1F2937),
                              width: 12,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: mainContent,
                          ),
                        ),

                        // Bottom software/navigation stripe
                        Positioned(
                          bottom: 0,
                          left: 125,
                          child: Container(
                            width: 130,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4B5563),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : mainContent,
        ),
      ),
    );
  }

  Widget costomTextfiled(
    String hintMsg,
    IconData prefixIcons,
    TextEditingController loginIdController,
    bool isWebLayout, {
    bool isPasswordHideShow = false,
  }) {
    final passwordProvide = Provider.of<LoginProvider>(context);

    final double fieldHeight =
        isWebLayout ? 44 : (SizeConFig.screenHeight * 5 / 100);
    final double fieldWidth =
        isWebLayout ? 300 : (SizeConFig.screenWidth * 80 / 100);

    return Container(
      // height: SizeConFig.screenHeight * 5 / 100,
      // width: SizeConFig.screenWidth * 80 / 100,
      height: fieldHeight,
      width: fieldWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff7c7c7c),
        //  border: Border.all(color: Colors.black, width: 1),
      ),
      child: TextField(
        controller: loginIdController,
        obscureText:
            isPasswordHideShow ? passwordProvide.isPasswordHideShow : false,
        decoration: InputDecoration(
          hintText: hintMsg,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          prefixIcon: Icon(prefixIcons),
          suffixIcon: isPasswordHideShow
              ? IconButton(
                  onPressed: () {
                    passwordProvide.togglePassswordVisibility();
                  },
                  icon: passwordProvide.isPasswordHideShow
                      ? Image.asset(Appimage.showIcon)
                      : Image.asset(Appimage.hideIcon),
                )
              : null,
        ),
      ),
    );
  }
}
