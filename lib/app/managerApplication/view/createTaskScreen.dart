import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/controller/teamLeaderCon.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class Createtaskscreen extends StatefulWidget {
  const Createtaskscreen({super.key});

  @override
  State<Createtaskscreen> createState() => _CreatetaskscreenState();
}

class _CreatetaskscreenState extends State<Createtaskscreen> {
  final List<Map<String, dynamic>> showAllProjectType = const [
    {
      "projectTypeId": "1",
      "projectTypeName": "WSS",
    },
    {
      "projectTypeId": "1",
      "projectTypeName": "LWM",
    },
    {
      "projectTypeId": "1",
      "projectTypeName": "PWD",
    },
    {
      "projectTypeId": "1",
      "projectTypeName": "CWD",
    }
  ];
  final List<Map<String, dynamic>> showAllProject = const [
    {
      "projectTypeId": "1",
      "projectTypeName": "bhopal",
    },
    {
      "projectTypeId": "2",
      "projectTypeName": "indore",
    },
    {
      "projectTypeId": "3",
      "projectTypeName": "sehore",
    },
    {
      "projectTypeId": "4",
      "projectTypeName": "raisens",
    }
  ];
  final List<Map<String, dynamic>> team = const [
    {
      "teamId": "1",
      "teamName": "Survey",
    },
    {
      "teamId": "2",
      "teamName": "Office",
    },
  ];
  final List<Map<String, dynamic>> users = const [
    {
      "name": "Ram",
    },
    {
      "name": "Pramod",
    },
    {
      "name": "Warden",
    },
    {
      "name": "ADMIN",
    },
    {
      "name": "tester1",
    },
    {
      "name": "tester2",
    },
    {
      "name": "tester3",
    },
    {
      "name": "tester4",
    },
  ];
  final List<String> taskPriorityStatus = ["High", "Low", "Medium"];

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController teamNameController = TextEditingController();
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
    projectNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [],
        title: Text("Create Task"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: SizedBox(
          width: SizeConFig.proportionalWidth * 9.5,
          child: Column(
            children: [
              SizeConFig.verticalBox(0.03),
              buildSelectField<Map<String, dynamic>>(
                controller: createTaskForUserController,
                label: "Assign User",
                items: users,
                itemLabel: (item) => item['name'],
                leadingIcon: Icons.person_outline,
              ),
              SizeConFig.verticalBox(0.01),
              buildTextField('Task_Name', taskNameController),
              SizeConFig.verticalBox(0.01),
              buildSelectField<Map<String, dynamic>>(
                controller: projectNameController,
                label: "Project Name",
                items: showAllProject,
                itemLabel: (item) => item['projectTypeName'],
                leadingIcon: Icons.work_outline,
              ),
              SizeConFig.verticalBox(0.01),
              buildSelectField<Map<String, dynamic>>(
                controller: teamNameController,
                label: "Team Name",
                items: team,
                itemLabel: (item) => item['teamName'],
                leadingIcon: Icons.group_outlined,
              ),
              SizeConFig.verticalBox(0.01),
              buildSelectField<String>(
                controller: taskPriorityStatusController,
                label: "Task Priority",
                items: taskPriorityStatus,
                itemLabel: (item) => item,
                leadingIcon: Icons.flag_outlined,
              ),
              SizeConFig.verticalBox(0.01),
              buildTextField('Task_Description', taskDescriptionController),
              SizeConFig.verticalBox(0.01),
              Consumer<TeamleaderControllerPro>(
                builder: (context, pro, _) {
                  return buildSelectDateField(
                    label: "Allotment Date",
                    controller: pro.allotmentDateController,
                    onTap: () {
                      pro.selectDate(
                        context: context,
                        isCompletionDate: false,
                      );
                    },
                  );
                },
              ),
              SizeConFig.verticalBox(0.01),
              Consumer<TeamleaderControllerPro>(
                builder: (context, pro, _) {
                  return buildSelectDateField(
                    label: "Completion Date",
                    controller: pro.completionDateController,
                    onTap: () {
                      pro.selectDate(
                        context: context,
                        isCompletionDate: true,
                      );
                    },
                  );
                },
              ),
              SizeConFig.verticalBox(0.10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200,
                        60), // sets a minimum width of 200 and height of 60
                  ),
                  onPressed: () {
                    //adding api for creating task..........................................
                  },
                  child: Text("Create-Task"))
            ],
          ),
        )),
      ),
    );
  }

  Widget buildSelectDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextField(
      readOnly: true,
      controller: controller,
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_month_outlined,
            size: 24,
          ),
          onPressed: onTap,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  //.....................................BUILD TEXT FILED FOR SELECTION ....

  Widget buildSelectField<T>({
    required TextEditingController controller,
    required String label,
    required List<T> items,
    required String Function(T item) itemLabel,
    IconData? leadingIcon,
    void Function(T selected)? onSelected,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: PopupMenuButton<T>(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 28,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            controller.text = itemLabel(value);
            if (onSelected != null) {
              onSelected(value);
            }
          },
          itemBuilder: (context) {
            return items.map((item) {
              return PopupMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon, size: 18),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        itemLabel(item),
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
