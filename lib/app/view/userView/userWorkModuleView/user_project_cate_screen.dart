import 'package:flutter/material.dart';

class UserProjectCategoryTeam extends StatefulWidget {
  final String teamName;
  final bool isTeamLeader;
  final List<Map<String, dynamic>> teamTasks;
  final String userId;

  const UserProjectCategoryTeam({
    Key? key,
    required this.teamName,
    required this.isTeamLeader,
    required this.teamTasks,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserProjectCategoryTeam> createState() =>
      _UserProjectCategoryTeamState();
}

class _UserProjectCategoryTeamState extends State<UserProjectCategoryTeam> {
  List<dynamic> teamMember = <dynamic>[
    {"name": "Ashok", "role": "team Leader"},
    {"name": "yash", "role": "Team Leader"},
    {"name": "shivam soni", "role": "Task Manager"},
    {"name": "Gayatri ", "role": "member"},
    {"name": "Navendra", "role": " member"},
    {"name": "Ankit", "role": " member"},
    {"name": "Rohit", "role": " member"},
    {"name": "Vikash", "role": " member"},
    {"name": "Ravi", "role": " member"},
    {"name": "Prashant", "role": " member"},
  ];

  @override
  Widget build(BuildContext context) {
    // final myTasks = widget.teamTasks
    //     .where((t) => t["assignedTo"] == widget.userId)
    //     .toList();

    return Scaffold(
      appBar: AppBar(title: Text("${widget.teamName}")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: teamMember.length,
                itemBuilder: (context, index) {
                  final member = teamMember[index];
                  return Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar Circle
                            CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  Colors.blue[100 * ((index % 8) + 1)],
                              child: Text(
                                member["name"][0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Name
                            Text(
                              member["name"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Role
                            Text(
                              member["role"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
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
            ),
          ],
        ),
      ),
    );
  }
}
///////////////////////
/// // 🔹 Show current user's tasks
            // if (!widget.isTeamLeader) ...[
            //   Text(
            //     "My Current Tasks",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: myTasks.length,
            //       itemBuilder: (context, index) {
            //         final task = myTasks[index];
            //         return Card(
            //           child: ListTile(
            //             title: Text(task["taskName"]),
            //             subtitle: Text("Status: ${task["status"]}"),
            //             trailing: ElevatedButton(
            //               onPressed: () {
            //                 // Submit task (update status API)
            //               },
            //               child: Text("Submit"),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ],

            // // 🔹 If leader → show overview of all tasks
            // if (widget.isTeamLeader) ...[
            //   Text(
            //     "Team Task Overview",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: widget.teamTasks.length,
            //       itemBuilder: (context, index) {
            //         final task = widget.teamTasks[index];
            //         return Card(
            //           child: ListTile(
            //             title: Text(task["taskName"]),
            //             subtitle: Text(
            //               "Assigned To: ${task["assignedToName"]}\nStatus: ${task["status"]}",
            //             ),
            //             trailing: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 if (task["status"] == "submitted")
            //                   IconButton(
            //                     icon: Icon(Icons.check, color: Colors.green),
            //                     onPressed: () {
            //                       // Approve task
            //                     },
            //                   ),
            //                 IconButton(
            //                   icon: Icon(Icons.add_task, color: Colors.blue),
            //                   onPressed: () {
            //                     // Assign new task
            //                   },
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ]