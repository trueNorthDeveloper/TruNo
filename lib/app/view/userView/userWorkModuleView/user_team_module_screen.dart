import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_all_task_review_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_create_task_by_team_leader.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_re_submit_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_task_completed_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_task_detail_screen.dart';

import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/team_members_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_response_model.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';
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
  @override
  void initState() {
    super.initState();

    getUserBySharedPreferenceId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProjectProvider>(context, listen: false);

      provider.fatchAllTaskInTeam(widget.projectUid, widget.teamUid);
      provider.fatchTeamMember(widget.projectUid, widget.teamUid);
      provider.fatchReviewTaskCon();
    });
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

    final teamProvider = Provider.of<UserProjectProvider>(context);

    final Member? user = teamProvider.teamMemberInfo.isNotEmpty
        ? teamProvider.teamMemberInfo.firstWhere(
            (member) => member.userId == userUid,
            orElse: () => teamProvider.teamMemberInfo.first,
          )
        : null;

    final isTeamLeader = user?.role == 'TEAMLEADER';
    final reviewTask = provider.taskReviewResponse?.data
            .where((submit) =>
                submit.submittedTo.submitToId == userUid &&
                submit.task.project.projectUid == widget.projectUid &&
                submit.task.team.teamUid == widget.teamUid &&
                submit.task.taskStatus == "UNDER_REVIEW")
            .toList() ??
        [];

    final pending = provider.taskResponse2?.data
            .where((t) => t.taskStatus == "PENDING")
            .toList() ??
        [];
    final resubmit = provider.taskResponse2?.data
            .where((t) => t.taskStatus == "RESUBMITTED")
            .toList() ??
        [];
    final underReview = provider.taskResponse2?.data
            .where((t) => t.taskStatus == "UNDER_REVIEW")
            .toList() ??
        [];
    final completed = provider.taskResponse2?.data
            .where((t) => t.taskStatus == "COMPLETED")
            .toList() ??
        [];

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
                //show all team member......................
                Consumer<UserProjectProvider>(
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
                        child: Text("No members found",
                            style: TextStyle(fontSize: 14)),
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
                                      backgroundColor:
                                          Colors.blue[100 * ((index % 8) + 1)],
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
                ),
                //end team member----------------------------------------------

                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 100,
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.1 / 100,
                    color: Colors.black),
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            provider.increaseCounter(0);
                          },
                          child: Column(
                            children: [
                              _buildCounter(
                                  "PENDING", pending.length, Colors.orange),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.7 /
                                    100,
                              ),
                              if (provider.counter == 0)
                                buildLine(Colors.orange)
                            ],
                          )),
                      InkWell(
                          onTap: () {
                            provider.increaseCounter(1);
                          },
                          child: Column(
                            children: [
                              _buildCounter(
                                  "REVISION", resubmit.length, Colors.blue),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.7 /
                                    100,
                              ),
                              if (provider.counter == 1) buildLine(Colors.blue)
                            ],
                          )),
                      InkWell(
                        onTap: () {
                          provider.increaseCounter(2);
                        },
                        child: Column(
                          children: [
                            _buildCounter("UNDER-REVIEW", underReview.length,
                                Colors.purple),
                            SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.7 /
                                  100,
                            ),
                            if (provider.counter == 2) buildLine(Colors.purple)
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            provider.increaseCounter(3);
                          },
                          child: Column(
                            children: [
                              _buildCounter(
                                  "COMPLETED", completed.length, Colors.green),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.7 /
                                    100,
                              ),
                              if (provider.counter == 3) buildLine(Colors.green)
                            ],
                          )),
                    ],
                  ),
                ),

                if (provider.counter == 0) _buildlistOfTask(pending, "pending"),
                //FATCH ALL TASK HERE.......................
                if (provider.counter == 1)
                  _buildlistOfTask(resubmit, "resubmit"),
                if (provider.counter == 2)
                  _buildlistOfTask(underReview, "underReview"),
                if (provider.counter == 3)
                  _buildlistOfTask(completed, "completed"),
              ],
            ),
          ),
        ),
        floatingActionButton: isTeamLeader
            ? FloatingActionButton(
                onPressed: () {
                  // final teamMembers =
                  //     Provider.of<UserProjectProvider>(context, listen: false)
                  //         .teamResponse!
                  //         .data
                  //         .expand((team) => team.members)
                  //         .toList();
                  if (user != null) {
                    final teamMembers =
                        Provider.of<UserProjectProvider>(context, listen: false)
                            .teamMemberInfo;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTaskByTeamLeader(
                              leaderDetail: user,
                              teamMember: teamMembers,
                              projectId: widget.projectUid,
                              teamId: widget.teamUid),
                        ));
                  }
                },
                child: Icon(Icons.create),
              )
            : null);
    //);
  }

  Widget _buildCounter(String title, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
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
                      // final teamMembers = Provider.of<UserProjectProvider>(
                      //         context,
                      //         listen: false)
                      //     .teamResponse!
                      //     .data
                      //     .expand((team) => team.members)
                      //     .toList();
                      final teamMember = Provider.of<UserProjectProvider>(
                              context,
                              listen: false)
                          .teamResponse!
                          .data
                          .expand((team) => team.members)
                          .toList();

                      switch (name) {
                        case "pending":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskDetailScreen(
                                      task: tasks, members: teamMember)));
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
}
