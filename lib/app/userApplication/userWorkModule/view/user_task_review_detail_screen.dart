import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/taskReview_model.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_task_review_response_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/controller/user_project_provider.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/user_list_of_screen.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskReviewDetailScreen extends StatefulWidget {
  const TaskReviewDetailScreen({super.key, required this.taskData});
  final TaskData taskData;

  @override
  State<TaskReviewDetailScreen> createState() => _TaskReviewDetailScreenState();
}

class _TaskReviewDetailScreenState extends State<TaskReviewDetailScreen> {
  // final _formKey = GlobalKey<FormState>();

  TextEditingController taskStatusController = TextEditingController();
  TextEditingController submitMessageController = TextEditingController();
  TextEditingController taskSubmitStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // taskStatusController = TextEditingController(
    //   text: widget.taskData.task.taskStatus,
    // );

    submitMessageController = TextEditingController(
      text: widget.taskData.taskSubmitMessage,
    );
    // taskSubmitStatusController = TextEditingController(
    //   text: widget.taskData.taskSubmitStatus,
    // );
  }

  @override
  void dispose() {
    taskStatusController.dispose();
    submitMessageController.dispose();
    taskSubmitStatusController.dispose();
    super.dispose();
  }

  // void _submitReview() {
  //   if (_formKey.currentState!.validate()) {
  //     final updatedStatus = taskStatusController.text.trim();
  //     final updatedMessage = submitMessageController.text.trim();
  //     final updatedSubmitStatus = taskSubmitStatusController.text.trim();

  //

  //     // print("Submitted Status: $updatedStatus");
  //     // print("Submitted Message: $updatedMessage");

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Task review submitted successfully!")),
  //     );
  //   }
  // }

  List<String> taskStatuses = [
    "COMPLETED",
    // "REJECTED",
    // "NEEDS_CORRECTION",
    "RESUBMITTED"
  ];
  List<String> submitStatuses = ["APPROVED", "NOT_APPROVED"];

  @override
  Widget build(BuildContext context) {
    final task = widget.taskData.task;

    return Scaffold(
        appBar: AppBar(title: Text("Review Task")),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "📝 Task Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      child: Column(
                        children: [
                          taskRow("Task Name", task.taskName),
                          taskRow("Description", task.taskDescription,
                              isMultiLine: true),
                          taskRow("Priority", task.taskPriorityStatus),
                          taskRow(
                            "Project",
                            task.project.projectName,
                          ),
                          taskRow("Team", task.team.teamName),
                          taskRow("Created At", task.createdAt.substring(0, 10),
                              colorByValue: true),
                          taskRow("Allotment", task.allotmentDate),
                          taskRow("Completion", task.completionDate),
                          taskRow(
                              "Submitted At",
                              widget.taskData.submitDate.isNotEmpty
                                  ? widget.taskData.submitDate.substring(0, 10)
                                  : "-"),
                          taskRow("Created By", task.createdBy.name),
                          taskRow("Assigned To", task.assignedTo.userName),
                          taskRow(
                              "Review By", widget.taskData.submittedTo.name),
                        ],
                      )),
                ),
                if (widget.taskData.files!.isNotEmpty)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            if (widget.taskData.files != null &&
                                widget.taskData.files!.isNotEmpty) ...[
                              sectionTitle("📎 Attached Files"),
                              ...widget.taskData.files!
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final file = entry.value;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    //  crossAxisAlignment: CrossAxisAlignment.,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Text(
                                          "File ${index + 1} ${file.mimeType.split('/').last}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        icon: Icon(Icons.visibility),
                                        // label: Text("View File ${index + 1}"),
                                        label: Text("View"),
                                        onPressed: () => _viewFile(
                                            context,
                                            file.downloadUrll,
                                            file.mimeType,
                                            "view"),
                                      ),
                                      ElevatedButton.icon(
                                        label: Text("Download"),
                                        icon: Icon(Icons.download),
                                        onPressed: () =>
                                            // _downloadFile(file.downloadUrll),
                                            _viewFile(
                                                context,
                                                file.downloadUrll,
                                                file.mimeType,
                                                "download"),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ]
                          ],
                        )),
                  ),
                sectionTitle(" Review update"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 100,
                ),
                TextField(
                  readOnly: true,
                  controller: taskStatusController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Task status",
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        taskStatusController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return taskStatuses
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 100,
                ),
                TextField(
                  readOnly: true,
                  controller: taskSubmitStatusController,
                  decoration: InputDecoration(
                    labelText: "submit status",
                    border: OutlineInputBorder(),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        taskSubmitStatusController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return submitStatuses
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 100,
                ),
                editableField("Submit Message", submitMessageController,
                    maxLines: 3),
                SizedBox(height: 20),
                Consumer<UserProjectProvider>(
                  builder: (context, provider, child) {
                    return provider.isReview
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (taskStatusController.text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "select Task status");
                                return;
                              } else if (taskSubmitStatusController
                                  .text.isEmpty) {
                                ShowTaostMessage.toastMessage(
                                    context, "select submit status");
                                return;
                              }

                              bool status =
                                  await showLogoutConfirmationDialog(context);
                              if (status) {
                                TaskReview obj = TaskReview(
                                  taskId: widget.taskData.task.taskId,

                                  ///  taskDescription: "",
                                  taskStatus: taskStatusController.text,
                                  //   taskPriority: '',
                                  submitStatus:
                                      taskSubmitStatusController.text.trim(),
                                  submitMessage:
                                      submitMessageController.text.trim(),
                                );

                                provider.reviewTask(obj.toJson()).then((_) {
                                  if (provider.error == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Task Reviewed successfully')),
                                    );

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => 
                                                ListOfUiScreen()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Error: ${provider.error}')),
                                    );
                                  }
                                });
                              }
                            },
                            child: const Text("Submit Review"),
                          );
                  },
                )
              ],
            ),
          ),
        ));
  }

  String? _selectedStatus;
  Widget statusDropdown(controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: InputDecoration(
          labelText: "Task Status",
          border: OutlineInputBorder(),
        ),
        items: taskStatuses.map((String status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          );
        }).toList(),
        validator: (value) => (value == null || value.isEmpty)
            ? "Please select task status"
            : null,
        onChanged: (String? newValue) {
          setState(() {
            _selectedStatus = newValue!;
            // taskStatusController.text = newValue;
            controller = newValue;
          });
        },
      ),
    );
  }
//TextaName........

  Widget textName(String name) {
    return Text("${name}",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500));
  }

  Widget textValue(String value) {
    return Text("${value}",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400));
  }

  Widget editableField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Please enter $label" : null,
      ),
    );
  }

  Widget textDisplay(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
      ),
    );
  }

//this function view and download based on condition view and download file.................
  Future<void> _viewFile(BuildContext context, String? downloadUrl,
      String? mimeType, String action) async {
    try {
      // Check for null or empty
      if (downloadUrl == null ||
          downloadUrl.isEmpty ||
          mimeType == null ||
          mimeType.isEmpty) {
        ShowTaostMessage.toastMessage(context, "Invalid file ");
        return;
      }

      // Check internet connection
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ShowTaostMessage.toastMessage(context, "No internet connection.");
        return;
      }

      // Open images in preview
      if (action == "view") {
        if (mimeType.startsWith("image/")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Image Preview')),
                body: Center(
                  child: Image.network(
                    downloadUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      final totalBytes = loadingProgress.expectedTotalBytes;
                      final loadedBytes = loadingProgress.cumulativeBytesLoaded;
                      final progress =
                          totalBytes != null ? loadedBytes / totalBytes : null;
                      final percentage =
                          progress != null ? (progress * 100).toInt() : null;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(value: progress),
                          const SizedBox(height: 12),
                          Text(
                            percentage != null ? "$percentage%" : "Loading...",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else if (mimeType.startsWith("application/")) {
          // we wil show pdf or any types of document........like pdf
        }
      }

      // Open PDFs in browser or viewer
      else if (action == "download") {
        //there are two condtions like download  downlaod img and pdf....................

        final uri = Uri.parse(downloadUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ShowTaostMessage.toastMessage(context, "Could not open PDF file.");
        }
      }

      // else if (action == "download") {
      //   // For other file types, attempt to download
      //   final status = await Permission.storage.request();

      //   if (!status.isGranted) {

      //     ShowTaostMessage.toastMessage(context, "Storage permission denied.");
      //     return;
      //   }
      //   final http.Response response = await http.get(Uri.parse(downloadUrl));
      //   if (response.statusCode != 200) {
      //     ShowTaostMessage.toastMessage(context, "Download failed.");
      //     return;
      //   }
      //   final fileName = downloadUrl.split('/').last;
      //   // final downloadsPath = await getDownloadPath();
      //   final dir = await getExternalStorageDirectory();
      //   if (dir == null) {
      //     ShowTaostMessage.toastMessage(context, "Could not access storage.");
      //     return;
      //   }
      //   final dowloadPath = await getExternalStorageDirectory();
      //   final filePath = "$dowloadPath/$fileName";

      //   final file = File(filePath);
      //   await file.writeAsBytes(response.bodyBytes);

      //   ShowTaostMessage.toastMessage(context, "File downloaded to: $filePath");
      // } else {
      //   ShowTaostMessage.toastMessage(context, "Unsupported file type.");
      // }
    } on PlatformException catch (e) {
      debugPrint("PlatformException: $e");
      ShowTaostMessage.toastMessage(context, "Platform error: ${e.message}");
    } on NetworkImageLoadException catch (e) {
      debugPrint("NetworkImageLoadException: $e");
      ShowTaostMessage.toastMessage(context, "Image could not be loaded.");
    } on TimeoutException catch (e) {
      debugPrint("TimeoutException: $e");
      ShowTaostMessage.toastMessage(context, "Request timed out.");
    }

    // General exceptions
    on FormatException catch (e) {
      debugPrint("FormatException: $e");
      ShowTaostMessage.toastMessage(context, "Invalid URL format.");
    } on Exception catch (e) {
      debugPrint("Exception: $e");
      ShowTaostMessage.toastMessage(context, "Something went wrong.");
    }

    // Catch all errors (not recommended unless you're logging properly)
    catch (e) {
      debugPrint("Unknown error: $e");
      ShowTaostMessage.toastMessage(context, "Unexpected error occurred.");
    }
  }
// this Function get platfrom information..........................

  Widget taskRow(String title, String value,
      {bool isMultiLine = false, bool colorByValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment:
            isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$title:",
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              maxLines: isMultiLine ? 3 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: colorByValue
                    ? (value == "null" ? Colors.green : Colors.red)
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //CONFIRMATION DIALOG FOR SUBMUIT REVIEW.............
  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            // title: const Text("Thanks for  your effective work have a good day"),
            content: const Text("Do you want to submit review?"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Yes"),
                  ),
                ],
              )
            ],
          ),
        ) ??
        false;
  }
}
