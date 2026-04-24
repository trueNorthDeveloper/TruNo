import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/view/user_create_task_by_team_leader.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/project_team_task.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/view/task_detail_screen.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/view/task_review_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/view/task_re_submit_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/view/task_completed_screen.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_task_response_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/controller/user_project_provider.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class UserProjectTeamScreen extends StatefulWidget {
  final String teamName;

  final int projectUid;
  final int teamUid;

  const UserProjectTeamScreen(
      {super.key,
      required this.teamName,
      required this.projectUid,
      required this.teamUid});
  @override
  State<UserProjectTeamScreen> createState() => _UserProjectTeamScreenState();
}

class _UserProjectTeamScreenState extends State<UserProjectTeamScreen> {
  late ScrollController _scrollController;
  //TODO
  // @override
  // void initState() {
  //   super.initState();

  //   getUserBySharedPreferenceId();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final provider = Provider.of<UserProjectProvider>(context, listen: false);
  //     provider.fatchTeamMember(widget.projectUid, widget.teamUid);
  //     // provider.fatchReviewTaskCon();
  //     provider.fatchAllTaskINTeamUsingPagination2(
  //         widget.projectUid, widget.teamUid);
  //   });
  //   _scrollController = ScrollController();
  //   _scrollController.addListener(_onScroll);
  // }
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    getUserBySharedPreferenceId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProjectProvider>(context, listen: false);

      /// 🔥 STEP 1: RESET OLD DATA (THIS IS MISSING IN YOUR CODE)
      provider.resetTaskState();

      /// 🔥 STEP 2: FETCH NEW DATA
      provider.fatchTeamMember(widget.projectUid, widget.teamUid);

      provider.fatchAllTaskINTeamUsingPagination2(
          widget.projectUid, widget.teamUid);
    });
  }

  // @override
  // void didUpdateWidget(covariant UserProjectTeamScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if (oldWidget.projectUid != widget.projectUid ||
  //       oldWidget.teamUid != widget.teamUid) {
  //     final provider = Provider.of<UserProjectProvider>(context, listen: false);

  //     provider.resetTaskState();

  //     provider.fatchAllTaskINTeamUsingPagination(
  //         widget.projectUid, widget.teamUid);
  //   }
  // }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent * 0.9) {
  //     if (!Provider.of<UserProjectProvider>(context, listen: false)
  //         .showAllTask) {
  //       // Load next page
  //       Provider.of<UserProjectProvider>(context, listen: false)
  //           .fatchAllTaskINTeamUsingPagination(
  //               widget.projectUid, widget.teamUid);
  //     }
  //   }
  // }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final provider = Provider.of<UserProjectProvider>(context, listen: false);

      if (!provider.showAllTask) {
        provider.fatchAllTaskINTeamUsingPagination(
            widget.projectUid, widget.teamUid);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int userUid = 0;
  Future<void> getUserBySharedPreferenceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId != null) {
      userUid = userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProjectProvider>(context, listen: true);

    // final teamProvider = Provider.of<UserProjectProvider>(context);

    // final Member? user = teamProvider.teamMemberInfo.isNotEmpty
    //     ? teamProvider.teamMemberInfo.firstWhere(
    //         (member) => member.userId == userUid,
    //         orElse: () => teamProvider.teamMemberInfo.first,
    //       )
    //     : null;

    //final isTeamLeader = user?.role == 'TEAMLEADER';
    final reviewTask = provider.taskReviewResponse?.data
            .where((submit) =>
                submit.submittedTo.submitToId == userUid &&
                submit.task.project.projectUid == widget.projectUid &&
                submit.task.team.teamUid == widget.teamUid &&
                submit.task.taskStatus == "UNDER_REVIEW")
            .toList() ??
        [];

    // final pending = provider.taskResponse2?.data
    //         .where((t) => t.taskStatus == "PENDING")
    //         .toList() ??
    //     [];
    // final resubmit = provider.taskResponse2?.data
    //         .where((t) => t.taskStatus == "RESUBMITTED")
    //         .toList() ??
    //     [];
    // final underReview = provider.taskResponse2?.data
    //         .where((t) => t.taskStatus == "UNDER_REVIEW")
    //         .toList() ??
    //     [];
    // final completed = provider.taskResponse2?.data
    //         .where((t) => t.taskStatus == "COMPLETED")
    //         .toList() ??
    //     [];

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.teamName),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//SHOW ALL TEAM MEMBER TOP OF THE SCREEN
//STEP:1
                buildProjectTeam(),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 100,
                ),
//for break line use container
                Container(
                    height: MediaQuery.of(context).size.height * 0.1 / 100,
                    color: Colors.black),
//for space use size box
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 100,
                ),
                //from here show all task of the team and project.. for review...............
                //if user has task for review it will otherwiser hide..............
                if (reviewTask.length > 0)
                  Row(
                    children: [
                      Text(
                        " Submission Tasks For Review: ${reviewTask.length}   ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),

                      ///task  Review.............................................................
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskReviewScreen(
                                      reviewTask: reviewTask)));
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 100,
                ),

                //USER HERE SHOW THERE CURRENT TASK OF THE TEAM AND PROJECT..................................
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 100,
                ),
                // Container(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [

                // InkWell(
                //     onTap: () {
                //       // provider.increaseCounter(0);
                //       Provider.of<UserProjectProvider>(context,
                //               listen: false)
                //           .increaseCounter(0);
                //     },
                //     child: Column(
                //       children: [
                //         _buildCounter(
                //             "PENDING", pending.length, Colors.orange),
                //         SizedBox(
                //           height: MediaQuery.of(context).size.height *
                //               0.7 /
                //               100,
                //         ),
                //         if (provider.counter == 0)
                //           buildLine(Colors.orange)
                //       ],
                //     )),
                // InkWell(
                //     onTap: () {
                //       // provider.increaseCounter(1);
                //       Provider.of<UserProjectProvider>(context,
                //               listen: false)
                //           .increaseCounter(1);
                //     },
                //     child: Column(
                //       children: [
                //         _buildCounter(
                //             "REVISION", resubmit.length, Colors.blue),
                //         SizedBox(
                //           height: MediaQuery.of(context).size.height *
                //               0.7 /
                //               100,
                //         ),
                //         if (provider.counter == 1) buildLine(Colors.blue)
                //       ],
                //     )),
                // InkWell(
                //   onTap: () {
                //     // provider.increaseCounter(2);
                //     Provider.of<UserProjectProvider>(context,
                //             listen: false)
                //         .increaseCounter(2);
                //   },
                //   child: Column(
                //     children: [
                //       _buildCounter("UNDER-REVIEW", underReview.length,
                //           Colors.purple),
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height *
                //             0.7 /
                //             100,
                //       ),
                //       if (provider.counter == 2) buildLine(Colors.purple)
                //     ],
                //   ),
                // ),
                // InkWell(
                //     onTap: () {
                //       //  provider.increaseCounter(3);
                //       Provider.of<UserProjectProvider>(context,
                //               listen: false)
                //           .increaseCounter(3);
                //     },
                //     child: Column(
                //       children: [
                //         _buildCounter(
                //             "COMPLETED", completed.length, Colors.green),
                //         SizedBox(
                //           height: MediaQuery.of(context).size.height *
                //               0.7 /
                //               100,
                //         ),
                //         if (provider.counter == 3) buildLine(Colors.green)
                //       ],
                //     )),
                //     ],
                //   ),
                // ),
//show pending revision underReview and completed with number.....
                Container(
                  child: Consumer<UserProjectProvider>(
                    builder: (context, pro, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInkWell(
                              0, "PENDING", pro.pendingTask.length, pro),
                          _buildInkWell(
                              1, "REVISION", pro.resubmit.length, pro),
                          _buildInkWell(
                              2, "UNDER-REVIEW", pro.underReview.length, pro),
                          _buildInkWell(
                              3, "COMPLETED", pro.completed.length, pro),
                        ],
                      );
                    },
                  ),
                ),

                // if (provider.counter == 0) _buildlistOfTask(pending, "pending"),
                // //FATCH ALL TASK HERE.......................
                // if (provider.counter == 1)
                //   _buildlistOfTask(resubmit, "resubmit"),
                // if (provider.counter == 2)
                //   _buildlistOfTask(underReview, "underReview"),
                // if (provider.counter == 3)
                //   _buildlistOfTask(completed, "completed"),
//ON CLICK SHOW TASK BASED ON THIER BEHAVIOUR
                // Consumer<UserProjectProvider>(builder: (context, pros, child) {
                //   if (pros.counter == 0) {
                //     return _buildlistOfTask2(pros.pendingTask, "pending", pros);
                //   }
                //   if (pros.counter == 1) {
                //     return _buildlistOfTask2(pros.resubmit, "resubmit", pros);
                //   }
                //   if (pros.counter == 2) {
                //     return _buildlistOfTask2(
                //         pros.underReview, "underReview", pros);
                //   }
                //   if (pros.counter == 3) {
                //     return _buildlistOfTask2(pros.completed, "completed", pros);
                //   }
                //   return SizedBox();
                // }),
                //using pagination here...............................
                // Consumer<UserProjectProvider>(
                //   builder: (context, prov, child) {
                //     if (prov.counter == 0) {
                //       return ConstrainedBox(
                //           constraints: BoxConstraints(
                //               maxHeight: 600), // Maximum specific size

                //           child: Column(
                //             children: [
                //               Container(
                //                 decoration: BoxDecoration(color: Colors.amber),
                //               )
                //             ],
                //           ));
                //     }
                //     return SizedBox();
                //   },
                // )
                RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<UserProjectProvider>(context,
                            listen: false)
                        .fatchAllTaskINTeamUsingPagination(
                            widget.projectUid, widget.teamUid,
                            isRefresh: true);
                  },
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 600),
                      child: Consumer<UserProjectProvider>(
                          builder: (context, pro, child) {
                        // if (pro.showAllTask && pro.counter == 0) {
                        //   return Center(child: CircularProgressIndicator());
                        // }
                        List<AllTask> activeList;
                        String name = "";
                        switch (pro.counter) {
                          case 0:
                            activeList = pro.pendingTask;
                            name = "pending";
                            break;
                          case 1:
                            activeList = pro.resubmit;
                            name = "resubmit";
                            break;
                          case 2:
                            activeList = pro.underReview;
                            name = "underReview";
                            break;
                          case 3:
                            activeList = pro.completed;
                            name = "completed";
                            break;
                          default:
                            activeList = [];
                        }
                        if (pro.showAllTask && activeList.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (activeList.isEmpty && !pro.showAllTask) {
                          return const Center(
                              child: Text("No tasks found in this category"));
                        }
                        return buildListView(activeList, pro, name);
                      }

                          // if (pro.counter == 0) {
                          //   return buildListView(pro.pendingTask, pro);
                          // }
                          // if (pro.counter == 1) {
                          //   return buildListView(pro.resubmit, pro);
                          // }
                          // if (pro.counter == 2) {
                          //   return buildListView(pro.underReview, pro);
                          // }
                          // if (pro.counter == 3) {
                          //   return buildListView(pro.completed, pro);
                          // }
                          // return SizedBox(
                          //   child: Text("No task found"),
                          // );

                          )),
                )
              ],
            ),
          ),
        ),
//IF YOU WANT REMOVE THIS CODE YOU CAN BCZ ITS OLD FUNCATIONS
        // floatingActionButton: isTeamLeader
        //     ? FloatingActionButton(
        //         onPressed: () {
        //           if (user != null) {
        //             final teamMembers =
        //                 Provider.of<UserProjectProvider>(context, listen: false)
        //                     .teamMemberInfo;

        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => CreateTaskByTeamLeader(
        //                       leaderDetail: user,
        //                       teamMember: teamMembers,
        //                       projectId: widget.projectUid,
        //                       teamId: widget.teamUid),
        //                 ));
        //           }
        //         },
        //         child: Icon(Icons.create),
        //       )
        //     : null
        //------------------------
        floatingActionButton: Consumer<UserProjectProvider>(
          builder: (context, pro, child) {
            if (pro.isTeamLeaderTrue) {
              return FloatingActionButton(
                onPressed: () {
                  if (pro.member != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTaskByTeamLeader(
                              leaderDetail: pro.member!,
                              teamMember: pro.teamMemberInfo,
                              projectId: widget.projectUid,
                              teamId: widget.teamUid),
                        ));
                  }
                },
                child: Icon(Icons.create),
              );
            }
            return SizedBox();
          },
        ));
  }

  Widget buildListView(
      List<AllTask> data, UserProjectProvider provider, String name) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: data.length + (provider.showAllTask ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == data.length) return CircularProgressIndicator();
        final tasks = data[index];
        Color priorityColor;
        Color statusColor;

        switch (tasks.taskPriorityStatus!.toLowerCase()) {
          case "high":
            priorityColor = const Color.fromARGB(255, 219, 193, 120);
            break;
          case "medium":
            priorityColor = const Color.fromARGB(255, 245, 233, 215);
            break;
          default:
            priorityColor = Colors.green;
            break;
        }

        switch (tasks.taskStatus!.toLowerCase()) {
          case "pending":
            statusColor = Colors.red;
            break;
          case "in_progress":
            statusColor = Colors.orange;
            break;
          case "completed":
            statusColor = Colors.green;
            break;
          case "underReview":
            statusColor = Colors.blue;
            break;
          default:
            statusColor = Colors.red;
            break;
        }

        return SizedBox(
            height: MediaQuery.of(context).size.height * 11 / 100,
            child: ListTile(
                onTap: () {
                  switch (name) {
                    case "pending":
                      //pemnding screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                  task: tasks,
                                  members: provider.teamMemberInfo)));

                      break;
                    case "resubmit":
                      //switch to resubmit screen after revision task
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ResubmitScreen(taskId: tasks.taskId!)));
                      break;
                    case "underReview":
                      //switch to underreview screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TaskCompletedScreen(taskId: tasks.taskId!)));
                      print("under review task");
                      break;
                    case "completed":
                      //switch to completed screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TaskCompletedScreen(taskId: tasks.taskId!)));
                      break;
                    default:
                      break;
                  }
                },
                title: Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            tasks.taskName!,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          buildRowText(
                              "projectName", tasks.project!.projectName),
                          SizedBox(height: 2),
                          buildRowText("Allotment:${tasks.allotmentDate!}",
                              "completion:${tasks.completionDate!}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildStatus(
                                  "priority:${tasks.taskPriorityStatus}",
                                  priorityColor,
                                  priorityColor),
                              buildStatus("status:${tasks.taskStatus}",
                                  priorityColor, statusColor),
                            ],
                          )
                        ])))));
      },
    );
  }

  Widget buildStatus(String text, Color priority, Color statusColors) {
    return Chip(
      label: Text(text, style: TextStyle(fontSize: 10, color: statusColors)),
      backgroundColor:
          // ignore: deprecated_member_use
          priority.withOpacity(0.2),
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget buildRowText(String name, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTextFiled(name),
        buildTextFiled(data),
      ],
    );
  }

  Widget buildTextFiled(String text) {
    return Text(
      "$text",
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildInkWell(
      int count, String text, int length, UserProjectProvider pr) {
    return InkWell(
      onTap: () {
        pr.increaseCounter(count);
        //  _scrollController.jumpTo(0);
      },
      child: Column(
        children: [
          _buildCounter(text, length, Colors.orange),
          SizedBox(height: 5),

          /// ✅ Active tab indicator
          if (pr.counter == count) buildLine(Colors.green),
        ],
      ),
    );
  }
  // Widget _buildInkWell(
  //     int count, String text, int length, UserProjectProvider pr) {
  //   return InkWell(
  //       onTap: () {
  //         pr.increaseCounter(count);
  //       },
  //       child: Column(
  //         children: [
  //           _buildCounter(text, length, Colors.orange),
  //           SizedBox(
  //             height: MediaQuery.of(context).size.height * 0.7 / 100,
  //           ),
  //           if (pr.counter == count) buildLine(Colors.green)
  //         ],
  //       ));
  // }

  Widget _buildCounter(String title, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            "$count",
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Text(title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
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

//crate line
  Widget buildLine(Color color) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1 / 100,
        width: MediaQuery.of(context).size.width * 15 / 100,
        color: color);
  }

  Widget _buildlistOfTask(List<Task> taskdata, String name) {
    if (taskdata.isEmpty) {
      return Center(
        child: Text("${name} Task"),
      );
    }
    return Column(
      children: [
        Consumer<UserProjectProvider>(
          builder: (context, value, child) {
            if (value.isLoadingAllTak) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (value.error != null) {
              return Center(
                child: Text(describeApiError(value.error!)),
              );
            }
            if (value.taskResponse2 == null) {
              return const Center(
                child: Text("No task found"),
              );
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 50 / 100,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: taskdata.length,
                itemBuilder: (context, index) {
                  final tasks = taskdata[index];
                  Color priorityColor;
                  Color statusColor;

                  switch (tasks.taskPriorityStatus.toLowerCase()) {
                    case "high":
                      priorityColor = const Color.fromARGB(255, 219, 193, 120);
                      break;
                    case "medium":
                      priorityColor = const Color.fromARGB(255, 245, 233, 215);
                      break;
                    default:
                      priorityColor = Colors.green;
                      break;
                  }

                  switch (tasks.taskStatus.toLowerCase()) {
                    case "pending":
                      statusColor = Colors.red;
                      break;
                    case "in_progress":
                      statusColor = Colors.orange;
                      break;
                    case "completed":
                      statusColor = Colors.green;
                      break;
                    case "underReview":
                      statusColor = Colors.blue;
                      break;
                    default:
                      statusColor = Colors.red;
                      break;
                  }

                  return ListTile(
                    onTap: () {
                      // final teamMember = Provider.of<UserProjectProvider>(
                      //         context,
                      //         listen: false)
                      //     .teamResponse!
                      //     .data
                      //     .expand((team) => team.members)
                      //     .toList();

                      switch (name) {
                        case "pending":
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => TaskDetailScreen(
                          //             task: tasks, members: teamMember)));
                          break;
                        case "resubmit":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResubmitScreen(taskId: tasks.taskId)));
                          break;
                        case "underReview":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskCompletedScreen(
                                      taskId: tasks.taskId)));
                          print("under review task");
                          break;
                        case "completed":
                          // final completed =
                          //     value.taskReviewResponse?.data ?? [];
                          // print(tasks.taskId);
                          // print(completed.length);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskCompletedScreen(
                                      taskId: tasks.taskId)));
                          break;
                        default:
                          break;
                      }

                      // if (name == "pending") {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               TaskDetailScreen(task: task)));
                      // }
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             TaskDetailScreen(task: task)));
                    },
                    title: Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              tasks.taskName,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "projectName",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  tasks.project.projectName,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Allotment:",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tasks.allotmentDate,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Text(
                                      "Completion:",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tasks.completionDate,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(
                                      "Priority:${tasks.taskPriorityStatus}",
                                      style: TextStyle(
                                          fontSize: 10, color: priorityColor)),
                                  backgroundColor:
                                      // ignore: deprecated_member_use
                                      priorityColor.withOpacity(0.2),
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 0, vertical: 4),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Chip(
                                  label: Text("Status:${tasks.taskStatus}",
                                      style: TextStyle(
                                          fontSize: 10, color: statusColor)),
                                  // ignore: deprecated_member_use
                                  backgroundColor: statusColor.withOpacity(0.2),
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 0, vertical: 4),
                                  visualDensity: VisualDensity.compact,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

//show team member
  Widget buildProjectTeam() {
    return Consumer<UserProjectProvider>(
      builder: (context, pro, child) {
        if (pro.isTeamMember) {
          return const Center(child: CircularProgressIndicator());
        }

        if (pro.error != null) {
          return Center(child: Text(describeApiError(pro.error!)));
        }

        final members = pro.teamMemberInfo;

        if (members.isEmpty) {
          return const Center(
            child: Text("No members found", style: TextStyle(fontSize: 14)),
          );
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final mem = members[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue[100 * ((index % 8) + 1)],
                          child: Text(
                            mem.memberName.isNotEmpty
                                ? mem.memberName[0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mem.memberName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          mem.role,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildlistOfTask2(
      List<AllTask> taskdata, String name, UserProjectProvider provider) {
    if (taskdata.isEmpty) {
      return Center(
        child: Text("${name} Task"),
      );
    }
    return Column(
      children: [
        Consumer<UserProjectProvider>(
          builder: (context, value, child) {
            if (value.showAllTask) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (value.error != null) {
              return Center(
                child: Text(describeApiError(value.error!)),
              );
            }

            return SizedBox(
                height: MediaQuery.of(context).size.height * 50 / 100,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: taskdata.length + (provider.showAllTask ? 1 : 0),
                  itemBuilder: (context, index) {
                    // if (index == provider.listOfAllTask.length) {
                    //   return const Padding(
                    //     padding: EdgeInsets.all(16),
                    //     child: Center(child: CircularProgressIndicator()),
                    //   );
                    // }
                    final tasks = taskdata[index];
                    Color priorityColor;
                    Color statusColor;

                    switch (tasks.taskPriorityStatus!.toLowerCase()) {
                      case "high":
                        priorityColor =
                            const Color.fromARGB(255, 219, 193, 120);
                        break;
                      case "medium":
                        priorityColor =
                            const Color.fromARGB(255, 245, 233, 215);
                        break;
                      default:
                        priorityColor = Colors.green;
                        break;
                    }

                    switch (tasks.taskStatus!.toLowerCase()) {
                      case "pending":
                        statusColor = Colors.red;
                        break;
                      case "in_progress":
                        statusColor = Colors.orange;
                        break;
                      case "completed":
                        statusColor = Colors.green;
                        break;
                      case "underReview":
                        statusColor = Colors.blue;
                        break;
                      default:
                        statusColor = Colors.red;
                        break;
                    }

                    return ListTile(
                      onTap: () {
                        // final teamMember = Provider.of<UserProjectProvider>(
                        //         context,
                        //         listen: false)
                        //     .teamResponse!
                        //     .data
                        //     .expand((team) => team.members)
                        //     .toList();

                        switch (name) {
                          case "pending":
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => TaskDetailScreen(
                            //             task: tasks, members: teamMember)));
                            break;
                          case "resubmit":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResubmitScreen(taskId: tasks.taskId!)));
                            break;
                          case "underReview":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskCompletedScreen(
                                        taskId: tasks.taskId!)));
                            print("under review task");
                            break;
                          case "completed":
                            // final completed =
                            //     value.taskReviewResponse?.data ?? [];
                            // print(tasks.taskId);
                            // print(completed.length);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskCompletedScreen(
                                        taskId: tasks.taskId!)));
                            break;
                          default:
                            break;
                        }

                        // if (name == "pending") {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               TaskDetailScreen(task: task)));
                        // }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             TaskDetailScreen(task: task)));
                      },
                      title: Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                tasks.taskName!,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "projectName",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    tasks.project!.projectName,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Allotment:",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        tasks.allotmentDate!,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Text(
                                        "Completion:",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        tasks.completionDate!,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text(
                                        "Priority:${tasks.taskPriorityStatus}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: priorityColor)),
                                    backgroundColor:
                                        // ignore: deprecated_member_use
                                        priorityColor.withOpacity(0.2),
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 0, vertical: 4),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Chip(
                                    label: Text("Status:${tasks.taskStatus}",
                                        style: TextStyle(
                                            fontSize: 10, color: statusColor)),
                                    // ignore: deprecated_member_use
                                    backgroundColor:
                                        // ignore: deprecated_member_use
                                        statusColor.withOpacity(0.2),
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 0, vertical: 4),
                                    visualDensity: VisualDensity.compact,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ));
          },
        ),
      ],
    );
  }
}
