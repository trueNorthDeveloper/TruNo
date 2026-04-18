import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/controller/login_provider.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/controller/user_project_provider.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/view/createTaskScreen.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/view/teamLeader_project_review_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/view/project_team_and_task_screen.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';


class UserWorkModuleScreen extends StatefulWidget {
  const UserWorkModuleScreen({super.key});

  @override
  State<UserWorkModuleScreen> createState() => _UserWorkModuleScreenState();
}

class _UserWorkModuleScreenState extends State<UserWorkModuleScreen> {
 

  @override
  void initState() {
    super.initState();
    context.read<LoginControll>().userRole();
    Future.microtask(() =>
        Provider.of<UserProjectProvider>(context, listen: false)
            .fatchAllProjectType());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: SizeConFig.screenHeight * 0.05,
        ),
        Container(
          height: SizeConFig.screenHeight * 0.07,

          //work header text start.....................................
          child: Row(
            children: [
              // Back button area
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    "Work Module",
                    style: TextStyle(
                      fontSize: SizeConFig.screenHeight * 0.02,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Expanded(child: SizedBox()),
            ],
          ),
        ),
        SizedBox(
          height: SizeConFig.screenHeight * 70 / 100,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Consumer<UserProjectProvider>(
              builder: (context, provider, child) {
                // ---------- MAIN LOADING ----------
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ---------- ERROR ----------
                if (provider.error != null) {
                  return Center(
                    child: Column(
                      children: [
                        Text(describeApiError(provider.error!)),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<UserProjectProvider>(context,
                                      listen: false)
                                  .fatchAllProjectType();
                            },
                            child: Text("Retry"))
                      ],
                    ),
                  );
                }

                // ---------- NO PROJECT TYPE ----------
                if (provider.projectType == null) {
                  return const Center(
                      child: Text("No Project Type Available."));
                }

                final project = provider.projectType!.data;
                final hasProject = project != null && project.isNotEmpty;

                return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<UserProjectProvider>(context,
                            listen: false)
                        .fatchAllProjectType();
                  },
                  child: hasProject
                      ? ListView.builder(
                          itemCount: provider.projectType!.data!.length,
                          itemBuilder: (context, index) {
                            final type = provider.projectType!.data![index];
                            final typeUid = type.tnecProjectTypeUid;

                            return Card(
                              child: Column(
                                children: [
                                  // ---------------- HEADER ----------------
                                  InkWell(
                                    onTap: () {
                                      provider.toggleExpand(index);

                                      // Load projects when first tapped
                                      if (!provider.userProjects
                                          .containsKey(typeUid)) {
                                        provider.fatchAllProjects(typeUid);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${index + 1}.  ", // SERIAL NUMBER
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                type.tnecProjectTypeName,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            provider.expandedIndex == index
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 28,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // ---------------- EXPANDED SECTION ----------------
                                  if (provider.expandedIndex == index)
                                    Builder(builder: (_) {
                                      // 1️⃣ If data not loaded yet → show loading
                                      if (!provider.userProjects
                                          .containsKey(typeUid)) {
                                        return const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      // 2️⃣ Null safety check
                                      final projectList =
                                          provider.userProjects[typeUid]?.data;
                                      if (projectList == null) {
                                        return const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("No projects found."),
                                        );
                                      }

                                      // 3️⃣ Show project list
                                      return Column(
                                        children:
                                            //   projectList.map((userProject) {
                                            // final projectUid =
                                            //     userProject.tnecProjectUid;
                                            projectList
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                          final projectIndex = entry.key;
                                          final userProject = entry.value;
                                          final projectUid =
                                              userProject.tnecProjectUid;
                                              String projectName=userProject.tnecProjectName;
                                          //  final bool isTeamLeader = true;
                                          bool isTeamLeader = context
                                              .read<LoginControll>()
                                              .isRole;
                                          // final int pendingTasks = userProject.pendingTaskCount ?? 0;
                                          // Future.microtask(() =>
                                          //     Provider.of<UserProjectProvider>(
                                          //             context,
                                          //             listen: false)
                                          //         .fatchAllTaskInTeam(
                                          //             projectUid, 1));

                                          final int pendingTasks = 7;
                                          return ExpansionTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      SizeConFig.screenWidth *
                                                          30 /
                                                          100,
                                                  child: Text(
                                                    "${projectIndex + 1}. ${userProject.tnecProjectName}",
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      decorationThickness: 2.5,
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .wavy,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                                // TEAM LEADER BUTTON
                                                if (isTeamLeader)
                                                  //TEAM LEADER PROJECT OVERVIEW AND TASK REVIEW..........................
                                                  teamLeaderView(projectUid,projectName),

                                                //PENDINF TASK CONTAINER BASED ON USER AND TEAMlEADER..............
                                                pendingContainerBuild(
                                                    pendingTasks, isTeamLeader)
                                              ],
                                            ),

                                            // When expand → load team
                                            onExpansionChanged: (expanded) {
                                              if (expanded &&
                                                  !provider.projectTeams
                                                      .containsKey(
                                                          projectUid)) {
                                                provider.fatchProjectTeam(
                                                    projectUid);
                                              }
                                            },

                                            children: [
                                              if (provider.isLoadingTeams[
                                                      projectUid] ==
                                                  true)
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              else if (provider.projectTeams
                                                  .containsKey(projectUid))
                                                ...provider
                                                    .projectTeams[projectUid]!
                                                    .data
                                                    .map((team) {
                                                  return ListTile(
                                                      title: Text(
                                                        team.teamName,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 16),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserProjectTeamScreen(
                                                              teamName:
                                                                  team.teamName,
                                                              projectUid:
                                                                  projectUid,
                                                              teamUid:
                                                                  team.teamUid,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                })
                                              else
                                                const ListTile(
                                                  title:
                                                      Text("No teams found."),
                                                )
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }),
                                ],
                              ),
                            );
                          })
                      : ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            const Icon(Icons.refresh,
                                size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            const Center(
                              child: Text(
                                "Refresh & Load Tasks",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                "No tasks found",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ),
        //this for team leader................................................
        Consumer<LoginControll>(
          builder: (context, iampro, child) {
            return iampro.isRole
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          child: ElevatedButton.icon(
                        onPressed: () {
                          // print(iampro.user?.role);
                          //final role = TokenService.getUserRole();
                          //print(role);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Createtaskscreen(),
                              ));
                        },
                        label: Text("Create Task"),
                        icon: Icon(Icons.add_task),
                      )),
                    ],
                  )
                : SizedBox();
          },
        ),
      ],
    ));
  }

//TEAM LEADER VIEW FOR PROJECT OVERVIEW...........
  Widget teamLeaderView(int projectUid, String projectName) {
    return Stack(children: [
      InkWell(
        onTap: () {
          //here we navigate project over page................
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamleaderProjectReviewScreen(projectName:projectName),
            ),
          );

         // print("project overview${projectUid}");
        },
        child: Container(
          height: SizeConFig.screenHeight * 3 / 100,
          width: SizeConFig.screenWidth * 30 / 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 228, 225, 225)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overview",
                style: TextStyle(
                    fontSize: 10,
                    color: const Color.fromARGB(255, 16, 225, 23)),
              ),
              Text(
                "Review=${1}",
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0, // Position at the very top of the Stack
        child: Icon(
          Icons.arrow_upward, // Choose your desired arrow icon
          color: Colors.black,
          size: 20,
        ),
      ),
      Positioned(
          top: 18,
          right: 0, // Position at the very top of the Stack
          child: Text(
            "On Tap",
            style: TextStyle(
                fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w800),
          ))
    ]);
  }

//PENDING TASK CONTAINER FOR USER.........................
  Widget pendingContainerBuild(int pendingTasks, bool isTeamLeader) {
    return Container(
      height: SizeConFig.screenHeight * 2 / 100,
      width: isTeamLeader == true
          ? SizeConFig.screenWidth * 15 / 100
          : SizeConFig.screenWidth * 30 / 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 134, 134),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "pending=${pendingTasks}",
          style: TextStyle(
            color: Colors.white,
            fontSize: isTeamLeader ? 8 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
//REUSED SIZE BOX....................

  Widget buildSizeBox(int screenHeight, int screenwidth) {
    return SizedBox(
      height: SizeConFig.screenHeight * screenHeight / 100,
      width: SizeConFig.screenWidth * screenwidth / 100,
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
//  SizedBox(
//             height: SizeConFig.screenHeight * 70 / 100,
//             child: Container(
//               //   decoration: BoxDecoration(color: Colors.amber),
//               child: Padding(
//                 padding: EdgeInsets.all(5.0),
//                 child: Consumer<UserProjectProvider>(
//                   builder: (context, provider, child) {
//                     //IT WILL LOAD PROJECT ...................................
//                     if (provider.isLoading) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     //AGAIN    get project on  click button................
//                     if (provider.error != null) {
//                       return Center(
//                         child: Column(
//                           children: [
//                             Text(describeApiError(provider.error!)),
//                             ElevatedButton(
//                                 onPressed: () {
//                                   Provider.of<UserProjectProvider>(context,
//                                           listen: false)
//                                       .fatchAllProjectType();
//                                 },
//                                 child: Text("Retry"))
//                           ],
//                         ),
//                       );
//                     }
//                     // here show error
//                     if (provider.projectType == null) {
//                       return const Center(
//                         child: Text("No Project Type Available."),
//                       );
//                     }
//                     final project = provider.projectType!.data;
//                     final hasProject = project != null && project.isNotEmpty;
//                     return Center(
//                         child: RefreshIndicator(
//                             onRefresh: () async {
//                               await Provider.of<UserProjectProvider>(context,
//                                       listen: false)
//                                   .fatchAllProjectType();
//                             },
//                             child: hasProject
//                                 ? ListView.builder(
//                                     itemCount:
//                                         provider.projectType!.data!.length,
//                                     itemBuilder: (context, index) {
//                                       final type =
//                                           provider.projectType!.data![index];
//                                       final typeUid = type.tnecProjectTypeUid;

//                                       return Card(
//                                         child: Column(
//                                           children: [
//                                             // ---------- HEADER (TITLE + ICON) ----------
//                                             InkWell(
//                                               onTap: () {
//                                                 Provider.of<UserProjectProvider>(
//                                                         context,
//                                                         listen: false)
//                                                     .toggleExpand(index);
//                                               },
//                                               child: Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 12,
//                                                     vertical: 10),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       type.tnecProjectTypeName,
//                                                       style: const TextStyle(
//                                                         fontSize: 13,
//                                                         fontWeight:
//                                                             FontWeight.w800,
//                                                       ),
//                                                     ),

//                                                     /// CHANGE ICON BASED ON SELECTED INDEX
//                                                     Icon(
//                                                       provider.expandedIndex ==
//                                                               index
//                                                           ? Icons.arrow_drop_up
//                                                           : Icons
//                                                               .arrow_drop_down,
//                                                       size: 28,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),

//                                             // ---------- EXPANDED CONTENT ----------
//                                             if (provider.expandedIndex == index)
//                                               Column(
//                                                 children: provider
//                                                     .userProjects[typeUid]!
//                                                     .data!
//                                                     .map((userProject) {
//                                                   final projectUid = userProject
//                                                       .tnecProjectUid;

//                                                   final bool isTeamLeader =
//                                                       true;
//                                                   //here will we fatch new pending task of user.........................
//                                                   // Provider.of<UserProjectProvider>(
//                                                   //         context,
//                                                   //         listen: false)
//                                                   //     .fatchAllTaskInTeam(
//                                                   //         projectUid, 2);
//                                                  // provider.fatchAllTaskInTeam(projectUid,2);
//                                                   return ExpansionTile(
//                                                     title: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         // Project Name
//                                                         SizedBox(
//                                                           width: SizeConFig
//                                                                   .screenWidth *
//                                                               40 /
//                                                               100,
//                                                           child: Text(
//                                                             userProject
//                                                                 .tnecProjectName,
//                                                             style:
//                                                                 const TextStyle(
//                                                               decorationThickness:
//                                                                   2.5,
//                                                               decorationStyle:
//                                                                   TextDecorationStyle
//                                                                       .wavy,
//                                                               fontSize: 12,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                             ),
//                                                           ),
//                                                         ),

//                                                         // TEAM LEADER BUTTON (only shows for team leader)
//                                                         if (isTeamLeader)
//                                                           Container(
//                                                             height: SizeConFig
//                                                                     .screenHeight *
//                                                                 2 /
//                                                                 100,
//                                                             width: SizeConFig
//                                                                     .screenWidth *
//                                                                 30 /
//                                                                 100,
//                                                             child:
//                                                                 ElevatedButton
//                                                                     .icon(
//                                                               onPressed: () {
//                                                                 //here we will navigator project details
//                                                                 print(
//                                                                     projectUid);
//                                                               },
//                                                               label: Text(
//                                                                   "Overview"),
//                                                               icon: const Icon(
//                                                                   Icons
//                                                                       .analytics),
//                                                             ),
//                                                           ),
//                                                         SizedBox(
//                                                           child: Text("1"),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     onExpansionChanged:
//                                                         (expanded) {
//                                                       if (expanded &&
//                                                           !provider.projectTeams
//                                                               .containsKey(
//                                                                   projectUid)) {
//                                                         provider
//                                                             .fatchProjectTeam(
//                                                                 projectUid);
//                                                       }
//                                                     },
//                                                     children: [
//                                                       if (provider.isLoadingTeams[
//                                                               projectUid] ==
//                                                           true)
//                                                         const Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   8.0),
//                                                           child:
//                                                               CircularProgressIndicator(),
//                                                         )
//                                                       else if (provider
//                                                           .projectTeams
//                                                           .containsKey(
//                                                               projectUid))
//                                                         ...provider
//                                                             .projectTeams[
//                                                                 projectUid]!
//                                                             .data
//                                                             .map((team) {
//                                                           return ListTile(
//                                                               title: Text(
//                                                                 team.teamName,
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         12,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600),
//                                                               ),
//                                                               trailing: const Icon(
//                                                                   Icons
//                                                                       .arrow_forward_ios,
//                                                                   size: 16),
//                                                               onTap: () {
//                                                                 Navigator.push(
//                                                                   context,
//                                                                   MaterialPageRoute(
//                                                                       builder:
//                                                                           (context) =>
//                                                                               UserProjectTeamScreen(
//                                                                                 teamName: team.teamName,
//                                                                                 projectUid: projectUid,
//                                                                                 teamUid: team.teamUid,
//                                                                               )),
//                                                                 );
//                                                               });
//                                                         })
//                                                       else
//                                                         const ListTile(
//                                                           title: Text(
//                                                               "No teams found."),
//                                                         )
//                                                     ],
//                                                   );
//                                                 }).toList(),
//                                               )
//                                           ],
//                                         ),
//                                       );
//                                     })
//                                 : ListView(
//                                     physics: AlwaysScrollableScrollPhysics(),
//                                     children: [
//                                         const SizedBox(height: 80),
//                                         const Icon(Icons.refresh,
//                                             size: 40, color: Colors.grey),
//                                         const SizedBox(height: 8),
//                                         const Center(
//                                           child: Text(
//                                             "Refresh & Load Tasks",
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.grey),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 20),
//                                         const Center(
//                                           child: Text(
//                                             "No tasks found",
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                         ),
//                                       ])));
//                   },
//                 ),
//               ),
//             )),
