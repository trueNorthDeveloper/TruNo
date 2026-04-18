import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_createProject_screen.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_registration_for_user_account_model.dart';

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
//here i will use list api for list of user...............

  // List<UserRegistration> users = [
  //   UserRegistration(
  //     uuid: 1,
  //     empName: "jely",
  //     empId: 'TNE01',
  //   ),
  //   UserRegistration(
  //     uuid: 2,
  //     empName: "henry",
  //     empId: 'TNE02',
  //   ),
  //   UserRegistration(
  //     uuid: 3,
  //     empName: "micel",
  //     empId: 'TNE03',
  //   ),
  //   UserRegistration(
  //     uuid: 4,
  //     empName: "jony",
  //     empId: 'TNE04',
  //   ),
  //   UserRegistration(
  //     uuid: 5,
  //     empName: "kelecy",
  //     empId: 'TNE05',
  //   ),
  //   UserRegistration(
  //     uuid: 6,
  //     empName: "follpy",
  //     empId: 'TNE06',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  //   UserRegistration(
  //     uuid: 7,
  //     empName: "narro",
  //     empId: 'TNE08',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return getWidgetByIndex(index, context);
      },
    );
  }

  Widget getWidgetByIndex(int index, BuildContext context) {
    switch (index) {
      case 0:
        return allUserCustomBox();
      case 1:
        return createProject(context);
      case 2:
        return allUserCustomBox();
      case 3:
        return buildTextTile("Text Content");
      case 4:
        return allUserCustomBox();
      case 5:
        return buildButtonTile();
      default:
        return Container(color: Colors.grey);
    }
  }

  Widget allUserCustomBox() {
    return GestureDetector(
      onTap: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? id=prefs.getString("empId");
              String? pass=prefs.getString("empName");
              print("${id}"+"${pass}");

       
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: const Center(
          child: Text("get data", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget createProject(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminCreateprojectScreen()));
      },
      child: Container(
        color: Colors.orange.shade100,
        alignment: Alignment.center,
        child: const Text("Project", style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget buildTextTile(String text) {
    return Container(
      color: Colors.orange.shade100,
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }

  // Widget buildIconTile() {
  //   return SingleChildScrollView(
  //     child: Container(
  //       decoration: BoxDecoration(
  //           border: Border.all(width: 0.5),
  //           borderRadius: BorderRadius.all(Radius.circular(12))),
  //       child: DataTable(
  //           columns: const [
  //             DataColumn(label: Text('ID')),
  //             DataColumn(label: Text('Name')),
  //             DataColumn(label: Text('Email')),
  //             DataColumn(label: Text('Actions')),
  //           ],
  //           rows: users.map((item) {
  //             return DataRow(cells: [
  //               DataCell(Text(item.uuid.toString())),
  //               DataCell(Text(item.empName)),
  //               DataCell(Text(item.empId)),
  //               DataCell(Row(
  //                 children: [
  //                   IconButton(
  //                       onPressed: () {
  //                         print(item.uuid);
  //                       },
  //                       icon: Icon(Icons.edit)),
  //                   IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
  //                   IconButton(
  //                       onPressed: () => showUser(item),
  //                       icon: Icon(Icons.shape_line))
  //                 ],
  //               )),
  //             ]);
  //           }).toList()),
  //     ),
  //   );
  // }

//date 6-8-2025 show user details..................
  void showUser(UserRegistration item) async {
    showDialog<UserRegistration>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(item.empName),
            content: SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: [
                  Container(
                    height: 0.5,
                    color: Colors.black,
                  ),
                  buildText("Eid", item.empId),
                  Container(
                    height: 0.5,
                    color: Colors.black,
                  ),
                  buildText("Name", item.empName),
                  Container(
                    height: 0.5,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildText(String name, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        Text(
          content,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget buildButtonTile() {
    return Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => print("Button Pressed"),
        child: const Text("Click Me"),
      ),
    );
  }

  Widget buildButtonTileod() {
    return Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => print("Button Pressed"),
        child: const Text("Click Me3"),
      ),
    );
  }
}
