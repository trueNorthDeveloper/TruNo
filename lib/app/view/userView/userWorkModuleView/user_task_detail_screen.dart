import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_submit_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/team_members_model.dart';

import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_response_model.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/user_list_of_screen.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/app_button.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  final List<Member> members;

  TaskDetailScreen(
      {super.key, required this.task, required List<Member> this.members});

  @override
  State<TaskDetailScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TaskDetailScreen> {
  Member? selectedMemberToSubmit;

  TextEditingController message = TextEditingController();
  TextEditingController submittedTaskController = TextEditingController();
  TextEditingController submitUserId = TextEditingController();
  Future<String?> showDialogBoxForImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image, color: Colors.deepPurple),
              title: Text('Image from Gallery'),
              onTap: () {
                Navigator.of(context).pop('image'); // return "image" action
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.insert_drive_file, color: Colors.teal),
              title: Text('Pick File (PDF, DOC, etc.)'),
              onTap: () {
                Navigator.of(context).pop('file'); // return "file" action
              },
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget buildFileCard(String file) {
    final fileName = file.split('/').last;
    final extension = fileName.split('.').last.toLowerCase();

    IconData icon;
    if (extension == 'pdf') {
      icon = Icons.picture_as_pdf;
    } else if (['doc', 'docx'].contains(extension)) {
      icon = Icons.description;
    } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
      icon = Icons.image;
    } else {
      icon = Icons.insert_drive_file;
    }

    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.indigo),
          SizedBox(width: 15),
          Expanded(
            child: Text(fileName, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Submit and Details"),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConFig.screenHeight * 2 / 100,
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          //height: SizeConFig.screenHeight * 25 / 100,
                          width: SizeConFig.screenWidth * 95 / 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: SizeConFig.screenHeight * 3 / 100),
                              Center(
                                child: Text(
                                  widget.task.taskName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: SizeConFig.screenHeight * 3 / 100),
                              Center(
                                child: SizedBox(
                                  height: SizeConFig.screenHeight * 15 / 100,
                                  width: SizeConFig.screenWidth * 80 / 100,
                                  //  color: Colors.green,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      costomTextbox(
                                          "Status", widget.task.taskStatus),
                                      SizedBox(
                                        height:
                                            SizeConFig.screenHeight * 0.5 / 100,
                                      ),
                                      costomTextbox("Assigned to ",
                                          widget.task.assignedTo.userName),
                                      SizedBox(
                                        height:
                                            SizeConFig.screenHeight * 0.5 / 100,
                                      ),
                                      costomTextbox("Allotment",
                                          widget.task.allotmentDate),
                                      SizedBox(
                                        height:
                                            SizeConFig.screenHeight * 0.5 / 100,
                                      ),
                                      costomTextbox("Due Date",
                                          widget.task.completionDate),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: SizeConFig.screenHeight * 3 / 100),
                              Stack(children: [
                                Positioned(
                                  child: Container(
                                    height: SizeConFig.screenHeight * 8 / 100,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        244,
                                        243,
                                        243,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: message,
                                      decoration: InputDecoration(
                                        hintText: "Task...Message",
                                        hintStyle: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: OutlineInputBorder(
                                          //  borderSide: BorderSide.none,
                                          borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 191, 195, 189)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                  height: SizeConFig.screenHeight * 1 / 100),
                              //select Multiple image from gallery.........
                              Consumer<UserDashboardProvider>(
                                builder: (context, provider, child) {
                                  if (provider.listofImage.isNotEmpty) {
                                    final images = provider.listofImage;
                                    return Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 8,
                                                mainAxisSpacing: 8,
                                              ),
                                              itemCount: images.length + 1,
                                              itemBuilder: (context, index) {
                                                if (index == images.length) {
                                                  // Add More Button
                                                  return GestureDetector(
                                                    onTap: () {
                                                      // provider.pickMoreImages(); // define this in provider
                                                      provider
                                                          .selectMutliImageFromGallery();
                                                    },
                                                    child: Container(
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                          Icons.add,
                                                          size: 40),
                                                    ),
                                                  );
                                                }
                                                final img = images[index];
                                                return Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.file(
                                                        File(img),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                    Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              // provider.removeImage(index);
                                                              context
                                                                  .read<
                                                                      UserDashboardProvider>()
                                                                  .clearImageFromList(
                                                                      index);
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            )))
                                                  ],
                                                );
                                              },
                                            ))
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              //selcect multiple file from gallery.

                              Consumer<UserDashboardProvider>(
                                builder: (context, prov, child) {
                                  if (prov.listOfFiles.isNotEmpty) {
                                    final files = prov.listOfFiles;
                                    return Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: files.length + 1,
                                              itemBuilder: (context, index) {
                                                // final filess = files[index];

                                                if (index == files.length) {
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue.shade100,
                                                      child: const Icon(
                                                          Icons.add,
                                                          color: Colors.blue),
                                                    ),
                                                    title: const Text(
                                                      "Add more files",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    onTap: () {
                                                      prov.selectListOfFile();
                                                    },
                                                  );
                                                }
                                                final file = files[index];
                                                return ListTile(
                                                  title: buildFileCard(file),
                                                  trailing: IconButton(
                                                      onPressed: () {
                                                        prov.clearListFiles(
                                                            index);
                                                      },
                                                      icon: Icon(Icons.cancel)),
                                                );
                                              },
                                            ))
                                      ],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),

                              SizedBox(
                                  height: SizeConFig.screenHeight * 3 / 100),
                              Consumer<UserDashboardProvider>(
                                builder: (context, pro, child) {
                                  if (pro.isImage == false &&
                                      pro.isFile == false) {
                                    return Center(
                                      child: AppButton(
                                        text: 'Upload File',
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          final result =
                                              await showDialogBoxForImage(
                                                  context);

                                          if (result == 'image') {
                                            pro.selectMutliImageFromGallery();
                                          } else if (result == 'file') {
                                            pro.selectListOfFile();
                                          }
                                        },
                                        buttonColor: Colors.blue,
                                        borderRadius: 80,
                                        elevation: 4,
                                        padding: 12,
                                        fontSize: 12,
                                        textColor: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height: 40,
                                        borderWidth: 0,
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                              //SELECT MEMEBER WHO HAVE TO SUBMIT TASK.................
                              SizedBox(
                                  height: SizeConFig.screenHeight * 3 / 100),
                              //  ElevatedButton(onPressed: () {
                              //    print(widget.members.map((item)=>item.memberName));
                              //  }, child: Text("getteam")),

//HERE WE WILL USE DROPDOWN BUTTON.........
                              // TextField(
                              //     readOnly: true,
                              //     controller: submittedTaskController,
                              //     decoration: InputDecoration(
                              //         border: OutlineInputBorder(),
                              //         labelText: "Submitted To",
                              //         suffixIcon: PopupMenuButton<String>(
                              //           icon: const Icon(Icons.arrow_drop_down),
                              //           onSelected: (Member member) {
                              //             setState(() {
                              //               submitUserId=member.userId;
                              //                submittedTaskController.text = member.memberName;
                              //             });

                              //           },
                              //           itemBuilder: (BuildContext context) {
                              //             return widget.members
                              //                 .map((Member member){})

                              //           },
                              //         ))),
                              TextField(
                                controller: submittedTaskController,
                                readOnly:
                                    true, // prevent manual typing (optional)
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Submitted To",
                                  suffixIcon: PopupMenuButton<Member>(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onSelected: (Member member) {
                                      setState(() {
                                        selectedMemberToSubmit = member;
                                        submittedTaskController.text =
                                            member.memberName;
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return widget.members
                                          .map((Member member) {
                                        return PopupMenuItem<Member>(
                                          value: member,
                                          child: Text(member.memberName),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height: SizeConFig.screenHeight * 3 / 100),

                              Consumer<UserProjectProvider>(
                                builder: (context, provider, child) {
                                  if (provider.isSubmitTask ||
                                      provider.isSubmitFile) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return Center(
                                    child: AppButton(
                                      text: "Submit Task",
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();

                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final uuid = prefs.getInt("uuid");

                                        // Basic validation
                                        if (uuid == null) {
                                          ShowTaostMessage.toastMessage(
                                              context, "User not found");
                                          return;
                                        }

                                        if (message.text.trim().isEmpty) {
                                          ShowTaostMessage.toastMessage(
                                              context, "Enter task message");
                                          return;
                                        }

                                        // Prepare data
                                        // final int taskId = widget.task.taskId;
                                        // final int taskSubmitById = uuid;
                                        // final int taskSubmitToId =
                                        //     1; // 
                                        // final String parent = "projects";
                                        // final String child =
                                        //     widget.task.project.projectName;
                                        // final String team =
                                        //     widget.task.team.teamName;
                                        // final String userEid =
                                        //     widget.task.assignedTo.userEid;

                                        // Create task object
                                        final TaskSubmit taskSubmit =
                                            TaskSubmit(
                                                message: message.text.trim(),
                                                taskId: widget.task.taskId,
                                                submittedById: uuid,
                                                submittedToId:
                                                    selectedMemberToSubmit!
                                                        .userId,
                                                parent: "projects",
                                                child: widget
                                                    .task.project.projectName,
                                                team: widget.task.team.teamName,
                                                userEid: widget
                                                    .task.assignedTo.userEid);

                                        final projectProvider =
                                            context.read<UserProjectProvider>();
                                        final userDashBoard = context
                                            .read<UserDashboardProvider>();

                                        // Collect all files (docs + images)
                                        List<String> files = [
                                          ...userDashBoard.listOfFiles,
                                          ...userDashBoard.listofImage,
                                        ];
                                        //print(taskSubmit.toJson());
                                        // 🔹 Await submission
                                        await projectProvider
                                            .submitTaskWithOrWithOutFileProvider(
                                          taskSubmit.toJson(),
                                          files,
                                        );

                                        // Check result
                                        if (projectProvider.error != null) {
                                          ShowTaostMessage.toastMessage(
                                            context,
                                            "Task submitted, but file upload failed.",
                                          );
                                          return;
                                        }

                                        // Success
                                        ShowTaostMessage.toastMessage(context,
                                            "Task submitted successfully!");

                                        // Clear input
                                        message.clear();
                                        userDashBoard.listOfFiles.clear();
                                        userDashBoard.listofImage.clear();
                                        // create a method in provider to clear both lists

                                        // Navigate back to Home
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListOfUiScreen(),
                                          ),
                                        );
                                      },
                                      buttonColor: Colors.blue,
                                      borderRadius: 80,
                                      elevation: 4,
                                      padding: 12,
                                      fontSize: 12,
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 40,
                                      borderWidth: 0,
                                    ),
                                  );
                                },
                              ),

                              SizedBox(
                                  height: SizeConFig.screenHeight * 3 / 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget costomTextbox(String textName, String textItem) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // width: SizeConFig.screenWidth * 22 / 100,
              child: Text(
                textName,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            SizedBox(
              width: SizeConFig.screenWidth * 35 / 100,
              child: Text(
                textItem,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget customButtomD(String name, int i) {
    final upDateCommAndDes = Provider.of<UserDashboardProvider>(context);
    bool isSelected = upDateCommAndDes.intchangeColorInTaskDetail == i;

    return SizedBox(
      width: SizeConFig.screenWidth * 25 / 100,
      //color:
      //  Colors.pink,
      child: GestureDetector(
        onTap: () {
          upDateCommAndDes.changeColorInTaskDetail(i);
        },
        child: Text(
          name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget customLineD(int i) {
    final upDateCommAndDes2 = Provider.of<UserDashboardProvider>(context);
    bool isSelected2 = upDateCommAndDes2.intchangeColorInTaskDetail == i;
    return Container(
      height: SizeConFig.screenHeight * 0.5 / 100,
      width: SizeConFig.screenWidth * 25 / 100,
      decoration: BoxDecoration(
        color: isSelected2 ? Colors.green : Colors.white,
      ),
    );
  }
}
