import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/model/history/user_work_history_model.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/service/userServices/user_work_module_service_api.dart';

class UserDashboardProvider extends ChangeNotifier {
  final UserProjectService _service = UserProjectService();
  bool _changeColor = false;
  bool get changeColor => _changeColor;
  void chnageColorOnOff() {
    _changeColor = !_changeColor;
    notifyListeners();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changePostion(int index) {
    print("🔁 Setting currentIndex = $index");
    _currentIndex = index;
    notifyListeners();
  }

  int _initailCount = 0;

  int get initailCount => _initailCount;
//this provider for project details screen
  void chanageListview(int update) {
    _initailCount = update;
    notifyListeners();
  }

  // this provider for task detaails screeen
  int _intchangeColorInTaskDetail = 0;

  int get intchangeColorInTaskDetail => _intchangeColorInTaskDetail;
  void changeColorInTaskDetail(int indexNumber) {
    _intchangeColorInTaskDetail = indexNumber;
    notifyListeners();
  }

  List<String> _listofImage = [];

  List<String> get listofImage => _listofImage;
  final ImagePicker imagePicker = ImagePicker();
//select multiple image from gallery.......................
  void selectMutliImageFromGallery() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      List<String> item = selectedImages.map((item) => (item.path)).toList();
      _listofImage.addAll(item);
      notifyListeners();
    }
  }

//delte image from the list when user click on cross icon image will remove automatic from the list.
  void clearImageFromList(int index) {
    _listofImage.removeAt(index);
    notifyListeners();
  }

//here we will select muliple file from device just like image selected from the galllery.............
  List<String> _listOfFiles = [];
  List<String> get listOfFiles => _listOfFiles;

// Function to select multiple files
  void selectListOfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        // ✅ Collect valid file paths
        List<String> filesPath = result.paths
            .whereType<String>() // filters out nulls
            .toList();

        _listOfFiles.addAll(filesPath);
        notifyListeners();
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  void clearListFiles(int index) {
    try {
      _listOfFiles.removeAt(index);
      notifyListeners();
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  XFile? _pickImage;
  String? _filePath;
  bool _isImage = false;
  XFile? get pickImage => _pickImage;
  String? get filePath => _filePath;
  bool get isImage => _isImage;

//SET IMAGE.............
  void setImage(XFile file) {
    _pickImage = file;
    _filePath = file.path;
    _isImage = true;
    notifyListeners();
  }
  //SET fILE LIKE PDF DOC

  File? _file;
  bool _isFile = false;
  File? get file => _file;
  bool get isFile => _isFile;
  void setFile(File file) {
    _pickImage = null;
    _filePath = file.path;
    _file = file;
    _isFile = true;
    notifyListeners();
  }

  void clear() {
    _pickImage = null;
    _filePath = null;
    _file = null;
    _isImage = false;
    notifyListeners();
  }

  void clearFile() {
    _file = null;
    _isFile = false;
    _pickImage = null;
    _filePath = null;
    _file = null;
    _isImage = false;
    notifyListeners();
  }

  //datepicker....................
  int? userUid;
  Future<void> getUserBySharedPreferenceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('uuid');
    if (userId != null) {
      userUid = userId;
      notifyListeners();
    } else {
      // Handle null userId (e.g., show error or navigate to login)
    }
  }

  DateTime focusedDay = DateTime.now();
  Map<DateTime, List<dynamic>> events = {};

  Future<void> attendanceEvent(BuildContext context) async {
    events = {
      DateTime.utc(2025, 10, 1): ['Present'],
      DateTime.utc(2025, 10, 5): ['Absent'],
      DateTime.utc(2025, 10, 10): ['Present'],
      DateTime.utc(2025, 10, 14): ['Absent'],
      DateTime.utc(2025, 10, 15): ['Present'],
    };
    notifyListeners();
  }

  double _progress = 0.0;
  bool _isDownloading = false;
  String _downloadMessage = "Press the button to download";

  double get progress => _progress;
  bool get isDownloading => _isDownloading;
  String get downloadMessage => _downloadMessage;

  Future<void> downloadApk(String url) async {
    try {
      _isDownloading = true;
      _progress = 0.0;
      _downloadMessage = "Starting download...";
      notifyListeners();

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = "${appDocDir.path}/update.apk";

      await Dio().download(
        url,
        path,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _progress = received / total;

            final percent = (_progress * 100).toStringAsFixed(0);
            _downloadMessage = "Downloading... $percent%";

            notifyListeners();
          }
        },
      );

      _downloadMessage = "Download complete! Opening installer...";
      notifyListeners();

      await OpenFilex.open(path);

      _isDownloading = false;
      notifyListeners();
    } catch (e) {
      _isDownloading = false;
      _downloadMessage = "Download failed: $e";
      notifyListeners();
    }
  }

  UserWorkHistoryResponse? userWorkHistoryResponse;
  bool _isHistoryload = false;
  bool get isHistoryload => _isHistoryload;
  List<TaskDetails> _usWrkHistory = [];
  List<TaskDetails> get usWrkHistory => _usWrkHistory;
  ApiError? error;
  int _currentPage = 0;
  int _size = 10;
  int get currentPage => _currentPage;
  int get size => _size;

  // Future<void> userWorkHistory() async {
  //   _isHistoryload = true;
  //   error = null;
  //   notifyListeners();
  //   try {
  //     final historyResponse = await _service.getUserHistory(currentPage, size);
  //     if (historyResponse.isSuccess && historyResponse.data != null) {
  //       _usWrkHistory.addAll( historyResponse.data!.content);
  //       print(historyResponse.data!.page);
  //       print(historyResponse.data!.size);
  //       print(historyResponse.data!.last);

  //       print(historyResponse.data!.totalElements);
  //       print(historyResponse.data!.totalPages);
  //       if (historyResponse.data!.totalPages > _currentPage) {
  //         //  _currentPage++;

  //        // _usWrkHistory.addAll(historyResponse.data!.content);
  //         _currentPage++;
  //         notifyListeners();
  //       }
  //     }
  //   } catch (e) {}
  //   _isHistoryload = false;
  //   notifyListeners();
  // }
  bool _isLastPage = false;
  Future<void> userWorkHistory() async {
    if (_isHistoryload || _isLastPage) return;

    _isHistoryload = true;
    error = null;
    notifyListeners();

    try {
      final historyResponse =
          await _service.getUserHistory(_currentPage, _size);

      if (historyResponse.isSuccess && historyResponse.data != null) {
        final pageData = historyResponse.data!;

        _usWrkHistory.addAll(pageData.content);

        _isLastPage = pageData.last;
        _currentPage++;
      }
    } catch (e) {
      error = ApiError.invalidData;
    }

    _isHistoryload = false;
    notifyListeners();
  }

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  DateTime? _fromDate;
  DateTime? _toDate;

  TextEditingController get fromDateController => _fromDateController;
  TextEditingController get toDateController => _toDateController;

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  Future<void> selectDate({
    required BuildContext context,
    required bool isFromDate,
  }) async {
    final DateTime initialDate = isFromDate
        ? (_fromDate ?? DateTime.now())
        : (_toDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    if (isFromDate) {
      _fromDate = picked;
      _fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    } else {
      _toDate = picked;
      _toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }

    notifyListeners();
  }

  void clearDates() {
    _fromDate = null;
    _toDate = null;
    _fromDateController.clear();
    _toDateController.clear();
    notifyListeners();
  }

  int _leaveDays = 0;
  int get leaveDays => _leaveDays;
  void countLeaveDays() {
    String fromm = fromDateController.text;
    String too = toDateController.text;
    if (fromm.isNotEmpty && too.isNotEmpty) {
      int f = int.parse(fromm.substring(8, 10));
      int t = int.parse(too.substring(8, 10));
      _leaveDays = t - f;
    }
  }

  ///-------------------------------------------------------------to do list item............
  List<Map<String, dynamic>> todo = [
    {
      "name": "ABC",
      "date": "01-2026",
      "done": false,
    },
    {
      "name": "Buy Milk",
      "date": "02-2026",
      "done": true,
    },
  ];
  final List<Map<String, dynamic>> personal = [
    {
      "name": "ABC",
      "date": "01-2026",
      "done": false,
    },
    {
      "name": "Buy Milk",
      "date": "02-2026",
      "done": true,
    },
  ];
  final List<Map<String, dynamic>> work = [
    {
      "name": "ABC",
      "date": "01-2026",
      "done": false,
    },
    {
      "name": "Buy Milk",
      "date": "02-2026",
      "done": true,
    },
  ];
  int currentTool = 0;
  String  _currentName="Office-Tools";
  String get currentName=>_currentName;
  void increaseToolCounter(int counter,String updateName) {
    currentTool = counter;
    _currentName=updateName;
    notifyListeners();
  }
}
