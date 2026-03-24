import 'package:flutter/material.dart';

class Homelayoutcontroller extends ChangeNotifier {
// INCRESE HOME PAGE INDEX FOR CHANGE PAFE POSITION USING
  int pagePosition = 0;
  void homePageIncrement(int index) {
    print(pagePosition);
    pagePosition = index;
    notifyListeners();
  }
  void resetState() {
    pagePosition = 0;
    notifyListeners();
  }
}
