import 'dart:core';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/dailyExpenseReponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseCategoryResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseDynamicFieldResponseModel.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/myBalanceResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/transactionHistoryResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/service/expenseModuleService.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class Expensecontroller extends ChangeNotifier {
  Expensemoduleservice _service = Expensemoduleservice();

//expense with calendar.............................
  DateTime? _focusedDay = DateTime.now();
  DateTime? get focusedDay => _focusedDay;

  DateTime _firstDay = new DateTime(2025, 1, 1);
  DateTime get firstDay => _firstDay;
  DateTime _lastDay = new DateTime(2030, 12, 30);
  DateTime get lastDay => _lastDay;
  final DateTime? _currentDay = DateTime.now();
  final List<Map<String, dynamic>> monthAmount = [
    {
      "date": "01-05-2026",
      "dayTotalAmount": 10202,
      "petrol": 120,
      "rent": 1000,
      "loading": 500,
      "siteItem": 120,
      "breakFast": 80,
      "luch": 120,
      "dinner": 120,
      "travel": 50,
      "bike": 60,
      "boat": 150,
      "labour": 500,
      "water": 50,
      "vehical": 600,
      "stationary": 20,
      "grocery": 130,
      "other": 30
    },
    {
      "date": "02-05-2026",
      "dayTotalAmount": 10201,
      "petrol": 120,
      "rent": 1000,
      "loading": 500,
      "siteItem": 120,
      "breakFast": 80,
      "luch": 120,
      // "dinner": 120,
      // "travel": 50,
      // "bike": 60,
      // "boat": 150,
      // "labour": 500,
      // "water": 50,
      // "vehical": 600,
      // "stationary": 20,
      // "grocery": 130,
      // "other": 30
    },
    {
      "date": "03-05-2026",
      "dayTotalAmount": 1020333,
      "petrol": 120,
      // "rent": 1000,
      // "loading": 500,
      // "siteItem": 120,
      // "breakFast": 80,
      // "luch": 120,
      // "dinner": 120,
      // "travel": 50,
      // "bike": 60,
      // "boat": 150,
      "labour": 500,
      "water": 50,
      "vehical": 600,
      // "stationary": 20,
      // "grocery": 130,
      // "other": 30
    },
    {
      "date": "04-05_2026",
      "dayTotalAmount": 10202,
      // "petrol": 120,
      // "rent": 1000,
      // "loading": 500,
      // "siteItem": 120,
      // "breakFast": 80,
      // "luch": 120,
      // "dinner": 120,
      // "travel": 50,
      // "bike": 60,
      // "boat": 150,
      // "labour": 500,
      // "water": 50,
      "vehical": 600,
      "stationary": 20,
      "grocery": 130,
      "other": 30
    },
  ];
  Map<String, dynamic> itemAmount = {};
  void callexpenseAmountDateWise(dynamic date) {
    print("------${date}");
    for (var element in monthAmount) {
      if (element["date"] == date) {
        itemAmount = element;
        break;
      }
    }
    notifyListeners();
  }

  ///change textFiled....................
  int setValue = 0;
  void setIndexValue(int val) {
    setValue = val;
    notifyListeners();
  }

//BY USING THIS METHOD SELECT MULTIPLE IMAGE FROM GALLLEY
  bool _isImage = false;
  bool get isImage => _isImage;
  List<String> _listofImage = [];

  List<String> get listofImage => _listofImage;
  final ImagePicker imagePicker = ImagePicker();
  void selectMutlipleImageFromGallery() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages == null || selectedImages.isEmpty) {
      return;
    }
    _listofImage.addAll(
      selectedImages.map((e) => e.path),
    );
    _isImage = true;

    notifyListeners();
  }

//CLEAR IMAGE ON TAB CLOSE BUTTON
  void clearImageList(int index) {
    _listofImage.removeAt(index);
    if (_listofImage.isEmpty) {
      _isImage = false;
    }

    notifyListeners();
  }

  bool _isFile = false;
  File? get file => _file;
  File? _file;
  bool get isFile => _isFile;
  List<String> _listOfFilesPdfDoc = [];
  List<String> get listOfFilesPdfDoc => _listOfFilesPdfDoc;
  void selectPdfDocFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null && result.files.isNotEmpty) {
        List<String> filePath = result.paths.whereType<String>().toList();
        _listOfFilesPdfDoc.addAll(filePath);
        _isFile = true;
        notifyListeners();
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  void clearListFiles(int index) {
    try {
      _listOfFilesPdfDoc.removeAt(index);
      if (_listOfFilesPdfDoc.isEmpty) {
        _isFile = false;
      }
      notifyListeners();
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  void clearAllAttachments() {
    _listofImage.clear();
    _listOfFilesPdfDoc.clear();
    _isImage = false;

    _isFile = false;

    //selectedFile = null; // if you have pdf/file

    notifyListeners();
  }

  void resetControllerState() {
    _listofImage.clear();
    _listOfFilesPdfDoc.clear();

    _isImage = false;
    _isFile = false;
    notifyListeners();
  }

  DateTime selectedDate = DateTime.now();
  // final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  // final DateFormat dateFormat = DateFormat('dd-MM-yyyy'); // UI Display format
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd'); // API format

  //RETRIVE DYNAMIC FILED......................................
  bool _showAllField = false;
  bool get showAllField => _showAllField;
  List<DynamicField> _dynamicField = [];
  List<DynamicField> get dynamicField => _dynamicField;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  final Map<int, List<DynamicField>> _dynamicFieldCache = {};

  Future<void> dynamicFormField(int categoryId) async {
    // if (_dynamicFieldCache.containsKey(categoryId)) {
    //   _dynamicField = _dynamicFieldCache[categoryId]!;
    //   notifyListeners();
    //   return;
    // }

    // _showAllField = true;
    // _errorMessage = null;
    // notifyListeners();
    // try {
    //   final output = await _service.fatchDynamicFieldReponse(categoryId);
    //   if (output.isSuccess) {
    //     _dynamicField = output.data.data;
    //     _dynamicFieldCache[categoryId] =
    //         List<DynamicField>.from(output.data.data);
    //   }
    // } catch (e) {
    //   _errorMessage = e.toString();
    // } finally {
    //   _showAllField = false;
    //   notifyListeners();
    if (_dynamicFieldCache.containsKey(categoryId)) {
      _dynamicField = _dynamicFieldCache[categoryId]!;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _showAllField = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final output = await _service.fatchDynamicFieldReponse(categoryId);
      if (output.isSuccess) {
        _dynamicField = output.data.data;
        _dynamicFieldCache[categoryId] =
            List<DynamicField>.from(output.data.data);
      } else {
        _dynamicField = []; // don't leak previous category's fields
        _errorMessage = output.message ?? "Failed to load fields";
      }
    } catch (e) {
      _dynamicField = [];
      _errorMessage = e.toString();
    } finally {
      _showAllField = false;
      notifyListeners();
    }
  }

  void updateFieldValue(String fieldName, dynamic value) {
    notifyListeners();
  }

  ///fatth user account balance datw 2-7-26
  bool _showBalance = false;
  bool get showBalance => _showBalance;

  MyBalanceRespone? _myBalanceResponse;

  MyBalanceRespone? get myBalanceResponse => _myBalanceResponse;

  Future<void> getMyAccountBalace() async {
    _showBalance = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final balance = await _service.fatchMyAccountBalance();
      if (balance.isSuccess) {
        _myBalanceResponse = balance.data;
        //print(balance.data);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _showBalance = false;
      notifyListeners();
    }
  }

  //----------------------------------------------------------
  //user account transcation using pagination...........
  bool _isLoadTranscation = false;
  bool get isLoadTranscation => _isLoadTranscation;

  List<TransactionContent> _transcationHistory = [];
  List<TransactionContent> get transcationHistory => _transcationHistory;

  int _currentPage = 0;
  final int _size = 10;
  bool _isLastPage = false;
  ApiError? error;

  Future<void> fatchTranscationHistory() async {
    if (_isLoadTranscation || _isLastPage) return;

    _isLoadTranscation = true;
    error = null;
    notifyListeners();

    try {
      final transcationResponse =
          await _service.fatchAccountHistory(_currentPage, _size);
      if (transcationResponse.isSuccess && transcationResponse.data != null) {
        final pageData = transcationResponse.data!;

        if (pageData.content != null) {
          _transcationHistory.addAll(pageData.content!);
        }
        _isLastPage = pageData.last ?? true;
        _currentPage++;
      } else {
        error = transcationResponse.error;
      }
    } catch (e) {
      error = ApiError.unknown;
    } finally {
      _isLoadTranscation = false;
      notifyListeners();
    }
  }

  ///GET USER DAILT EXPENSE MONTH AND DAY WISE.........................
  //*USED MAIN CLASS......................
  //CALLING FINAL METHOD
  DateTime curreentDate = DateTime.now();
  DateTime? chosenDate;
  // final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  // UI Display format
  final DateFormat dateFormarte = DateFormat('yyyy-MM');
  Future<void> callingDailyExpense() async {
    int month = curreentDate.month;
    int year = curreentDate.year;
    await dailyExpenseMethod(year, month);
  }

  void resetDate2() {
    curreentDate = DateTime.now();
    chosenDate = DateTime.now();
    selectedDaySummary = null;
    //  notifyListeners();
  }

  DailyExpenseRespone? dailyExpenseRespone;
  bool isLoadDailyExpense = false;
  String? _lastFetchedMonth;
  Map<DateTime, DailySummary> _summaryByDate = {};
  DailySummary? selectedDaySummary;
  Map<DateTime, DailySummary> get summaryByDate => _summaryByDate;
  Future<void> dailyExpenseMethod(dynamic year, dynamic month) async {
    final key = "$year-$month";
    if (_lastFetchedMonth == key) {
      print("⚠️ Already fetched for $key");
      return;
    }
    isLoadDailyExpense = true;
    notifyListeners();
    try {
      final response = await _service.dailyExpenseService(year, month);

      if (response.isSuccess && response.data != null) {
        //assigned json data into class.....
        dailyExpenseRespone = response.data;
        _lastFetchedMonth = key;
        _buildLookupMap();
      }
    } catch (e) {
      print("❌ API Error: ${e}");
    } finally {
      isLoadDailyExpense = false;
      notifyListeners();
    }
  }

  void _buildLookupMap() {
    _summaryByDate = {};
    final summaries = dailyExpenseRespone?.data?.dailySummaries ?? [];
    for (final s in summaries) {
      final date = DateTime.parse(s.expenseDate); // "2026-07-13" -> DateTime
      final normalized = DateTime(date.year, date.month, date.day);
      _summaryByDate[normalized] = s;
    }
  }

  void selectDay(DateTime day) {
    chosenDate = day; // Save the clicked day reference
    final normalized = DateTime(day.year, day.month, day.day);
    selectedDaySummary = _summaryByDate[normalized];
    notifyListeners(); // This triggers the UI layout to rebuild and show categories
  }

  //DATE SHOW DATE CONTROLLER...................
// ======================================================START===================
// Used for category screen navigation
  DateTime categoryDate = DateTime.now();

// Used while submitting expense form
  DateTime submitDate = DateTime.now();

// Future: another report/date filter
  DateTime reportDate = DateTime.now();
//STEP:1 CALL FISRT API IN INTI STATE USIN CURRENT DATE
  final DateFormat dateFormat2 = DateFormat('yyyy-MM-dd');
  Future<void> callCategoryFirstTime() async {
    await fatchExpenseCategory(
      dateFormat2.format(categoryDate),
    );
  }

//CALL MAIN API USING THIS METHOD.................
  Map<String, List<ExpenseCategory>> _mapExCat = {};
  Map<String, List<ExpenseCategory>> get mapExCat => _mapExCat;
  Future<void> fatchExpenseCategory(String date,
      {bool forceRefresh = false}) async {
    if (_mapExCat.containsKey(date) && !forceRefresh) {
      print("already fetched for this date................");
      return;
    }

    _isLoadExpenseCategory = true;
    notifyListeners();

    try {
      final response = await _service.fatchExpenseCategory(date);
      if (response.isSuccess) {
        exresponse = response.data;

        _mapExCat[date] = exresponse?.data ?? [];
      }
      else
      {
        _errorMessage = response.message ?? "Failed to load categorie";
      }
      
    } catch (e) {
      print("Error fetching categories: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoadExpenseCategory = false;
      notifyListeners();
    }
  }

//CALLING CATEGORY DATE WISE...........................
  Future<void> changeCategoryDate(int days) async {
    // categoryDate = categoryDate.add(Duration(days: days));
    // if (newDate.isAfter(DateTime.now())) return; // block future dates
    // submitDate = categoryDate;
    final newDate = categoryDate.add(Duration(days: days));
    if (newDate.isAfter(DateTime.now())) return; // block future dates

    categoryDate = newDate;
    submitDate = newDate;

    await fatchExpenseCategory(
      formateDate.format(categoryDate),
    );

    notifyListeners();
  }

  //reset categoryList....
  // void resetListOfCategory() {
  //   _mapExCat.clear();
  //   _dynamicField.clear();
  // }
  void resetListOfCategory() {
    _mapExCat.clear();
    _dynamicField.clear();
    _dynamicFieldCache.clear();
    _lastFetchedMonth =
        null; // if this exists from your calendar caching work — reset that too
    notifyListeners();
  }
//=========================================================END=====================

  DateTime selectDate = DateTime.now();
  final DateFormat disireDateFormate = DateFormat('yyyy-MM-dd');
  //var formattedDate;
  final DateFormat formateDate = DateFormat('yyyy-MM-dd');

  //NEXT STEP  FIR NEXT DAY AND BACK DATE

  // Future<void> callCategoryFirstTime() async {
  //   String formattedDate = disireDateFormate.format(selectDate);
  //   fatchExpenseCategory(formattedDate);
  // }

  // void nextDayAndPreviousDay(int day) {
  //   selectDate = selectDate.add(Duration(days: day));
  //   String formattedDate = .format(selectDate);

  //   // Triggers API call automatically when user taps the arrows
  //   fatchExpenseCategory(formattedDate);
  //   notifyListeners();
  // }

  bool _isLoadExpenseCategory = false;
  bool get isLoadExpenseCategory => _isLoadExpenseCategory;

  // List<ExpenseCategory> _expCateList = [];

  Map<DateTime, ExpenseCategory> _mapExpenseCat = {};
  Map<DateTime, ExpenseCategory> get mapExpenseCat => _mapExpenseCat;
  String? _lastFetchedDate;
  //date category
  ExpenseCategory? expenseCategory;
  ExpenseCategoryResponse? exresponse;

// 2. Fetch the category list safely using a date string
  List<ExpenseCategory> getCategoriesForDate(String dateString) {
    return _mapExCat[dateString] ?? [];
  }

// 3. Fix the mapping method to assign the complete list to the date key
  void _buildDailyLookup(String key) {
    // Directly attach the full category list to the unique date string key
    _mapExCat[key] = exresponse?.data ?? [];
  }

  Future<void> refreshExpenseCategory(String date) async {
    _isLoadExpenseCategory = true;
    notifyListeners();

    try {
      final response = await _service.fatchExpenseCategory(date);

      if (response.isSuccess) {
        // _expCateList = response.data.data;
      }
    } catch (e) {
      //  catError = ApiError.unknown;
    } finally {
      _isLoadExpenseCategory = false;
      notifyListeners();
    }
  }

  //EXPENSE SERVICE............................................................

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;
  String? submitError;

  Future<bool> submitExpense(
    int categoryId,
    String expenseDate,
    double expenseAmount,
    List<Map<String, dynamic>> dynamicFields,
    List<String> files,
  ) async {
    _isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final payload = {
        "categoryId": categoryId,
        "expenseDate": expenseDate,
        "expenseAmount": expenseAmount,
        "dynamicFields": dynamicFields,
      };

      final response = await _service.submitExpense(payload, files);

      if (response.isSuccess) {
        return true;
      } else {
        submitError = response.message ?? "Expense submission failed";
        return false;
      }
    } catch (e) {
      submitError = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
  void clearDynamicField() {
  _dynamicField = [];
  notifyListeners();
}
}
