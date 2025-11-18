import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';


import 'package:truenorthflutterfrontend/app/controller/userController/login_controller_provider.dart';


import 'package:truenorthflutterfrontend/public/utils/userUtil/app_button.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';

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
  Widget build(BuildContext context) {
    Provider.of<LoginProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
                    Consumer<LoginProvider>(
                      builder: (context, logController, child) {
                        return logController.isLoading
                            ? Center(
                                child: LoadingAnimationWidget.inkDrop(
                                  color: Color(0xfffb934d),
                                  size: 50,
                                ),
                              )
                            : AppButton(
                                text: 'Login',
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .unfocus(); // hide keyboard

                                  final loginId = loginIdController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  if (loginId.isEmpty || password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Please enter ID and password")),
                                    );
                                    return;
                                  }
                                  logController.userlogin(
                                      loginId, password, context);

                                  // Save to SharedPreferences
                                  // final prefs =
                                  //     await SharedPreferences.getInstance();
                                  // await prefs.setString('empId', loginId);
                                  // await prefs.setString('empName', password);

                                  // // Replace screen so back button doesn't go to login
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (_) => ListOfUiScreen()),
                                  // );
                                  
                                  //  Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (_) => AdminSelectUiSelectScreen()),
                                  // );
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
