import 'package:flutter/material.dart';

import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_task_review_detail_screen.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_review_response_model.dart';

class TaskReviewScreen extends StatefulWidget {
  final List<TaskData> reviewTask;
  const TaskReviewScreen({super.key, required this.reviewTask});

  @override
  State<TaskReviewScreen> createState() => TaskReviewScreenState();
}

class TaskReviewScreenState extends State<TaskReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 3 / 100,
          ),
          Text("Total Submission For Review :${widget.reviewTask.length}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 3 / 100,
          ),
          //show all task by name..............................
          SizedBox(
            // / height: MediaQuery.of(context).size.height * 30 / 100,
            child: FutureBuilder<List<TaskData>>(
              future: widget.reviewTask.isNotEmpty
                  ? Future.value(widget.reviewTask)
                  : Future.error('No task found For'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(" ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No task data available"));
                }

                final tasks = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final taskData = tasks[index];
                    final task = taskData.task;

                    return Card(
                       clipBehavior: Clip.antiAlias,
                       color: const Color.fromARGB(255, 252, 253, 255),
                      margin: EdgeInsets.all(10),
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskReviewDetailScreen(
                                              taskData: taskData),
                                    ),
                                  );
                                },
                                child: textRow("Task Name", task.taskName)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 140,
              child: Text("$label:",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget divider() =>
      Divider(color: Colors.grey.shade400, thickness: 1, height: 10);

  TextStyle get sectionTitle =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal);
}
