import 'dart:core';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy'); // UI Display format
  final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd'); // API format
  void changeDate(int days) async {
    selectedDate = selectedDate.add(Duration(days: days));

    await fetchExpenseCategoryBySelectedDate();
    notifyListeners();
  }

  //show category
  bool isCategoryLoading = false;
  Future<void> fetchExpenseCategoryBySelectedDate() async {
    isCategoryLoading = true;
    notifyListeners();
    String formateDate = apiDateFormat.format(selectedDate);
    print(formateDate);
    await fatchExpenseCategory(formateDate);
    isCategoryLoading = false;
    notifyListeners();
  }

//RESET DATE WITH CURRENT DATE
  void resetDate() {
    selectedDate = DateTime.now();
  }

//EXPENSE CATEGORY PROVIDER METHOD..............................
  bool _isLoadExpenseCategory = false;
  bool get isLoadExpenseCategory => _isLoadExpenseCategory;
  List<ExpenseCategory> _expCateList = [];
  List<ExpenseCategory> get expenseCateList => _expCateList;
  ApiError? catError;
  bool get hasExpenseCategory => _expCateList.isNotEmpty;
  Future<void> fatchExpenseCategory(String date,
      {bool forceRefresh = false}) async {
    if (_expCateList.isNotEmpty && !forceRefresh) {
      return;
    }
    _isLoadExpenseCategory = true;
    catError = null;
    notifyListeners();
    try {
      final response = await _service.fatchExpenseCategory(date);

      if (response.isSuccess) {
        _expCateList = response.data.data;
      } else {
        catError = response.error;
      }
    } catch (e) {
      _expCateList = [];
      catError = ApiError.unknown;
    } finally {
      _isLoadExpenseCategory = false;
      notifyListeners();
    }
  }

  Future<void> refreshExpenseCategory(String date) async {
    _isLoadExpenseCategory = true;
    notifyListeners();

    try {
      final response = await _service.fatchExpenseCategory(date);

      if (response.isSuccess) {
        _expCateList = response.data.data;
      }
    } catch (e) {
      catError = ApiError.unknown;
    } finally {
      _isLoadExpenseCategory = false;
      notifyListeners();
    }
  }

  //RETRIVE DYNAMIC FILED......................................
  bool _showAllField = false;
  bool get showAllField => _showAllField;
  List<DynamicField> _dynamicField = [];
  List<DynamicField> get dynamicField => _dynamicField;
  String? _errorMessage;
  final Map<int, List<DynamicField>> _dynamicFieldCache = {};

  Future<void> dynamicFormField(int categoryId) async {
    if (_dynamicFieldCache.containsKey(categoryId)) {
      _dynamicField = _dynamicFieldCache[categoryId]!;
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
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _showAllField = false;
      notifyListeners();
    }
  }

  void updateFieldValue(String fieldName, dynamic value) {
    // _formValues[fieldName] = value;
    notifyListeners();
  }

  ///fatth user account balance datw 2-7-26
  bool _showBalance = false;
  bool get showBalance => _showBalance;
  // MyBalanceRespone?  _myBalanceRespone;
  // MyBalanceRespone get MyBalanceRespone => _myBalanceRespone;
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

  //EXPENSE SUBMIT CONTROLLER ................
  bool _isSubmitExpense = false;
  bool get isSubmitExpense => _isSubmitExpense;

  Future<void> expenseSubmitCoontroller() async {
    _isSubmitExpense = true;
    notifyListeners();
    try {
      //final requestResponse = await _service.submitExpenseService();
      //if (requestResponse!.isSuccess) {}
    } catch (e) {
    } finally {
      _isSubmitExpense = false;
      notifyListeners();
    }
  }
}
