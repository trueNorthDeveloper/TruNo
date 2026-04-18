import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/unUsedButImp/login_controller_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/controller/login_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    // Provider.of<LoginProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      // ignore: deprecated_member_use
      child:
          // WillPopScope(
          //   onWillPop: () async {
          //     final isLoading = context.read<LoginControll>().isLogin;
          //     if (isLoading) {
          //       ShowTaostMessage.toastMessage(
          //         context,
          //         "Please wait, logging in...",
          //       );
          //       return false; // ❌ block back
          //     }
          //     return true; //
          //   },
          PopScope(
        canPop: !context.watch<LoginControll>().isLogin,
        // ignore: deprecated_member_use
        onPopInvoked: (didPop) {
          if (!didPop) {
            ShowTaostMessage.toastMessage(context, "Please wait...");
          }
        },
        child: Scaffold(
          // backgroundColor: Color(#ff914c)
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Container(
                  color: Color(0xff080808),
                  width: SizeConFig.screenWidth * 100 / 100,
                  height: SizeConFig.screenHeight * 100 / 100,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConFig.screenHeight * 7 / 100),
                      SizedBox(
                        width: SizeConFig.screenWidth * 70 / 100,
                        //height: SizeConFig.screenHeight * 40 / 100,
                        child: Text(
                          widget.screenName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConFig.screenHeight * 3 / 100,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConFig.screenHeight * 3 / 100),
                      Container(
                        height: SizeConFig.screenHeight * 15 / 100,
                        width: SizeConFig.screenWidth * 30 / 100,
                        decoration: BoxDecoration(
                          color: Color(0xfff7f7f7),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(Appimage.splash),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConFig.screenHeight * 4 / 100),
                      Text(
                        "True North Engineering Consultants",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: SizeConFig.screenHeight * 5 / 100),
                      Column(
                        children: [
                          costomTextfiled(
                            "Login_id",
                            Icons.login,
                            loginIdController,
                          ),
                          SizedBox(height: SizeConFig.screenHeight * 3 / 100),
                          costomTextfiled(
                            "Password",
                            Icons.password,
                            passwordController,
                            isPasswordHideShow: true,
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConFig.screenHeight * 7 / 100),
                      // Consumer<LoginControll>(
                      //   builder: (context, logController, child) {
                      //     return logController.isLoading
                      //         ? Center(
                      //             child: LoadingAnimationWidget.inkDrop(
                      //               color: Color(0xfffb934d),
                      //               size: 50,
                      //             ),
                      //           )
                      //         : AppButton(
                      //             text: 'Login',
                      //             onPressed: () async {
                      //               FocusScope.of(context)
                      //                   .unfocus(); // hide keyboard

                      //               final loginId =
                      //                   loginIdController.text.trim();
                      //               final password =
                      //                   passwordController.text.trim();

                      //               if (loginId.isEmpty || password.isEmpty) {
                      //                 ScaffoldMessenger.of(context)
                      //                     .showSnackBar(
                      //                   SnackBar(
                      //                       content: Text(
                      //                           "Please enter ID and password")),
                      //                 );
                      //                 return;
                      //               }
                      //               logController.userloginWithJwtController(
                      //                   loginId, password, context);
                      //             },
                      //             buttonColor: Color(0xfffb934d),
                      //             borderRadius: 80,
                      //             elevation: 4,
                      //             padding: 12,
                      //             fontSize: 12,
                      //             textColor: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //             width:
                      //                 MediaQuery.of(context).size.width * 0.8,
                      //             height: 40,
                      //             borderWidth: 0,
                      //           );
                      //   },
                      // ),
                      //new code for login screen..........date 9-4-2026
                      // Consumer<LoginControll>(
                      //     builder: (context, controller, child) {
                      //   if (!controller.isLogin) {
                      //     return AppButton(
                      //       text: 'Login',
                      //       onPressed: () async {
                      //         FocusScope.of(context).unfocus(); // hide keyboard

                      //         FocusScope.of(context).unfocus(); // hide keyboard

                      //         final loginId = loginIdController.text.trim();
                      //         final password = passwordController.text.trim();
                      //         controller.loginPerformance(
                      //             loginId, password, context);
                      //       },
                      //       buttonColor: Color(0xfffb934d),
                      //       borderRadius: 80,
                      //       elevation: 4,
                      //       padding: 12,
                      //       fontSize: 12,
                      //       textColor: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //       width: MediaQuery.of(context).size.width * 0.8,
                      //       height: 40,
                      //       borderWidth: 0,
                      //     );
                      //   }

                      //   return Center(
                      //       child: LoadingAnimationWidget.inkDrop(
                      //     color: Color(0xfffb934d),
                      //     size: 50,
                      //   ));
                      // })
                      Consumer<LoginControll>(
                        builder: (context, controller, child) {
                          return LoadingAppButton(
                            text:
                                controller.isLogin ? 'Please wait...' : 'Login',
                            onPressed: controller.isLogin
                                ? null // 🔥 disable button while loading
                                : () async {
                                    FocusScope.of(context).unfocus();

                                    final loginId =
                                        loginIdController.text.trim();
                                    final password =
                                        passwordController.text.trim();

                                    controller.loginPerformance(
                                        loginId, password, context);
                                  },
                            buttonColor: Color(0xfffb934d),
                            borderRadius: 80,
                            elevation: 4,
                            padding: 12,
                            fontSize: 12,
                            textColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 40,
                            borderWidth: 0,

                            // 👇 ADD THIS (if your AppButton supports child)
                            child: controller.isLogin
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget costomTextfiled(
    String hintMsg,
    IconData prefixIcons,
    TextEditingController loginIdController, {
    bool isPasswordHideShow = false,
  }) {
    final passwordProvide = Provider.of<LoginProvider>(context);
    return Container(
      height: SizeConFig.screenHeight * 5 / 100,
      width: SizeConFig.screenWidth * 80 / 100,
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
