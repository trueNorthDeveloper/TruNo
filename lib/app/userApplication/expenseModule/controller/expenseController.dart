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
}
