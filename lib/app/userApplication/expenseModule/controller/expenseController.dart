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

//clear dynamic form befor fatch data..........................
  Future<void> clearFormField() async {
    _dynamicField.clear();
    _dynamicFieldCache.clear();
    print("from--------------------------------------------clear");
  }

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
  bool get isLastPage => _isLastPage;
  ApiError? error;

  Future<void> fatchTranscationHistory({bool onRefresh = false}) async {
    if (_isLoadTranscation || _isLastPage && !onRefresh) return;

    _isLoadTranscation = true;
    error = null;
    notifyListeners();
    if (onRefresh) {
      _currentPage = 0;
      _isLastPage = false;
      _transcationHistory.clear();
    }

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

  //==================================start===show daily expense calendar
  DailyExpenseRespone? dailyExpenseRespone;
  bool isLoadDailyExpense = false;
  String? dailyExpenseError;
  DateTime curreentDate = DateTime.now();
  DateTime? chosenDate;
  Map<DateTime, DailySummary> _summaryByDate = {};
  DailySummary? selectedDaySummary;
  Map<DateTime, DailySummary> get summaryByDate => _summaryByDate;
  final Map<String, DailyExpenseRespone> _monthCache = {};
  final Set<String> _fetchedMonths = {};
  String _monthKey(int year, int month) => "$year-$month";
  // UI Display format
  //final DateFormat dateFormarte = DateFormat('yyyy-MM');
  // -------------------------------------------------------------
  // Call on screen enter (initState). Always hits the API fresh
  // for the current month and refreshes that month's cache entry.
  // -------------------------------------------------------------
  Future<void> callingDailyExpense() async {
    await dailyExpenseMethod(curreentDate.year, curreentDate.month,
        forceRefresh: true);
    // int month = curreentDate.month;
    // int year = curreentDate.year;
    // await dailyExpenseMethod(year, month);
  }

  //String? _lastFetchedMonth;

// -------------------------------------------------------------
  // Call on month change (onPageChanged in TableCalendar).
  // Uses cached data if available; fetches only if missing.
  // -------------------------------------------------------------
  Future<void> onMonthChanged(DateTime focusedDay) async {
    curreentDate = focusedDay;
    selectedDaySummary = null;
    chosenDate = null;
    await dailyExpenseMethod(focusedDay.year, focusedDay.month,
        forceRefresh: false);
  }

  // -------------------------------------------------------------
  // Optional: pull-to-refresh / retry button on the current month
  // -------------------------------------------------------------
  Future<void> refreshCurrentMonth() async {
    await dailyExpenseMethod(curreentDate.year, curreentDate.month,
        forceRefresh: true);
  }

  Future<void> dailyExpenseMethod(int year, int month,
      {bool forceRefresh = false}) async {
    final key = _monthKey(year, month);
    if (!forceRefresh && _fetchedMonths.contains(key)) {
      final cached = _monthCache[key];
      if (cached != null) {
        dailyExpenseRespone = cached;
        dailyExpenseError = null;
        _buildLookupMap();
        notifyListeners();
        return;
      }
    }

    isLoadDailyExpense = true;
    dailyExpenseError = null;
    notifyListeners();
    try {
      final response = await _service.dailyExpenseService(year, month);

      if (response.isSuccess && response.data != null) {
        //assigned json data into class.....

        dailyExpenseRespone = response.data;
        _monthCache[key] = response.data!;
        _fetchedMonths.add(key);
        _buildLookupMap();
      } else {
        dailyExpenseError = "Something went wrong Please try again?";
      }
    } catch (e) {
      //print("❌ API Error: ${e}");
      dailyExpenseError = "Something went wrong. Please try again.";
    } finally {
      isLoadDailyExpense = false;
      notifyListeners();
    }
  }

  void _buildLookupMap() {
    // _summaryByDate = {};\
    final map = <DateTime, DailySummary>{};
    final summaries = dailyExpenseRespone?.data?.dailySummaries ?? [];
    for (final s in summaries) {
      try {
        final date = DateTime.parse(s.expenseDate); // "2026-07-13" -> DateTime
        map[DateTime(date.year, date.month, date.day)] = s;
      } catch (_) {
        // skip malformed date entries instead of crashing the w
      }
    }
    _summaryByDate = map;
  }

  //clear daily summary when switch month...
  void clearDailySummary() {
    //  _summaryByDate.clear();
    selectedDaySummary = null;
    chosenDate = null;
    notifyListeners();
    print("clear daily summary");
  }

  void selectDay(DateTime day) {
    chosenDate = day; // Save the clicked day reference
    final normalized = DateTime(day.year, day.month, day.day);
    selectedDaySummary = _summaryByDate[normalized];
    notifyListeners(); // This triggers the UI layout to rebuild and show categories
  }

  // Clears ALL cached months — use for logout, pull-to-refresh-everything,
  // or after an action that could change historical data (e.g. deleting
  // an expense from a past month).
  void resetFetchCache() {
    _monthCache.clear();
    _fetchedMonths.clear();
  }

  void invalidateMonth(int year, int month) {
    final key = _monthKey(year, month);
    _monthCache.remove(key);
    _fetchedMonths.remove(key);
  }

  DateTime selectDate = DateTime.now();
  final DateFormat disireDateFormate = DateFormat('yyyy-MM-dd');
  //var formattedDate;
  // final DateFormat formateDate = DateFormat('yyyy-MM-dd');

  bool _isLoadExpenseCategory = false;
  bool get isLoadExpenseCategory => _isLoadExpenseCategory;

  // List<ExpenseCategory> _expCateList = [];

  Map<DateTime, ExpenseCategory> _mapExpenseCat = {};
  Map<DateTime, ExpenseCategory> get mapExpenseCat => _mapExpenseCat;

  //date category
  ExpenseCategory? expenseCategory;
  ExpenseCategoryResponse? exresponse;

// 2. Fetch the category list safely using a date string
  List<ExpenseCategory> getCategoriesForDate(String dateString) {
    return _mapExCat[dateString] ?? [];
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

  //EXPENSE SERVICE............................................................start=----------------submit expense....

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
  //------------------------------------------------------------end expense submit---------------

  // ======================================================START===================
// Used for category screen navigation
//IT WILL SHOW CURRENT DATE----------------------ON UI------------------
  final DateFormat formateDate = DateFormat('yyyy-MM-dd');
  DateTime categoryCurrentDate = DateTime.now();
  //DateTime selectedDate = DateTime.now();

// Used while submitting expense form
  DateTime submitDate = DateTime.now();

// Future: another report/date filter
  // DateTime reportDate = DateTime.now();
//STEP:1 CALL FISRT API IN INTI STATE USIN CURRENT DATE

//CALLING CATEGORY DATE WISE...........................
  Future<void> changeCategoryDate(int days) async {
    final newDate = categoryCurrentDate.add(Duration(days: days));
    if (newDate.isAfter(DateTime.now())) return; // block future dates

    categoryCurrentDate = newDate;
    submitDate = newDate;

    await fatchExpenseCategory(
      formateDate.format(categoryCurrentDate),
    );

    notifyListeners();
  }

  Future<void> onRefeshDate({forceRefrsh}) async {
    categoryCurrentDate = DateTime.now();
    await fatchExpenseCategory(formateDate.format(categoryCurrentDate),
        forceRefresh: forceRefrsh);
    //clear dynamic from............when user refresh screen
    await clearFormField();

    notifyListeners();
  }

//=================================================END=====================
  //EXPENSE CATEGORY SHOW AND DYNAMIC FORM SHOW================START===========================

  final DateFormat dateFormat2 = DateFormat('yyyy-MM-dd');
  Future<void> callCategoryFirstTime({forceRefresh}) async {
    await fatchExpenseCategory(dateFormat2.format(categoryCurrentDate),
        forceRefresh: forceRefresh);
  }

  //CALL MAIN API USING THIS METHOD.................
  Map<String, List<ExpenseCategory>> _mapExCat = {};
  Map<String, List<ExpenseCategory>> get mapExCat => _mapExCat;
  Future<void> fatchExpenseCategory(String date,
      {bool forceRefresh = false}) async {
    if (_mapExCat.containsKey(date) && !forceRefresh) {
      print("-----------------------------------------------${date}");
      print("already fetched for this date................");
      return;
    }
    print("------------------------------------catDate${date}");
    _isLoadExpenseCategory = true;
    notifyListeners();

    try {
      final response = await _service.fatchExpenseCategory(date);
      if (response.isSuccess) {
        exresponse = response.data;

        _mapExCat[date] = exresponse?.data ?? [];
      } else {
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

  //===========================================================END=============================

  //-----------------------------------UPDATE EXPENSE 2-9-26
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  Map<String, dynamic> tomap = {};

  String? _updateError;
  String? get updateError => _updateError;

  Future<bool> expenseUpdate(Map<String, dynamic> toJson) async {
    _isUpdate = true;
    _updateError = null;
    tomap = {};

    notifyListeners();

    try {
      final response = await _service.expenseUpdateService(toJson);

      if (response.isSuccess) {
        tomap = response.data ?? {};
        return true;
      }

      _updateError = response.message ?? "Unable to update expense.";

      return false;
    } catch (e) {
      debugPrint("Expense update error: $e");

      _updateError = e.toString();

      return false;
    } finally {
      _isUpdate = false;
      notifyListeners();
    }
  }
}
