import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/user_list_of_screen.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_button.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ResubmitScreen extends StatefulWidget {
  final int taskId;
  ResubmitScreen({super.key, required this.taskId});

  @override
  State<ResubmitScreen> createState() => _ResubmitScreenState();
}

class _ResubmitScreenState extends State<ResubmitScreen> {
  TextEditingController submitMessageControllerr = TextEditingController();
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<UserProjectProvider>(context, listen: false)
            .toviewCompleteTaskProvider(widget.taskId));
    //          submitMessageControllerr = TextEditingController(
    //   text: widget.taskData.taskSubmitMessage,
    // );
  }

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

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProjectProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "📝 Task Details ",
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

                          final taskInfo =
                              provider.completeTaskApiResponse?.data;

                          if (taskInfo == null)
                            return const Text("No task found");

                          final completionDatee = DateTime.tryParse(
                              taskInfo.task!.completionDate!.substring(0, 10));
                          final submittedDatee = DateTime.tryParse(taskInfo
                              .submit!.taskSubmittedAt!
                              .substring(0, 10));
                          Duration diffrence =
                              submittedDatee!.difference(completionDatee!);
                          final bool overdue =
                              submittedDatee.isAfter(completionDatee);

                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                              child: Column(children: [
                                _infoRow(
                                    "TaskName", taskInfo.task!.taskName ?? ""),
                                _infoRow("Description",
                                    taskInfo.task!.taskDescription ?? ""),
                                _infoRow("Task Priority",
                                    taskInfo.task!.taskPriorityStatus ?? ""),
                                _infoRow("Task Status",
                                    taskInfo.task!.taskStatus ?? "",
                                    colorByValue: true),
                                _infoRow("Project",
                                    taskInfo.task!.project!.projectName ?? "-"),
                                _infoRow("Team",
                                    taskInfo.task!.team!.teamName ?? "-"),
                                _infoRow(
                                    "Allotment At",
                                    taskInfo.task!.allotmentDate!
                                        .substring(0, 10)),
                                _infoRow(
                                    "Completion At",
                                    taskInfo.task!.completionDate!
                                        .substring(0, 10)),
                                _infoRow("Created By",
                                    taskInfo.task!.createdBy!.userName ?? "-"),
                                _infoRow("Assigned To",
                                    taskInfo.task!.assignedTo!.userName ?? "-"),
                                _infoRow(
                                    "Review",
                                    taskInfo.submit!.submitTo!.userName! +
                                        " ( " +
                                        taskInfo.submit!.taskReviewAt!
                                            .substring(0, 10) +
                                        ")"),
                                // _infoRow(
                                //     "Submit At",
                                //     taskInfo.submit!.taskSubmittedAt!
                                //             .substring(0, 10) +
                                //         " " +
                                //         "( Overdue-" +
                                //         diffrence.inDays.toString() +
                                //         " " +
                                //         "Days )",
                                // ),
                                _infoRow(
                                    "submitAt",
                                    overdue
                                        ? completionDatee
                                                .toString()
                                                .substring(0, 10) +
                                            "OverDue"
                                        : completionDatee
                                                .toString()
                                                .substring(0, 10) +
                                            "   " +
                                            diffrence.inDays.toString() +
                                            "   " +
                                            "Days Before"),
                                //             .substring(0, 10) +)
                                //                    editableField("Submit Message", submitMessageControllerr,
                                // maxLines: 3),
                                SizedBox(height: 20),
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
                                              taskInfo.files!.isNotEmpty) ...[
                                            sectionTitle("Attached Files"),
                                            ...taskInfo.files!
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              final index = entry.key;
                                              final files = entry.value;
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              7 /
                                                              100,
                                                      child: Text(
                                                          "File ${index + 1} ${files.mimeType!.split('/').last}",
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          minimumSize: Size(10,
                                                              50), // Sets minimum width to 200 and height to 50
                                                        ),
                                                        icon: Icon(
                                                            Icons.download),
                                                        onPressed: () =>
                                                            _viewFile(
                                                                context,
                                                                files
                                                                    .downloadUrll,
                                                                files.mimeType,
                                                                "view"),
                                                        label: Text("view")),
                                                    ElevatedButton.icon(
                                                      label: Text("Download"),
                                                      icon:
                                                          Icon(Icons.download),
                                                      onPressed: () =>
                                                          // _downloadFile(file.downloadUrll),
                                                          _viewFile(
                                                              context,
                                                              files
                                                                  .downloadUrll,
                                                              files.mimeType,
                                                              "download"),
                                                    ),
                                                    Consumer<
                                                        UserProjectProvider>(
                                                      builder: (context, pro,
                                                          child) {
                                                        final fileId = files
                                                            .fileIdd; // use the file from the map's `entry`

                                                        final isDeleting = pro
                                                            .deletingFileIds
                                                            .contains(fileId);

                                                        return isDeleting
                                                            ? SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.2,
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )
                                                            : ElevatedButton
                                                                .icon(
                                                                label: Text(
                                                                    "Remove"),
                                                                icon: Icon(Icons
                                                                    .cancel),
                                                                onPressed:
                                                                    () async {
                                                                  final confirmed =
                                                                      await showLogoutConfirmationDialog(
                                                                          context);
                                                                  if (confirmed) {
                                                                    await pro
                                                                        .todeleteFileProvider(
                                                                            fileId);
                                                                  }
                                                                },
                                                              );
                                                      },
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
                              ]));
                        },
                      ),
                      //HERE WE WILL SUBMIT FILE AND IMAGE FROM GALLERY AND FILE MANAGER.............SHOW UPLOAD BUTTON
                      Consumer<UserDashboardProvider>(
                        builder: (context, pro, child) {
                          if (pro.isImage == false && pro.isFile == false) {
                            return Center(
                              child: AppButton(
                                text: 'Upload File',
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  final result =
                                      await showDialogBoxForImage(context);

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
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 40,
                                borderWidth: 0,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      //THIS CONSUMER METHOD SHOW MULTIPLE IMAGE FROM GALLERY.................
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
                                              child: const Icon(Icons.add,
                                                  size: 40),
                                            ),
                                          );
                                        }
                                        final img = images[index];
                                        return Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                        color: Colors.black54,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
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
                      //THIS CONSUMER METHOD SHOW THE FILE LIKE PDF EXCELL ,IMAGE FROM INTERNEL SPACE FROM MOBILE DEVICE AND SHOW ON UI
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
                                              child: const Icon(Icons.add,
                                                  color: Colors.blue),
                                            ),
                                            title: const Text(
                                              "Add more files",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
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
                                                prov.clearListFiles(index);
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
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      //THIS TEXT FILED INDICATED TO TEXT MESSAGE.............................................
                      TextField(
                        controller: submitMessageControllerr,
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
                                color:
                                    const Color.fromARGB(255, 191, 195, 189)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            //TASK RESUBMIT BUTTON BUTTON NAME SUBMIT.......................
            SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
            Consumer<UserProjectProvider>(
              builder: (context, provider, child) {
                if (provider.isResubmitask || provider.isSubmitFile) {
                  return const CircularProgressIndicator();
                }
                return Center(
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        final tasks = provider.completeTaskApiResponse?.data;

                        if (tasks == null) {
                          ShowTaostMessage.toastMessage(
                              context, "Task data not found");
                          return;
                        }

                        if (submitMessageControllerr.text.isEmpty) {
                          ShowTaostMessage.toastMessage(
                              context, "Enter resubmit messsage");
                        }
                        Map<String, dynamic> tojson = {
                          "message":
                              submitMessageControllerr.text.toString().trim(),
                          "submittedTo": tasks.submit!.submitTo!.userUid,
                          "parent": "Projects",
                          "child": tasks.task!.project!.projectName,
                          "team": tasks.task!.team!.teamName,
                          "userEid": tasks.task!.assignedTo!.userEid
                        };

                        final userDashBoard =
                            context.read<UserDashboardProvider>();

                        // Collect all files (docs + images)
                        List<String> files = [
                          ...userDashBoard.listOfFiles,
                          ...userDashBoard.listofImage,
                        ];
                        //this is out task id
                        int taskId = tasks.task!.taskId!;

                        await provider.toResubmitTask(taskId, tojson, files);
                        if (provider.error != null) {
                          ShowTaostMessage.toastMessage(
                            context,
                            "Task submitted, but file upload failed.",
                          );
                          return;
                        }
                        ShowTaostMessage.toastMessage(
                            context, "Submitted Successfully!");

                        //print(files.length);
                        //print(tojson);
                        submitMessageControllerr.clear();
                        userDashBoard.listOfFiles.clear();
                        userDashBoard.listofImage.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListOfUiScreen(),
                          ),
                        );
                      },
                      label: Text(
                        "submit",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )),
                );
              },
            )
          ]),
        )));
  }

  //OPEN DIALOG BOX FOR CONFORMATION ASK USE WANT DELETE OR NOT DELETE...
  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            // title: const Text("Thanks for  your effective work have a good day"),
            content: const Text("Do you want to remove this file"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("No"),
                  ),
                ],
              )
            ],
          ),
        ) ??
        false;
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

  Widget _infoRow(String title, String value,
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
}
//  Consumer<UserProjectProvider>(
//               builder: (context, taskInfo, child) {
//                 if (taskInfo.completeTaskApiResponse!.data != null) {
//                   print(taskInfo.completeTaskApiResponse!.data!.task!.taskId);
//                 }
//                 final istask = taskInfo.completeTaskApiResponse!.data != null;
//                 final tasks = taskInfo.completeTaskApiResponse!.data!;
//                 return istask
//                     ? ElevatedButton.icon(
//                         onPressed: () {
//                           Map<String, dynamic> tojson = {
//                             "message":
//                                 "Please resubmit with  with our filechanges date 11-10-25",
//                             "submittedTo": tasks.submit!.submitTo!.userUid,
//                             "parent": "Project",
//                             "child": tasks.task!.project!.projectName,
//                             "team": tasks.task!.team!.teamName,
//                             "userEid": tasks.task!.assignedTo!.userEid
//                           };
//                           print(tojson);
//                         },
//                         label: Text(
//                           "submit",
//                           style: TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.w600),
//                         ))
//                     : SizedBox.shrink();
//               },
//             ),
