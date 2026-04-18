import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:truenorthflutterfrontend/app/managerApplication/model/user_create_task_by_leader_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/team_members_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/controller/user_project_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

class CreateTaskByTeamLeader extends StatefulWidget {
  final Member leaderDetail;
  final List<Member> teamMember;
  final projectId;
  final teamId;
  const CreateTaskByTeamLeader(
      {super.key,
      required this.leaderDetail,
      required this.teamMember,
      required this.projectId,
      required this.teamId});

  @override
  State<CreateTaskByTeamLeader> createState() => _CreateTaskByTeamLeaderState();
}

class _CreateTaskByTeamLeaderState extends State<CreateTaskByTeamLeader> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  final TextEditingController taskPriorityStatusController =
      TextEditingController();
  final TextEditingController taskStatusController = TextEditingController();
  final TextEditingController allotmentDateController = TextEditingController();
  final TextEditingController completionDateController =
      TextEditingController();
  final TextEditingController createTaskForUserController =
      TextEditingController();

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    taskPriorityStatusController.dispose();
    taskStatusController.dispose();
    allotmentDateController.dispose();
    completionDateController.dispose();
    super.dispose();
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: GestureDetector(
      onTap: () {
        print("hello");
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              Text(
                'Create Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              buildTextField('Task Name', taskNameController),
              const SizedBox(height: 16),
              buildTextField('Task Description', taskDescriptionController),
              const SizedBox(height: 16),
              TextField(
                controller: taskPriorityStatusController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Priority Status",
                  suffixIcon: PopupMenuButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      taskPriorityStatusController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return priorityStatus
                          .map<PopupMenuItem<String>>((String value) {
                        return new PopupMenuItem(
                            child: new Text(value), value: value);
                      }).toList();
                    },
                  ),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                readOnly: true,
                controller: allotmentDateController,
                decoration: InputDecoration(
                  labelText: "Allotment Date (YYYY-MM-DD)",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  suffixIcon: IconButton(
                      onPressed: () {
                        selectDateAlloted(context);
                      },
                      icon: Icon(Icons.calendar_month)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                readOnly: true,
                controller: completionDateController,
                decoration: InputDecoration(
                  labelText: "Completion Date (YYYY-MM-DD)",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  suffixIcon: IconButton(
                      onPressed: () {
                        selectDateCompletion(context);
                      },
                      icon: Icon(Icons.calendar_month)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: createTaskForUserController,
                readOnly: true, // prevent manual typing (optional)
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Task Assigned",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  suffixIcon: PopupMenuButton<Member>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (Member member) {
                      setState(() {
                        selectedMemberToAssignedTask = member.userId;
                        createTaskForUserController.text = member.memberName;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return widget.teamMember.map((member) {
                        return PopupMenuItem<Member>(
                          value: member,
                          child: Text(member.memberName),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Consumer<UserProjectProvider>(
                builder: (context, provider, child) {
                  return provider.isCreateTask
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // print("Task Name: ${taskNameController.text}");
                              // print(
                              //     "Description: ${taskDescriptionController.text}");
                              // print(
                              //     "Priority: ${taskPriorityStatusController.text}");
                              // print(
                              //     "Allotment: ${allotmentDateController.text}");
                              // print(
                              //     "Completion: ${completionDateController.text}");
                              if (taskNameController.text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "Enter Task Name");
                                return;
                              } else if (taskDescriptionController
                                  .text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "Enter Task  Description");
                                return;
                              } else if (taskPriorityStatusController
                                  .text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "Select Priority Status");
                                return;
                              } else if (allotmentDateController.text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "Select Task Allotment Date");
                                return;
                              } else if (completionDateController
                                  .text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "Select Task completion Date");
                                return;
                              } else if (createTaskForUserController
                                  .text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "Select  Assign User For Task");
                                return;
                              }

                              final crt = CreateTaskByLeaderModel(
                                taskName: taskNameController.text.trim(),
                                taskDescription:
                                    taskDescriptionController.text.trim(),
                                taskPriorityStatus:
                                    taskPriorityStatusController.text.trim(),
                                taskAssignedToUser:
                                    selectedMemberToAssignedTask ?? 0,
                                taskCreatedById: widget.leaderDetail.userId,
                                allotmentDate: allotmentDateController.text,
                                completionDate: completionDateController.text,
                                tnecProjectId: widget.projectId,
                                tnecPtTeamId: widget.teamId,
                              );
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => UserHomePage()));
                              await provider
                                  .createTaskByTeamLeader(crt.toJson());
                              //.then((_) {

                              if (provider.error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Task created successfully')),
                                );
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             ListOfUiScreen()));
                                  Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Error: ${provider.error}')),
                                );
                              }
                            },

                            // );

                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Create Task',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    ));
  }

  List<String> priorityStatus = ["High"];
  DateTime? _selectedDate;

  Future<void> selectDateAlloted(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        allotmentDateController.text =
            _selectedDate.toString().substring(0, 10).trim();
      });
    }
  }

  DateTime? _selectedDate2;
  Future<void> selectDateCompletion(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate2 = picked;
        completionDateController.text =
            _selectedDate2.toString().substring(0, 10).trim();
      });
    }
  }

  int? selectedMemberToAssignedTask;
  //Member? selectedMemberToAssignedTask;
  int? userUid;
  Future<void> getUserBySharedPreferenceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('uuid');
    userUid = userId;
  }
}
