import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/leaveScreen.dart';

import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/user_attendance_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userLogRegsView/user_logout_screen.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/login_controller_provider.dart';

import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_work_module_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_team_module_screen.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/text_style.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});
  @override
  State<UserHomePage> createState() => _MyUserhomePage();
}

class _MyUserhomePage extends State<UserHomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<LoginProvider>(context, listen: false).fetchSessionInfo());

    Future.microtask(() =>
        Provider.of<UserProjectProvider>(context, listen: false)
            .fatchUserTask());
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserDashboardProvider>(context, listen: false);
    // final user2 = context.watch<LoginControll>().user;

    SizeConFig.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: SizedBox(
          height: SizeConFig.screenHeight,
          width: SizeConFig.screenWidth,
          child: Column(children: [
            SizedBox(height: SizeConFig.screenHeight * 2 / 100),

            // Center(
            //     child: AnimatedOpacity(
            //       opacity: 12.22,

            //       duration: const Duration(milliseconds: 500),
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 24, vertical: 16),
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(20),
            //           boxShadow: const [
            //             BoxShadow(
            //               blurRadius: 15,
            //               color: Colors.black26,
            //             )
            //           ],
            //         ),
            //         child: Text(
            //           "Welcome, ${user2!.name} 👋",
            //           style: const TextStyle(
            //             fontSize: 22,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     )
            // ),
            SizedBox(
              width: SizeConFig.screenWidth * 95 / 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ShowTaostMessage.toastMessage(
                            context,
                            "help and support",
                          );
                        },
                        child: Text("Help & Support"),
                      ),
                      Consumer<LoginProvider>(builder: (context, log, child) {
                        //log.userLoginInfoModel
                        return ElevatedButton(
                            onPressed: () async {
                              bool status =
                                  await showLogoutConfirmationDialog(context);

                              if (!status) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Logoutui(),
                                    ));
                              }
                            },
                            child: Text("Logout"));
                      }),
                    ],
                  ),
                  SizedBox(height: SizeConFig.screenHeight * 1 / 100),

                  ///login info image login time and date
                  Consumer<LoginProvider>(
                    builder: (context, provider, _) {
                      if (provider.isSessionLog) {
                        return Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: const Color(0xfffb934d),
                            size: 50,
                          ),
                        );
                      }

                      if (provider.error != null) {
                        return Center(child: Text("Error: ${provider.error}"));
                      }

                      final user = provider.userLoginInfoModel;
                      if (user == null) {
                        return const Center(child: Text("No user data found."));
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: user.imageURL.isNotEmpty
                                ? Image.network(
                                    user.imageURL,
                                    height: SizeConFig.screenHeight * 0.1,
                                    width: SizeConFig.screenWidth * 0.2,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        Appimage.splash,
                                        height: SizeConFig.screenHeight * 0.1,
                                        width: SizeConFig.screenWidth * 0.2,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    Appimage.splash,
                                    height: SizeConFig.screenHeight * 0.1,
                                    width: SizeConFig.screenWidth * 0.2,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(height: 10),
                          customUIandText("Hey,", user.empName, Colors.black),
                          customUIandText("Your Login Time Is: ",
                              user.formattedLoginTime!, Colors.green),
                          customUIandText("Ideal Logout Time: ",
                              user.formattedLogoutTime!, Colors.red),
                        ],
                      );
                    },
                  ),
                  Consumer<UserDashboardProvider>(
                    builder: (context, useFun, child) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              useFun.chnageColorOnOff();
                            },
                            child: Icon(
                              Icons.view_agenda,
                              size: SizeConFig.screenWidth * 10 / 100,
                              color: useFun.changeColor
                                  ? Colors.black
                                  : Colors.blue,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: SizeConFig.screenHeight * 1 / 100),
                  Consumer<UserDashboardProvider>(
                    builder: (context, userFun2, child) {
                      return userFun2.changeColor
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // children: [
                              //   customBox("Attendance", context),
                              //   customBox(
                              //     "Project",
                              //     context,

                              //     UserAllProject(),
                              //   ),
                              //   customBox("Leave", context)
                              // ],
                              children: [
                                customBox(
                                  "Attendance",
                                  context,
                                  screenName: UserAttendanceScreen(),
                                  onTapCallback: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => UserAttendanceScreen(),
                                    ));
                                  },
                                ),
                                customBox(
                                  "Work Module",
                                  context,
                                  screenName: UserWorkModuleScreen(),
                                  onTapCallback: () async {
                                    // final provider =
                                    //     Provider.of<UserProjectProvider>(context,
                                    //         listen: false);
                                    // await provider.userAllProject(context);

                                    // Navigate only after data is fetched
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => UserWorkModuleScreen(),
                                    ));
                                  },
                                ),
                                customBox(
                                  "Leave",
                                  context,
                                  onTapCallback: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => LeavescreenUi(),
                                    ));
                                  },
                                ),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: SizeConFig.screenHeight * 1 / 100),
                  Consumer<UserDashboardProvider>(
                    builder: (context, use3, child) {
                      return use3.changeColor
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                customBox("Report", context),
                                customBox("To Do", context),
                                customBox("My chart", context),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: SizeConFig.screenHeight * 1 / 100),
                  Consumer<UserDashboardProvider>(
                    builder: (context, use3, child) {
                      return use3.changeColor
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                customBox("Instrument Libary", context),
                                customBox("Expenses", context),
                                customBox("High Priority", context),
                              ],
                            );
                    },
                  ),

                  SizedBox(height: SizeConFig.screenHeight * 1 / 100),

                  SizedBox(height: SizeConFig.screenHeight * 1 / 100),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.1 / 100,
                      color: Colors.black),
                  Consumer<UserProjectProvider>(
                    builder: (context, proj, child) {
                      if (proj.isloadingTask) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (proj.error != null) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(describeApiError(proj.error!)),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<UserProjectProvider>(context,
                                          listen: false)
                                      .fatchUserTask();
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      }

                      // Check if taskResponse or its data is null or empty
                      final tasks = proj.taskResponse?.data;
                      final bool hasTasks = tasks != null && tasks.isNotEmpty;

                      return Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: RefreshIndicator(
                            //backgroundColor:Colors.amber,
                            onRefresh: () async {
                              await Provider.of<UserProjectProvider>(context,
                                      listen: false)
                                  .fatchUserTask();
                            },
                            child: hasTasks
                                ? ListView.builder(
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final res = tasks[index];

                                      Color priorityColor;
                                      switch (res.taskPriorityStatus
                                          .toLowerCase()) {
                                        case "high":
                                          priorityColor = const Color.fromARGB(
                                              255, 219, 127, 120);
                                          break;
                                        case "medium":
                                          priorityColor = const Color.fromARGB(
                                              255, 245, 233, 215);
                                          break;
                                        default:
                                          priorityColor = Colors.green;
                                      }

                                      Color statusColor =
                                          res.taskStatus.toLowerCase() ==
                                                  "pending"
                                              ? Colors.orange
                                              : Colors.green;

                                      return ListTile(
                                        onTap: () {
                                          int projectUid =
                                              res.project.projectUid;
                                          int teamUid = res.team.teamUid;
                                          String teamName = res.team.teamName;

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProjectTeamScreen(
                                                projectUid: projectUid,
                                                teamUid: teamUid,
                                                teamName: teamName,
                                              ),
                                            ),
                                          );
                                        },
                                        title: Card(
                                          elevation: 2,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  res.taskName,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  res.project.projectName,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text("Allotment:",
                                                            style: TextStyle(
                                                                fontSize: 10)),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(res.allotmentDate,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10)),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                            "Completion:",
                                                            style: TextStyle(
                                                                fontSize: 10)),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(res.completionDate,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Chip(
                                                      label: Text(
                                                        "Priority: ${res.taskPriorityStatus}",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                priorityColor),
                                                      ),
                                                      backgroundColor:
                                                          priorityColor
                                                              .withOpacity(0.2),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 4),
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                    ),
                                                    Chip(
                                                      label: Text(
                                                        "Status: ${res.taskStatus}",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: statusColor),
                                                      ),
                                                      backgroundColor:
                                                          statusColor
                                                              .withOpacity(0.2),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 4),
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      const SizedBox(height: 80),
                                      const Icon(Icons.refresh,
                                          size: 40, color: Colors.grey),
                                      const SizedBox(height: 8),
                                      const Center(
                                        child: Text(
                                          "Refresh & Load Tasks",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Center(
                                        child: Text(
                                          "No tasks found",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ]),
        )),
      ),
    );
  }

  Widget customBox(
    String textMsg,
    BuildContext context, {
    Widget? screenName,
    VoidCallback? onTapCallback,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTapCallback != null) {
          onTapCallback();
        } else if (screenName != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => screenName),
          );
        } else {
          ShowTaostMessage.toastMessage(context, textMsg);
        }
      },
      child: Container(
        height: SizeConFig.screenHeight * 8 / 100,
        width: SizeConFig.screenWidth * 20 / 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 239, 211, 193),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 192, 212, 221),
        ),
        child: Center(
          child: Text(
            textMsg,
            textAlign: TextAlign.center,
            style: CustomText.nameOfTextStyle,
          ),
        ),
      ),
    );
  }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            // title: const Text("Thanks for  your effective work have a good day"),
            content: Container(
              height: MediaQuery.of(context).size.height * 5 / 100,
              width: 30,
              child: Center(
                child: const Text(
                  "Do you want to logout",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("No"),
                  ),
                ],
              )
            ],
          ),
        ) ??
        false;
  }

  Widget logoutAnimation() {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: Color(0xfffb934d),
        size: 50,
      ),
    );
  }

//  hey navendra  you can use this function to create a custom UI and text
  customUIandText(String s, String empName, Color colorName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          s,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: colorName),
        ),
        Text(
          empName,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: colorName),
        ),
      ],
    );
  }

  String describeApiError(ApiError error) {
    switch (error) {
      case ApiError.network:
        return "No internet connection.";
      case ApiError.timeout:
        return "Request timed out.";
      case ApiError.platform:
        return "Platform error.";
      case ApiError.client:
        return "Client error.";
      case ApiError.server:
        return "Server error.";
      case ApiError.jsonFormat:
        return "Invalid response format.";

      case ApiError.unknown:
      default:
        return "An unknown error occurred.";
    }
  }
}
