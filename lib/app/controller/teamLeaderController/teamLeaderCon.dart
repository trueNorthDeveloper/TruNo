import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeamleaderControllerPro extends ChangeNotifier {
  int counter = 0;
  void increaseCounterForTeam(int value) {
    counter = value;
    notifyListeners();
  }

  bool _changeIcn = true;
  bool get changeIcn => _changeIcn;
  void changeIcons() {
    _changeIcn = !changeIcn;
    notifyListeners();
  }

  final TextEditingController _allotmentDateController =
      TextEditingController();
  final TextEditingController _completionDateController =
      TextEditingController();

  DateTime? _allotmentDate;
  DateTime? _completionDate;

  TextEditingController get allotmentDateController => _allotmentDateController;
  TextEditingController get completionDateController =>
      _completionDateController;

  DateTime? get allotmentDate => _allotmentDate;
  DateTime? get completionDate => _completionDate;

  Future<void> selectDate({
    required BuildContext context,
    required bool isCompletionDate,
  }) async {
    final DateTime initialDate = isCompletionDate
        ? (_completionDate ?? DateTime.now())
        : (_allotmentDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    if (isCompletionDate) {
      _completionDate = picked;
      _completionDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    } else {
      _allotmentDate = picked;
      _allotmentDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }

    notifyListeners();
  }

  // bool _checkBoxTrue = false;
  // bool get checkBoxTrue => _checkBoxTrue;
  // void changeCheckBox() {
  //   _checkBoxTrue = !checkBoxTrue;
  //   notifyListeners();
  // }

  int _selectedFilterIndex = 0; // -1 means none selected

  int get selectedFilterIndex => _selectedFilterIndex;

  void selectFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  String filterData(int value) {
    switch (value) {
      case 0:
        return "All";
      case 1:
        return "PENDING";
      case 2:
        return "COMPLETED";
      case 3:
        return "REVIEW";
      default:
        return "All";
    }
  }
}
