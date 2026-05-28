import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseCategoryResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseDynamicFieldResponseModel.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/service/expenseModuleService.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';

import '../model/expenseDynamicFieldResponseModel.dart';

class Expensecontroller extends ChangeNotifier {
  Expensemoduleservice _service = Expensemoduleservice();
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  //yyyy-MM-dd');
  //CHANGE DATE ON CLICK BUTTON
  void changeDate(int days) async {
    selectedDate = selectedDate.add(Duration(days: days));
    notifyListeners();
  }

//RESET DATE WITH CURRENT DATE
  void resetDate() {
    selectedDate = DateTime.now();
  }

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
    if (selectedImages!.isNotEmpty) {
      List<String> item = selectedImages.map((item) => (item.path)).toList();
      _listofImage.addAll(item);
      _isImage = true;
      notifyListeners();
    }
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

  void resetControllerState() {
    _listofImage.clear();
    _listOfFilesPdfDoc.clear();
    _isImage = false;
    _isFile = false;
    notifyListeners();
  }

//EXPENSE CATEGORY PROVIDER METHOD..............................
  bool _isLoadExpenseCategory = false;
  bool get isLoadExpenseCategory => _isLoadExpenseCategory;
  List<ExpenseCategory> _expCateList = [];
  List<ExpenseCategory> get expenseCateList => _expCateList;
  ApiError? catError;
  Future<void> fatchExpenseCategory() async {
    _isLoadExpenseCategory = true;
    catError = null; 
    notifyListeners();
    try {
      final response = await _service.fatchExpenseCategory();

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

  //RETRIVE DYNAMIC FILED......................................
  bool _showAllField = false;
  bool get showAllField => _showAllField;
  List<DynamicField> _dynamicField = [];
  List<DynamicField> get dynamicField => _dynamicField;
  String? _errorMessage;

  Future<void> dynamicFormField(int id) async {
    _showAllField = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final output = await _service.fatchDynamicFieldReponse(id);
      if (output.isSuccess) {
        _dynamicField = output.data.data;
        
        
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
}
