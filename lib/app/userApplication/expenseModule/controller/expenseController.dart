import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expensecontroller extends ChangeNotifier {
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
}
