import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskCompletedScreen extends StatefulWidget {
  final int taskId;

  const TaskCompletedScreen({super.key, required this.taskId});

  @override
  State<TaskCompletedScreen> createState() => _TaskCompletedScreenState();
}

class _TaskCompletedScreenState extends State<TaskCompletedScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
        () => Provider.of<UserProjectProvider>(context, listen: false)
            // .completeTaskApiResponse);
            .toviewCompleteTaskProvider(widget.taskId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "📝 Task Completed Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
                elevation: 2,
                margin: const EdgeInsets.all(4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Column(
                    children: [
                      Consumer<UserProjectProvider>(
                        builder: (context, provider, child) {
                          if (provider.isComplete) {
                            return Center(
                                child: const CircularProgressIndicator());
                          }
                          if (provider.error != null) {
                            return Text(provider.error!.name);
                          }
                          final taskInfo =
                              provider.completeTaskApiResponse?.data;
                          if (taskInfo == null)
                            return const Text("No task found");

                          // final completetionDate =
                          //     taskInfo.task!.completionDate!.substring(0, 10);
                          // final submitDate = taskInfo.submit!.taskSubmittedAt!
                          //     .substring(0, 10);
                          final completionDatee = DateTime.tryParse(
                              taskInfo.task!.completionDate!.substring(0, 10));
                          final submittedDatee = DateTime.tryParse(taskInfo
                              .submit!.taskSubmittedAt!
                              .substring(0, 10));
                          Duration diffrence =
                              submittedDatee!.difference(completionDatee!);
                          final bool overdue = completionDatee != null &&
                              submittedDatee != null &&
                              submittedDatee.isAfter(completionDatee);
                          return Card(
                              elevation: 2,
                              margin: const EdgeInsets.all(4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Column(children: [
                                    _infoRow(
                                        "TaskName", taskInfo.task!.taskName),
                                    _infoRow("Description",
                                        taskInfo.task!.taskDescription),
                                    _infoRow("Task Priority",
                                        taskInfo.task!.taskPriorityStatus),
                                    _infoRow("Task Status",
                                        taskInfo.task!.taskStatus,
                                        valueColor: Colors.green),
                                    _infoRow("Project",
                                        taskInfo.task!.project!.projectName),
                                    _infoRow(
                                        "Team", taskInfo.task!.team!.teamName),
                                    _infoRow(
                                        "Allotment At",
                                        taskInfo.task!.allotmentDate!
                                            .substring(0, 10)),
                                    _infoRow(
                                        "Completion At",
                                        taskInfo.task!.completionDate!
                                            .substring(0, 10)),
                                    _infoRow("Created By",
                                        taskInfo.task!.createdBy!.userName),
                                    _infoRow("Assigned To",
                                        taskInfo.task!.assignedTo!.userName),
                                    _infoRow(
                                        "Review",
                                        taskInfo.submit!.submitTo!.userName! +
                                            " ( " +
                                            taskInfo.submit!.taskReviewAt!
                                                .substring(0, 10) +
                                            " )"),
                                    _infoRow(
                                        "Submit At",
                                        taskInfo.submit!.taskSubmittedAt!
                                                .substring(0, 10) +
                                            " " +
                                            "( Overdue" +
                                            diffrence.inDays.toString() +
                                            " " +
                                            "Days )",
                                        valueColor: overdue
                                            ? Colors.red
                                            : Colors.black87),
                                    if (taskInfo.files!.isNotEmpty)
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            children: [
                                              if (taskInfo.files != null &&
                                                  taskInfo
                                                      .files!.isNotEmpty) ...[
                                                sectionTitle("Attached Files"),
                                                ...taskInfo.files!
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  final index = entry.key;
                                                  final files = entry.value;
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          child: Text(
                                                              "File ${index + 1} ${files.mimeType!.split('/').last}"),
                                                        ),
                                                        ElevatedButton.icon(
                                                            icon: Icon(
                                                                Icons.download),
                                                            onPressed: () =>
                                                                _viewFile(
                                                                    context,
                                                                    files
                                                                        .downloadUrll,
                                                                    files
                                                                        .mimeType,
                                                                    "view"),
                                                            label:
                                                                Text("view")),
                                                        //                    SizedBox(
                                                        // width: MediaQuery.of(context)
                                                        //         .size
                                                        //         .width *
                                                        //     0.11),
                                                        ElevatedButton.icon(
                                                          label:
                                                              Text("Download"),
                                                          icon: Icon(
                                                              Icons.download),
                                                          onPressed: () =>
                                                              // _downloadFile(file.downloadUrll),
                                                              _viewFile(
                                                                  context,
                                                                  files
                                                                      .downloadUrll,
                                                                  files
                                                                      .mimeType,
                                                                  "download"),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList()
                                              ]
                                            ],
                                          ),
                                        ),
                                      )
                                  ])));
                        },
                      )
                    ],
                  ),
                ))
          ]),
        )));
  }

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

  Widget _infoRow(String label, String? value, {Color? valueColor}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text("$label:",
                    style: const TextStyle(fontWeight: FontWeight.w500))),
            Expanded(
                flex: 5,
                child: Text(
                  value ?? '-',
                  style: TextStyle(color: valueColor ?? Colors.black87),
                ))
          ],
        ),
      );
}
