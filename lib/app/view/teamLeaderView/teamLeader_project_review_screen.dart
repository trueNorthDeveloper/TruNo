import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/controller/teamLeaderController/teamLeaderCon.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/buildCustomText.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class TeamleaderProjectReviewScreen extends StatefulWidget {
  final String projectName;
  TeamleaderProjectReviewScreen({super.key, required this.projectName});

  @override
  State<TeamleaderProjectReviewScreen> createState() =>
      _TeamleaderProjectReviewScreenState();
}

class _TeamleaderProjectReviewScreenState
    extends State<TeamleaderProjectReviewScreen> {
  final Map<String, dynamic> summary = const {
    "totalTasks": 19,
    "pending": 16,
    "completed": 2,
    "resubmit": 1,
    "completionPercentage": 90,
  };
  final List<Map<String, dynamic>> users = const [
    {
      "name": "Ram",
      "pending": 6,
      "completed": 0,
      "resubmitted": 0,
      "percentage": 0
    },
    {
      "name": "Pramod",
      "pending": 1,
      "completed": 0,
      "resubmitted": 0,
      "percentage": 0
    },
    {
      "name": "Warden",
      "pending": 1,
      "completed": 2,
      "resubmitted": 1,
      "percentage": 50
    },
    {
      "name": "ADMIN",
      "pending": 8,
      "completed": 0,
      "resubmitted": 0,
      "percentage": 0
    },
    {
      "name": "tester1",
      "pending": 2,
      "completed": 0,
      "resubmitted": 0,
      "percentage": 0
    },
    {
      "name": "tester2",
      "pending": 1,
      "completed": 2,
      "resubmitted": 1,
      "percentage": 50
    },
    {
      "name": "tester3",
      "pending": 2,
      "completed": 0,
      "resubmitted": 0,
      "percentage": 0
    },
    {
      "name": "tester4",
      "pending": 1,
      "completed": 2,
      "resubmitted": 1,
      "percentage": 50
    },
  ];
  List<Map<String, dynamic>> alltask = const [
    {
      "taskId": 15,
      "taskName": "TASK for files how",
      "priority": "High",
      "taskStatus": "PENDING",
      "assinedTask": "Ram",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 16,
      "taskName": "TASK for files how",
      "priority": "High",
      "taskStatus": "COMPLETED",
      "assinedTask": "Ram",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 17,
      "taskName": "TASK for files how",
      "priority": "High",
      "taskStatus": "COMPLETED",
      "assinedTask": "Ram",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 18,
      "taskName": "TASK for files how",
      "priority": "High",
      "taskStatus": "PENDING",
      "assinedTask": "Ram",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 19,
      "taskName": "TASK for files how",
      "priority": "High",
      "taskStatus": "COMPLETED",
      "assinedTask": "Ram",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 20,
      "taskName": "TASK for files how",
      "priority": "High",
      "taskStatus": "REVIEW",
      "assinedTask": "Ram",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 21,
      "taskName": "real time api check",
      "priority": "High",
      "taskStatus": "PENDING",
      "assinedTask": "Pramod",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 22,
      "taskName": "real time api check 2",
      "priority": "High",
      "taskStatus": "REVIEW",
      "assinedTask": "Warden",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 23,
      "taskName": "real time  new update",
      "priority": "High",
      "taskStatus": "PENDING",
      "assinedTask": "Warden",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Office Team"
    },
    {
      "taskId": 24,
      "taskName": "real time  new update 2",
      "priority": "High",
      "taskStatus": "REVIEW",
      "assinedTask": "Warden",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Office Team"
    },
    {
      "taskId": 25,
      "taskName": "real time  new update",
      "priority": "High",
      "taskStatus": "PENDING",
      "assinedTask": "Warden",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Office Team"
    },
    {
      "taskId": 26,
      "taskName": "real time  response",
      "priority": "High",
      "taskStatus": "REVIEW",
      "assinedTask": "Warden",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Survey Team"
    },
    {
      "taskId": 27,
      "taskName": "real time  new update",
      "priority": "High",
      "taskStatus": "PENDING",
      "assinedTask": "Warden",
      "allotmentDate": "2025-12-05",
      "completionDate": "2025-12-07",
      "submitStatus": null,
      "submittedAt": null,
      "team": "Office Team"
    }
  ];
  @override
  Widget build(BuildContext context) {
    final surveyTeam =
        alltask.where((item) => item["team"] == "Survey Team").toList();
    final officeTeam =
        alltask.where((e) => e["team"] == "Office Team").toList();

    int counter =
        Provider.of<TeamleaderControllerPro>(context, listen: true).counter;
    int filter = Provider.of<TeamleaderControllerPro>(context, listen: true)
        .selectedFilterIndex;
    return Scaffold(
        backgroundColor: const Color(0xffF4F6F8),
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            "DASHBOARD",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: BuildCustomText(
                      data: widget.projectName,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
//------------------------------Task summary total -------------------------------------
                    SizedBox(
                      width: SizeConFig.proportionalWidth * 4.5,
                      height: SizeConFig.proportionalHeight * 2,
                      child: _summaryCards(),
                    ),
//------------------------------- task status peichart garaph project Completion-------------------------
                    SizedBox(
                      width: SizeConFig.proportionalWidth * 4.5,
                      height: SizeConFig.proportionalHeight * 2,
                      child: Column(
                        children: [_taskStatusChart(), _projectProgress()],
                      ),
                    )
                  ],
                ),
//-----------------------Size box--------------------------------------
                SizeConFig.verticalBox(0.01),
                _buildBreakLine(),
                SizeConFig.verticalBox(0.01),
//----------------------TEAM PROGRESSS CHILP
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(children: [
                  Column(
                    children: <Widget>[
                      Row(
                        children: [
                          _buildChip("Team Progress", Colors.blueGrey),
                          SizeConFig.horizontalBox(0.10),
                          Consumer<TeamleaderControllerPro>(
                            builder: (context, value, child) {
                              return value.changeIcn
                                  ? Icon(Icons.arrow_downward)
                                  : Icon(Icons.arrow_upward);
                            },
                          ),
                          InkWell(
                              onTap: () {
                                context
                                    .read<TeamleaderControllerPro>()
                                    .changeIcons();
                              },
                              child: _buildChip("click-here",
                                  const Color.fromARGB(255, 17, 13, 16))),
                        ],
                      ),
                      SizeConFig.verticalBox(0.01),

                      Consumer<TeamleaderControllerPro>(
                        builder: (context, value, child) {
                          //--------------------------TEAM PROGRESS----------------------------------------------------------------
                          if (value.changeIcn == true)
                            return _teamPerformance();
                          return SizeConFig.verticalBox(0.01);
                        },
                      ),

//--------------------------------BREAK LINE USING BLACK LINE----------------------------------------------
                      _buildBreakLine(),
                      SizeConFig.verticalBox(0.01),
// //-----------------------CHANGE TEAM AND OFFICE TEAM TASK WISE---------------------------------------------
                      SizedBox(
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(2, (index) {
                            final titles = ["[Survey-Team]", "[Office-Team]"];
                            final lineColors = [Colors.green, Colors.black];

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Provider.of<TeamleaderControllerPro>(
                                      context,
                                      listen: false,
                                    ).increaseCounterForTeam(index);
                                  },
                                  child: _buildCounter(
                                      titles[index], index, Colors.black),
                                ),
                                if (counter == index)
                                  buildLine(lineColors[index]),
                              ],
                            );
                          }),
                        ),
                      ),
                      SizeConFig.verticalBox(0.01),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  context
                                      .read<TeamleaderControllerPro>()
                                      .selectFilter(0);
                                },
                                child: _buildTaskFilter("[All]", 10, 0)),
                            SizeConFig.horizontalBox(0.02),
                            InkWell(
                                onTap: () {
                                  print("2");
                                  context
                                      .read<TeamleaderControllerPro>()
                                      .selectFilter(1);
                                },
                                child: _buildTaskFilter("[Pending]", 10, 1)),
                            SizeConFig.horizontalBox(0.02),
                            InkWell(
                                onTap: () {
                                  print("3");
                                  context
                                      .read<TeamleaderControllerPro>()
                                      .selectFilter(2);
                                },
                                child: _buildTaskFilter("[Completed]", 10, 2)),
                            SizeConFig.horizontalBox(0.02),
                            InkWell(
                                onTap: () {
                                  print("4");
                                  context
                                      .read<TeamleaderControllerPro>()
                                      .selectFilter(3);
                                },
                                child: _buildTaskFilter("[Review]", 10, 3)),
                          ],
                        ),
                      ),
                      SizeConFig.verticalBox(0.01),

//---------------------------all task show using build taskList----------------------------------------
                      if (counter == 0) _buildTaskList(surveyTeam, filter),
                      if (counter == 1) _buildTaskList(officeTeam, filter),
                    ],
                  ),
                ])))
              ],
            )));
  }

  Widget _buildTaskFilter(String data, double textSize, int index) {
    final selectedIndex =
        Provider.of<TeamleaderControllerPro>(context).selectedFilterIndex;

    final isSelected = selectedIndex == index;
    return Row(
      children: [
        SizedBox(
            child: isSelected
                ? Icon(
                    Icons.check_box,
                    size: 20,
                  )
                : Icon(Icons.check_box_outline_blank)),
        SizeConFig.horizontalBox(0.01),
        BuildCustomText(
          data: data,
          color: Colors.black,
          fontSize: textSize,
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }

//-----------------------------------------------------------BELOW THIS ALL HELPER METHODS  CREATED
  Widget _buildTaskList(List<Map<String, dynamic>> items, int filterIndex) {
    final status =
        Provider.of<TeamleaderControllerPro>(context).filterData(filterIndex);
    // print(selectedIndex);
    List<Map<String, dynamic>> commanList = [];
    List<Map<String, dynamic>> pendingList =
        items.where((item) => item['taskStatus'] == status).toList();
    List<Map<String, dynamic>> completedList =
        items.where((item) => item['taskStatus'] == status).toList();
    List<Map<String, dynamic>> reviewList =
        items.where((item) => item['taskStatus'] == status).toList();
    if (filterIndex == 0) {
      commanList = items;
    }
    if (filterIndex == 1) {
      commanList = completedList;
    }
    if (filterIndex == 2) {
      commanList = pendingList;
    }
    if (filterIndex == 3) {
      commanList = reviewList;
    }

    return Container(
        height: MediaQuery.of(context).size.height * 40 / 100,
        child: ListView.builder(
            itemCount: commanList.length,
            itemBuilder: (context, index) {
              final item = commanList[index];

              return SizedBox(
                  height: MediaQuery.of(context).size.height * 10 / 100,
                  child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      elevation: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: SizeConFig.proportionalWidth * 90.0,
                                  height: SizeConFig.proportionalHeight * 0.30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${item["taskName"]}${item["taskId"]}",
                                          // item["taskName"][index],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      //HIGHT PRIORITY BUTTON---------------------------
                                      _buildChip(item["priority"], Colors.red),
//--------------------------------------------EDIT AND DELETE BUTTON-------------------------------------------------------------
                                      _buildEditAndDeleteButon(items[index])
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    _info("Status", item["taskStatus"]),
                                    _info("Assigned", item["assinedTask"]),
                                    _info("Team", item["team"]),
                                    _info("Start", item["allotmentDate"]),
                                    _info("End", item["completionDate"]),
                                    _info(
                                        "Submit", item["submitStatus"] ?? "-"),
                                  ],
                                ),
                              ]))));
            }));
  }

//DELETE OR EDIT BUTTON OF TASK
  Widget _buildEditAndDeleteButon(Map<String, dynamic> item) {
    return SizedBox(
      // width: SizeConFig.proportionalWidth * 3.0,
      // height: SizeConFig.proportionalHeight * 0.01,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: IconButton(
                onPressed: () {
                  //  print(item);
                  showEditTaskDialog(context, item);
                },
                icon: Icon(Icons.edit)),
          ),
          SizedBox(
            // width: SizeConFig.proportionalWidth * 1.0,
            // height: SizeConFig.proportionalHeight *0.01,
            child: IconButton(
                onPressed: () {
                  showDeleteConfirmationDialog(context, item);
                },
                icon: Icon(Icons.delete)),
          )
        ],
      ),
    );
  }

//------------------------------------DELETE TASK BOX WITH CONFIRAMATION....
  void showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Are you sure you want to delete this task?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Task Name: ${item['taskName']}"),
              Text("Assigned To: ${item['assinedTask']}"),
              Text("Team: ${item['team']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
//call api for delete task
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  ///SHOW DIALOG BOX FOR EDII TASK....................................................................................
  void showEditTaskDialog(BuildContext context, Map<String, dynamic> item) {
    final TextEditingController taskNameController =
        TextEditingController(text: item['taskName']);
    final TextEditingController priorityController =
        TextEditingController(text: item['priority']);
    final TextEditingController assignedController =
        TextEditingController(text: item['assinedTask']);
    final TextEditingController teamController =
        TextEditingController(text: item['team']);
    final TextEditingController allotmentDateController =
        TextEditingController(text: item['allotmentDate']);
    final TextEditingController completionDateController =
        TextEditingController(text: item['completionDate']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: SizeConFig.proportionalWidth * 30.0,
              height: SizeConFig.proportionalHeight * 5.01,
              child: Column(
                children: [
                  _buildTextField("Task Name", taskNameController),
                  _buildTextField("Priority", priorityController),
                  _buildTextField("Assigned To", assignedController),
                  _buildTextField("Team", teamController),
                  _buildTextField("Allotment Date", allotmentDateController),
                  _buildTextField("Completion Date", completionDateController),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Updated JSON
                Map<String, dynamic> updatedItem = {
                  ...item,
                  'taskName': taskNameController.text,
                  'priority': priorityController.text,
                  'assinedTask': assignedController.text,
                  'team': teamController.text,
                  'allotmentDate': allotmentDateController.text,
                  'completionDate': completionDateController.text,
                };

                print("Updated Item: $updatedItem");

                Navigator.pop(context);

                // TODO: call API or setState to update list
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

//------------------------THIS WILLL BUILD DAILOG BOX CONTRTOLLER
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  ///----------------------------------LIST OF TASK INFO IN LIST VIEW.....................
  Widget _info(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label: ",
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 24, 18, 18),
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 137, 136, 137),
            ),
          ),
        ],
      ),
    );
  }

//BREAK LINE CODE---------------------------------------------------------------------------------
  Widget _buildBreakLine() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15 / 100,
      decoration:
          BoxDecoration(color: const Color.fromARGB(255, 186, 176, 176)),
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

//----------------------------build line for inside survey team and office team.....
  Widget buildLine(Color color) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1 / 100,
        width: MediaQuery.of(context).size.width * 20 / 100,
        color: color);
  }

  // BUILD CONTOR FOR BUILD LINE CHANGES----------------------------------------
  Widget _buildCounter(String title, int count, Color color) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 100,
      width: MediaQuery.of(context).size.width * 30 / 100,
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.23 / 100,
          ),
        ],
      ),
    );
  }

//-------------------------------------TOTAL SUMMMART CARD FOR TOTAL SHOW OF TASK AND PENDING ABND COMPLTED AND RESUBMI TASK OF TEAM LEADER
  Widget _summaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      // mainAxisSpacing: 12,
      // childAspectRatio: 3.0,
      mainAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: [
        _card("Total Tasks", summary["totalTasks"], Colors.blue),
        _card("Pending", summary["pending"], Colors.orange),
        _card("Completed", summary["completed"], Colors.green),
        _card("Resubmit", summary["resubmit"], Colors.red),
      ],
    );
  }

  // ---------------- PIE CHART ----------------
  Widget _taskStatusChart() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 12 / 100,
      width: MediaQuery.of(context).size.width * 40 / 100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Column(
            children: [
              const Text("Status",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 8 / 100,
                child: PieChart(
                  PieChartData(sections: [
                    PieChartSectionData(
                      value: 16,
                      color: Colors.orange,
                    ),
                    PieChartSectionData(value: 2, color: Colors.green),
                    PieChartSectionData(value: 1, color: Colors.red),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///THIS WILL BUILD THE CARD.........................................
  Widget _card(String title, int value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8), // ⬅ less padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

//---------------------------------------PROJECT PROGESSS BAR HELPER METHOD..................
  Widget _projectProgress() {
    return SizedBox(
      // height: 150,
      // width: 150,
      height: MediaQuery.of(context).size.height * 7 / 100,
      width: MediaQuery.of(context).size.width * 40 / 100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              const Text("Project Completion",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
              const SizedBox(height: 12),
              SizedBox(
                height: MediaQuery.of(context).size.height * 2 / 100,
                width: MediaQuery.of(context).size.width * 10 / 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: summary["completionPercentage"] / 100,
                      strokeWidth: 10,
                    ),
                    Text(
                      "${summary["completionPercentage"]}%",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//------------TEAM PERFORMANCE HELPER METHOD...............................
  Widget _teamPerformance() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 20 / 100,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final double progress = users[index]["percentage"] / 100;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 4 / 100,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        // NAME
                        SizedBox(
                          width: 70,
                          child: Text(
                            user["name"],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade300,
                                color: progress > 0.5
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${user["percentage"]}% completed",
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // PENDING
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "P:${user["pending"]}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
// Column(
//                 children:<Widget> [
//                         Row(
//               children: [
//                 _buildChip("Team Progress", Colors.blueGrey),
//                 SizeConFig.horizontalBox(0.10),
//                 Consumer<TeamleaderControllerPro>(
//                   builder: (context, value, child) {
//                     return value.changeIcn
//                         ? Icon(Icons.arrow_downward)
//                         : Icon(Icons.arrow_upward);
//                   },
//                 ),
//                 InkWell(
//                     onTap: () {
//                       context.read<TeamleaderControllerPro>().changeIcons();
//                     },
//                     child: _buildChip(
//                         "click-here", const Color.fromARGB(255, 17, 13, 16))),
//               ],
//             ),
//             SizeConFig.verticalBox(0.01),

//             Consumer<TeamleaderControllerPro>(
//               builder: (context, value, child) {
//                 //--------------------------TEAM PROGRESS----------------------------------------------------------------
//                 if (value.changeIcn == true) return _teamPerformance();
//                 return SizeConFig.verticalBox(0.01);
//               },
//             ),

// //--------------------------------BREAK LINE USING BLACK LINE----------------------------------------------
//             _buildBreakLine(),
//             SizeConFig.verticalBox(0.01),
// //-----------------------CHANGE TEAM AND OFFICE TEAM TASK WISE---------------------------------------------
//             SizedBox(
//               child: Row(
//                 //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(2, (index) {
//                   final titles = ["[Survey-Team]", "[Office-Team]"];
//                   final lineColors = [Colors.green, Colors.black];

//                   return Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Provider.of<TeamleaderControllerPro>(
//                             context,
//                             listen: false,
//                           ).increaseCounterForTeam(index);
//                         },
//                         child:
//                             _buildCounter(titles[index], index, Colors.black),
//                       ),
//                       if (counter == index) buildLine(lineColors[index]),
//                     ],
//                   );
//                 }),
//               ),
//             ),
//             SizeConFig.verticalBox(0.01),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   InkWell(
//                       onTap: () {
//                         context.read<TeamleaderControllerPro>().selectFilter(0);
//                       },
//                       child: _buildTaskFilter("[All]", 10, 0)),
//                   SizeConFig.horizontalBox(0.02),
//                   InkWell(
//                       onTap: () {
//                         print("2");
//                         context.read<TeamleaderControllerPro>().selectFilter(1);
//                       },
//                       child: _buildTaskFilter("[Pending]", 10, 1)),
//                   SizeConFig.horizontalBox(0.02),
//                   InkWell(
//                       onTap: () {
//                         print("3");
//                         context.read<TeamleaderControllerPro>().selectFilter(2);
//                       },
//                       child: _buildTaskFilter("[Completed]", 10, 2)),
//                   SizeConFig.horizontalBox(0.02),
//                   InkWell(
//                       onTap: () {
//                         print("4");
//                         context.read<TeamleaderControllerPro>().selectFilter(3);
//                       },
//                       child: _buildTaskFilter("[Review]", 10, 3)),
//                 ],
//               ),
//             ),
//             SizeConFig.verticalBox(0.01),
// //---------------------------all task show using build taskList----------------------------------------
//             if (counter == 0) _buildTaskList(surveyTeam, filter),
//             if (counter == 1) _buildTaskList(officeTeam, filter),
//                 ],
//               ),
