import 'package:flutter/material.dart';

class ShowTaostMessage {
 // ShowTaostMessage();

  static toastMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
     
     backgroundColor: Color(0xfffb934d),
      
        duration: const Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),

        content:Center(child: Text(message)),
      ),
    );
  }
}
