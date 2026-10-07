import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/dummyData/admin_dummy_data.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_all_employee.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_login_record.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_logout_record.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_user_management_screen';
import 'package:truenorthflutterfrontend/app/adminApplication/view/login_history_card.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/logout_history_card.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/map_screen.dart';

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
  @override
  void initState() {
    super.initState(); // Always call this first!
    // Do your one-time setup here
    //TODO   Implement fetch_all_login_user() to pull login details from the API.
  }

  // Convert once, not on every rebuild. Later: replace with
  late final List<AdminLoginRecord> _record =
      AdminDummyData.allLoginRecord.map(AdminLoginRecord.fromJson).toList();
  late final List<AdminLogoutRecord> _recordLogout =
      AdminDummyData.allLogoutRecord.map(AdminLogoutRecord.fromJson).toList();

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      LoginHistoryCard(records: _record),
      MapScreen(),
      LogoutHistoryCard(records: _recordLogout),
      for (int i = 2; i <= 6; i++) _PlaceholderTile('$i'),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 1200 ? 2 : (w >= 700 ? 2 : 1);

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 420, // fixed height: no aspect-ratio overflow
          ),
          itemCount: cards.length,
          itemBuilder: (_, i) => cards[i],
        );
      },
    );
  }
}

class _PlaceholderTile extends StatelessWidget {
  const _PlaceholderTile(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(child: Text(label)),
      );
}
  // @override
  // Widget build(BuildContext context) {
  //   final double screenWidth = MediaQuery.of(context).size.width;
  //   return GridView.builder(
  //     padding: const EdgeInsets.all(12),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: BreakPoint.isWeb(screenWidth) ? 3 : 1,
  //       crossAxisSpacing: 10,
  //       mainAxisSpacing: 10,
  //       childAspectRatio: 1,
  //     ),
  //     itemCount: 6,
  //     itemBuilder: (context, index) {
  //       return getWidgetByIndex(index, context);
  //     },
  //   );
  // }

  // Widget getWidgetByIndex(int index, BuildContext context) {
  //   switch (index) {
  //     case 0:
  //       return allUserCustomBox();
  //     case 1:
  //       return buildTextTile("2");
  //     case 2:
  //       return buildTextTile("3");
  //     case 3:
  //       return buildTextTile("4");
  //     case 4:
  //       return buildTextTile("5");
  //     case 5:
  //       return buildTextTile("6");
  //     default:
  //       return Container(color: Colors.grey);
  //   }
  // }

//ADMIN LOGIN HISTORY.........
//   Widget allUserCustomBox() {
//     return GestureDetector(
//         onTap: () async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           String? id = prefs.getString("empId");
//           String? pass = prefs.getString("empName");
//           print("${id}" + "${pass}");
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 // ignore: deprecated_member_use
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: LayoutBuilder(builder: (context, constraints) {
//             return buildCostomLoginHistoryBox();
//           }),
//         ));
//   }

//   Widget buildCostomLoginHistoryBox() {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final double width = constraints.maxWidth;
//           final double height = constraints.maxHeight;

//           // Responsive values
//           final bool isMobile = width < 500;
//           final bool isTablet = width >= 500 && width < 900;
//           final bool isWeb = width >= 900;

//           final double titleSize = isMobile
//               ? 14
//               : isTablet
//                   ? 16
//                   : 18;

//           final double normalTextSize = isMobile
//               ? 10
//               : isTablet
//                   ? 12
//                   : 13;

//           final double iconSize = isMobile
//               ? 20
//               : isTablet
//                   ? 24
//                   : 28;

//           final double avatarRadius = isMobile
//               ? 16
//               : isTablet
//                   ? 19
//                   : 22;

//           final double spacing = isMobile
//               ? 6
//               : isTablet
//                   ? 10
//                   : 14;
//           return Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(
//                       isMobile ? 6 : 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.login_rounded,
//                       size: iconSize,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   SizedBox(width: spacing),

//                   Expanded(
//                     child: Text(
//                       "Login History",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: titleSize,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   // Total count
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: isMobile ? 6 : 9,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       "${AdminDummyData.allLoginRecord.length}",
//                       style: TextStyle(
//                         fontSize: normalTextSize,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: spacing),
//               SizedBox(
//                 height: isMobile ? 32 : 38,
//                 child: TextField(
//                   style: TextStyle(
//                     fontSize: normalTextSize,
//                   ),
//                   decoration: InputDecoration(
//                     hintText:
//                         isMobile ? "Search" : "Search employee, ID or role",
//                     hintStyle: TextStyle(
//                       fontSize: normalTextSize,
//                     ),
//                     prefixIcon: Icon(
//                       Icons.search,
//                       size: isMobile ? 16 : 20,
//                     ),
//                     contentPadding: EdgeInsets.zero,
//                     filled: true,
//                     fillColor: const Color(0xffF5F7FB),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: spacing),
//               // =========================
//               // LOGIN DATA
//               // =========================
//               Expanded(
//                   child: AdminDummyData.allLoginRecord.isEmpty
//                       ? Center(
//                           child: Text(
//                             "No login records",
//                             style: TextStyle(
//                               fontSize: normalTextSize,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         )
//                       : isMobile
//                           ? ListView.builder(
//                               primary: true,
//                               itemCount: AdminDummyData.allLoginRecord.length,
//                               itemBuilder: (context, index) {
//                                 final Map<String, dynamic> item =
//                                     AdminDummyData.allLoginRecord[index];
//                                 return Container(
//                                   margin: const EdgeInsets.only(
//                                     bottom: 6,
//                                   ),
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xffF8FAFC),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: avatarRadius,
//                                         backgroundColor: Colors.blue.shade50,
//                                         child: Text(
//                                           item["empName"][0]
//                                               .toString()
//                                               .toUpperCase(),
//                                           style: TextStyle(
//                                             fontSize: normalTextSize,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blue,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: spacing),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               item["empName"],
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                 fontSize: normalTextSize,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             Text(
//                                               item["empId"],
//                                               style: TextStyle(
//                                                 fontSize: normalTextSize - 1,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             Text(
//                                               item["address"],
//                                               style: TextStyle(
//                                                 fontSize: normalTextSize - 2,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             Text(
//                                               item["latitude"],
//                                               style: TextStyle(
//                                                 fontSize: normalTextSize - 2,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             Text(
//                                               item["longitude"],
//                                               style: TextStyle(
//                                                 fontSize: normalTextSize - 2,
//                                                 color: Colors.grey,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 6,
//                                           vertical: 3,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: item["role"] == "TEAMLEADER"
//                                               ? Colors.orange.shade50
//                                               : Colors.green.shade50,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: Text(
//                                           item["role"],
//                                           style: TextStyle(
//                                             fontSize: normalTextSize - 2,
//                                             fontWeight: FontWeight.bold,
//                                             color: item["role"] == "TEAMLEADER"
//                                                 ? Colors.orange
//                                                 : Colors.green,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               },
//                             )
//                           : Scrollbar(
//                               thumbVisibility: isWeb,
//                               child: SingleChildScrollView(
//                                 primary: true,
//                                 //  scrollDirection: Axis.horizontal,
//                                 //physics: AlwaysScrollableScrollPhysics(),
//                                 child: DataTable(
//                                     columnSpacing: isTablet ? 12 : 22,
//                                     headingRowHeight: isTablet ? 35 : 40,
//                                     dataRowMinHeight: isTablet ? 42 : 48,
//                                     dataRowMaxHeight: isTablet ? 50 : 58,
//                                     headingTextStyle: TextStyle(
//                                       fontSize: normalTextSize,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     dataTextStyle: TextStyle(
//                                       fontSize: normalTextSize,
//                                     ),
//                                     columns: const [
//                                       DataColumn(
//                                         label: Text("Employee"),
//                                       ),
//                                       DataColumn(
//                                         label: Text("ID"),
//                                       ),
//                                       DataColumn(
//                                         label: Text("Role"),
//                                       ),
//                                       DataColumn(
//                                         label: Text("Date"),
//                                       ),
//                                       DataColumn(
//                                         label: Text("Time"),
//                                       ),
//                                     ],
//                                     rows: AdminDummyData.allLoginRecord
//                                         .map((item) {
//                                       return DataRow(cells: [
//                                         DataCell(
//                                           Text(
//                                             item["empName"]!,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         DataCell(
//                                           Text(item["empId"]!),
//                                         ),
//                                         DataCell(
//                                           Text(
//                                             item["role"]!,
//                                             style: TextStyle(
//                                               fontSize: normalTextSize - 1,
//                                               color:
//                                                   item["role"] == "TEAMLEADER"
//                                                       ? Colors.orange
//                                                       : Colors.green,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                         DataCell(
//                                           Text(item["loginDate"]!),
//                                         ),
//                                         DataCell(
//                                           Text(item["loginTime"]!),
//                                         ),
//                                       ]);
//                                     }).toList()),
//                               )))
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget buildDesktopLoginBox() {
//     return Padding(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   Icons.login_rounded,
//                   color: Colors.blue.shade700,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Login History",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "Employee login activity",
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 150,
//                 height: 36,
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search...",
//                     prefixIcon: const Icon(
//                       Icons.search,
//                       size: 18,
//                     ),
//                     contentPadding: EdgeInsets.zero,
//                     filled: true,
//                     fillColor: const Color(0xffF5F7FB),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 5),
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.refresh),
//                 iconSize: 20,
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           // Table
//           // Expanded(
//           //   child: Scrollbar(
//           //     thumbVisibility: true,
//           //     child: SingleChildScrollView(
//           //       child: buildLoginTable(),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget buildMobileLoginBox() {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   Icons.login_rounded,
//                   color: Colors.blue.shade700,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Login History",
//                       style: TextStyle(
//                         fontSize: 5,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "Recent employee logins",
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.refresh),
//                 iconSize: 20,
//               ),
//             ],
//           ),

//           const SizedBox(height: 10),

//           // Search
//           SizedBox(
//             height: 38,
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 prefixIcon: const Icon(
//                   Icons.search,
//                   size: 18,
//                 ),
//                 filled: true,
//                 fillColor: const Color(0xffF5F7FB),
//                 contentPadding: EdgeInsets.zero,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),

//           // Login records
//           // Expanded(
//           //   child: ListView.builder(
//           //     itemCount: loginRecords.length,
//           //     itemBuilder: (context, index) {
//           //       final item = loginRecords[index];

//           //       return buildMobileLoginItem(item);
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget createProject(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //         builder: (context) => const AdminCreateprojectScreen()));
//       },
//       child: Container(
//         color: Colors.orange.shade100,
//         alignment: Alignment.center,
//         child: const Text("Project", style: TextStyle(fontSize: 18)),
//       ),
//     );
//   }

//   Widget buildTextTile(String text) {
//     return Container(
//       color: Colors.orange.shade100,
//       alignment: Alignment.center,
//       child: Text(text, style: const TextStyle(fontSize: 18)),
//     );
//   }

//   // Widget buildIconTile() {
//   //   return SingleChildScrollView(
//   //     child: Container(
//   //       decoration: BoxDecoration(
//   //           border: Border.all(width: 0.5),
//   //           borderRadius: BorderRadius.all(Radius.circular(12))),
//   //       child: DataTable(
//   //           columns: const [
//   //             DataColumn(label: Text('ID')),
//   //             DataColumn(label: Text('Name')),
//   //             DataColumn(label: Text('Email')),
//   //             DataColumn(label: Text('Actions')),
//   //           ],
//   //           rows: users.map((item) {
//   //             return DataRow(cells: [
//   //               DataCell(Text(item.uuid.toString())),
//   //               DataCell(Text(item.empName)),
//   //               DataCell(Text(item.empId)),
//   //               DataCell(Row(
//   //                 children: [
//   //                   IconButton(
//   //                       onPressed: () {
//   //                         print(item.uuid);
//   //                       },
//   //                       icon: Icon(Icons.edit)),
//   //                   IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
//   //                   IconButton(
//   //                       onPressed: () => showUser(item),
//   //                       icon: Icon(Icons.shape_line))
//   //                 ],
//   //               )),
//   //             ]);
//   //           }).toList()),
//   //     ),
//   //   );
//   // }

// //date 6-8-2025 show user details..................
//   void showUser(UserRegistration item) async {
//     showDialog<UserRegistration>(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(item.empName),
//             content: SizedBox(
//               width: 300,
//               height: 300,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 0.5,
//                     color: Colors.black,
//                   ),
//                   buildText("Eid", item.empId),
//                   Container(
//                     height: 0.5,
//                     color: Colors.black,
//                   ),
//                   buildText("Name", item.empName),
//                   Container(
//                     height: 0.5,
//                     color: Colors.black,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   Widget buildText(String name, String content) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           name,
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//         ),
//         Text(
//           content,
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//         )
//       ],
//     );
//   }

//   Widget buildButtonTile() {
//     return Container(
//       color: Colors.red.shade100,
//       alignment: Alignment.center,
//       child: ElevatedButton(
//         onPressed: () => print("Button Pressed"),
//         child: const Text("Click Me"),
//       ),
//     );
//   }

//   Widget buildButtonTileod() {
//     return Container(
//       color: Colors.red.shade100,
//       alignment: Alignment.center,
//       child: ElevatedButton(
//         onPressed: () => print("Button Pressed"),
//         child: const Text("Click Me3"),
//       ),
//     );
//   }
// }
