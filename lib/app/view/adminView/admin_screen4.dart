import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class AdminUiScreen4 extends StatefulWidget {
  const AdminUiScreen4({super.key});

  @override
  State<AdminUiScreen4> createState() => _AdminUiScreen4State();
}

class _AdminUiScreen4State extends State<AdminUiScreen4> {
  Widget build(BuildContext context) {
    SizeConFig.init(context);
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
                height: SizeConFig.screenHeight,
                width: SizeConFig.screenWidth,
                child: Column(children: [
                  Center(
                    child:Text("screen  4"),
                  )
                  
         ]
         ))));
  }
}
