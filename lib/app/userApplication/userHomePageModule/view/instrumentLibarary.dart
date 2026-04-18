import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/view/selectLibaryTools.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/buildCustomText.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class Instrumentlibarary extends StatefulWidget {
  const Instrumentlibarary({super.key});
  @override
  State<Instrumentlibarary> createState() => InstrumentLibaryState();
}

final List<String> columnLabels = [
  "ID",
  "Instrument Status",
  "Model",
  "Serial No",
  "Condition",
  "Site Location",
  "Collection Date",
  "Due Date",
];

final List<Map<String, dynamic>> sitelist = [
  {
    "instrumentId": "TNI-1",
    "instrumentType": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "Repair",
    "siteLocation": "Bhopal",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "true",
  },
  {
    "instrumentId": "TNI-1",
    "instrumentType": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "Repair",
    "siteLocation": "indore",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "false",
  },
  {
    "instrumentId": "TNI-1",
    "instrumentType": "honda shine mp-04-1341",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "good",
    "siteLocation": "sehore",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "true",
  },
  {
    "instrumentId": "TNI-1",
    "instrumentType": "Delux mp-04-1341",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "Repair",
    "siteLocation": "Bhopal",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "true",
  },
  {
    "instrumentId": "TNI-1",
    "instrumentType": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "repair",
    "siteLocation": "jabalpur",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "false",
  },
  {
    "instrumentId": "TNI-1",
    "instrumentType": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "Repair",
    "siteLocation": "Bhopal",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "true",
  },
  {
    "instrumentId": "TNI-1",
    "instrumentType": "DGPS6",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "Repair",
    "siteLocation": "Bhopal",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "false",
  },
  {
    "instrumentId": "TNI-1",
    "instrumentType": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "instrumentCondition": "Repair",
    "siteLocation": "Bhopal",
    "collectionDate": "1-1-2026",
    "dueDate": "10-1-2026",
    "allomentStatus": "false",
  }
];
final List<Map<String, dynamic>> vehicalList = [
  {
    "vehicalId": "VH-101",
    "vehicalType": "DGPS Vehicle",
    "vehicalmodel": "I93",
    "vehicalserialNo": "SN-3657456",
    "vehicalCondition": "Good",
    "vehicalLocation": "Indore",
    "vehicalcollectionDate": "01-01-2026",
    "vehicaldueDate": "10-01-2026",
    "vehicalallomentStatus": "true",
  },
  {
    "vehicalId": "VH-102",
    "vehicalType": "Survey Van",
    "vehicalmodel": "X200",
    "vehicalserialNo": "SN-3657457",
    "vehicalCondition": "Repair",
    "vehicalLocation": "Bhopal",
    "vehicalcollectionDate": "02-01-2026",
    "vehicaldueDate": "12-01-2026",
    "vehicalallomentStatus": "false",
  },
  {
    "vehicalId": "VH-103",
    "vehicalType": "Pickup Truck",
    "vehicalmodel": "TATA 407",
    "vehicalserialNo": "SN-3657458",
    "vehicalCondition": "Excellent",
    "vehicalLocation": "Jabalpur",
    "vehicalcollectionDate": "03-01-2026",
    "vehicaldueDate": "13-01-2026",
    "vehicalallomentStatus": "true",
  },
  {
    "vehicalId": "VH-104",
    "vehicalType": "Transport Van",
    "vehicalmodel": "Bolero",
    "vehicalserialNo": "SN-3657459",
    "vehicalCondition": "Average",
    "vehicalLocation": "Gwalior",
    "vehicalcollectionDate": "04-01-2026",
    "vehicaldueDate": "14-01-2026",
    "vehicalallomentStatus": "false",
  },
  {
    "vehicalId": "VH-105",
    "vehicalType": "Survey Jeep",
    "vehicalmodel": "Mahindra Thar",
    "vehicalserialNo": "SN-3657460",
    "vehicalCondition": "Good",
    "vehicalLocation": "Ujjain",
    "vehicalcollectionDate": "05-01-2026",
    "vehicaldueDate": "15-01-2026",
    "vehicalallomentStatus": "true",
  },
  {
    "vehicalId": "VH-106",
    "vehicalType": "Field Vehicle",
    "vehicalmodel": "Isuzu V-Cross",
    "vehicalserialNo": "SN-3657461",
    "vehicalCondition": "Repair",
    "vehicalLocation": "Ratlam",
    "vehicalcollectionDate": "06-01-2026",
    "vehicaldueDate": "16-01-2026",
    "vehicalallomentStatus": "false",
  },
];
final List<Map<String, dynamic>> officeToolList = [
  {
    "officeToolId": "OT-201",
    "officeToolType": "Desktop System",
    "officeToolModel": "Dell OptiPlex 7090",
    "officeToolSerialNo": "SYS-908123",
    "officeToolCondition": "Good",
    "officeToolLocation": "Head Office",
    "officeToolCollectionDate": "01-01-2026",
    "officeToolDueDate": "01-01-2027",
    "officeToolAllotmentStatus": "true",
  },
  {
    "officeToolId": "OT-202",
    "officeToolType": "Laptop",
    "officeToolModel": "HP EliteBook 840",
    "officeToolSerialNo": "LAP-778912",
    "officeToolCondition": "Excellent",
    "officeToolLocation": "Branch Office",
    "officeToolCollectionDate": "05-01-2026",
    "officeToolDueDate": "05-01-2027",
    "officeToolAllotmentStatus": "false",
  },
  {
    "officeToolId": "OT-203",
    "officeToolType": "Laptop",
    "officeToolModel": "Lenovo ThinkPad T14",
    "officeToolSerialNo": "LAP-889023",
    "officeToolCondition": "Good",
    "officeToolLocation": "IT Department",
    "officeToolCollectionDate": "10-01-2026",
    "officeToolDueDate": "10-01-2027",
    "officeToolAllotmentStatus": "true",
  },
  {
    "officeToolId": "OT-204",
    "officeToolType": "Printer",
    "officeToolModel": "HP LaserJet Pro",
    "officeToolSerialNo": "PRN-450912",
    "officeToolCondition": "Repair",
    "officeToolLocation": "Accounts Dept",
    "officeToolCollectionDate": "12-01-2026",
    "officeToolDueDate": "12-07-2026",
    "officeToolAllotmentStatus": "false",
  },
  {
    "officeToolId": "OT-205",
    "officeToolType": "Desktop System",
    "officeToolModel": "Acer Veriton",
    "officeToolSerialNo": "SYS-341290",
    "officeToolCondition": "Good",
    "officeToolLocation": "Admin Office",
    "officeToolCollectionDate": "15-01-2026",
    "officeToolDueDate": "15-01-2027",
    "officeToolAllotmentStatus": "true",
  },
  {
    "officeToolId": "OT-206",
    "officeToolType": "Laptop",
    "officeToolModel": "Apple MacBook Air M1",
    "officeToolSerialNo": "LAP-990781",
    "officeToolCondition": "Excellent",
    "officeToolLocation": "Management",
    "officeToolCollectionDate": "18-01-2026",
    "officeToolDueDate": "18-01-2027",
    "officeToolAllotmentStatus": "false",
  },
];
final List<Map<String, dynamic>> miscToolList = [
  {
    "miscToolId": "MT-301",
    "miscToolType": "Power Bank",
    "miscToolModel": "Mi 20000mAh",
    "miscToolSerialNo": "PB-998812",
    "miscToolCondition": "Good",
    "miscToolLocation": "Field Office",
    "miscToolCollectionDate": "01-02-2026",
    "miscToolDueDate": "01-08-2026",
    "miscToolAllotmentStatus": "true",
  },
  {
    "miscToolId": "MT-302",
    "miscToolType": "WiFi Router",
    "miscToolModel": "TP-Link Archer C6",
    "miscToolSerialNo": "RT-889123",
    "miscToolCondition": "Excellent",
    "miscToolLocation": "IT Room",
    "miscToolCollectionDate": "05-02-2026",
    "miscToolDueDate": "05-08-2026",
    "miscToolAllotmentStatus": "false",
  },
  {
    "miscToolId": "MT-303",
    "miscToolType": "External Hard Disk",
    "miscToolModel": "Seagate 2TB",
    "miscToolSerialNo": "HD-341290",
    "miscToolCondition": "Good",
    "miscToolLocation": "Admin Office",
    "miscToolCollectionDate": "08-02-2026",
    "miscToolDueDate": "08-08-2026",
    "miscToolAllotmentStatus": "true",
  },
  {
    "miscToolId": "MT-304",
    "miscToolType": "Projector",
    "miscToolModel": "Epson EB-X05",
    "miscToolSerialNo": "PJ-450912",
    "miscToolCondition": "Repair",
    "miscToolLocation": "Conference Room",
    "miscToolCollectionDate": "10-02-2026",
    "miscToolDueDate": "10-07-2026",
    "miscToolAllotmentStatus": "false",
  },
  {
    "miscToolId": "MT-305",
    "miscToolType": "Barcode Scanner",
    "miscToolModel": "Honeywell 1250g",
    "miscToolSerialNo": "BS-775421",
    "miscToolCondition": "Good",
    "miscToolLocation": "Store Room",
    "miscToolCollectionDate": "12-02-2026",
    "miscToolDueDate": "12-08-2026",
    "miscToolAllotmentStatus": "true",
  },
  {
    "miscToolId": "MT-306",
    "miscToolType": "UPS",
    "miscToolModel": "APC 1KVA",
    "miscToolSerialNo": "UPS-998701",
    "miscToolCondition": "Average",
    "miscToolLocation": "Server Room",
    "miscToolCollectionDate": "15-02-2026",
    "miscToolDueDate": "15-08-2026",
    "miscToolAllotmentStatus": "false",
  },
];

List<String> submitInstrument = [
  "abc",
  "xyz",
  "instrument-room",
  "himesh",
  "pramod"
];
final List<Map<String, dynamic>> instrumentHandoverList = [
  {
    // Instrument Details
    "instrument": {
      "instrumentId": "TNI-1",
      "instrumentType": "DGPS",
      "model": "I93",
      "serialNo": "3657456",
    },

    // Handover Details (Submitted by Sender)
    "handover": {
      "condition": "Repair",
      "location": "Bhopal",
      "handoverDate": "01-01-2026",
      "handoverById": "TNE01",
      "handoverByName": "Jeb Kotlin",
      "remarks": "Instrument not powering on",
      "submittedAt": "2026-01-01 10:30 AM",
    },

    // Receive Details (Confirmed by Receiver)
    "receive": {
      "receivedById": "TNE02",
      "receivedByName": "Mr Goldy",
      "receivedDate": "01-01-2026",
      "receivedCondition": "Repair",
      "isReceived": true,
      "remarks": "Received with charger",
      "receivedAt": "2026-01-01 11:15 AM",
    },

    // Status Tracking
    "status": "Completed", // Pending | Received | Completed
  },
];
final List<Map<String, dynamic>> receivedHandoverList = [
  {
    "instrumentId": "TNI-1",
    "instrumentType": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "handoverBy": "Jeb Kotlin",
    "receivedDate": "01-01-2026",
    "condition": "Repair",
    "location": "Bhopal",
    "status": "Received",
  },
  {
    "instrumentId": "TNI-2",
    "instrumentType": "Total Station",
    "model": "S7",
    "serialNo": "7845123",
    "handoverBy": "Amit Kumar",
    "receivedDate": "03-01-2026",
    "condition": "Good",
    "location": "Indore",
    "status": "Received",
  },
];
List<Map<String, dynamic>> instrumentHistoryList = [
  {
    "event": "Instrument Collected",
    "instrumentId": "TNI-1",
    "type": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "from": "Store",
    "to": "Survey Team",
    "condition": "Repair",
    "location": "Bhopal",
    "status": "Collected",
    "date": "01-01-2026",
  },
  {
    "event": "Instrument Handed Over",
    "instrumentId": "TNI-1",
    "type": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "from": "Survey Team",
    "to": "Jeb Kotlin",
    "condition": "Repair",
    "location": "Bhopal",
    "status": "Handover",
    "date": "01-01-2026",
  },
  {
    "event": "Instrument Received",
    "instrumentId": "TNI-1",
    "type": "DGPS",
    "model": "I93",
    "serialNo": "3657456",
    "from": "Jeb Kotlin",
    "to": "Office Store",
    "condition": "Repair",
    "location": "Bhopal",
    "status": "Received",
    "date": "01-01-2026",
  },
  {
    "event": "Vehicle Assigned",
    "instrumentId": "VH-101",
    "type": "DGPS Vehicle",
    "model": "I93",
    "serialNo": "SN-3657456",
    "from": "Transport Dept",
    "to": "Survey Team",
    "condition": "Good",
    "location": "Indore",
    "status": "Assigned",
    "date": "01-01-2026",
  },
  {
    "event": "Office Tool Issued",
    "instrumentId": "OT-201",
    "type": "Desktop System",
    "model": "Dell OptiPlex 7090",
    "serialNo": "SYS-908123",
    "from": "IT Store",
    "to": "Admin Office",
    "condition": "Good",
    "location": "Head Office",
    "status": "Issued",
    "date": "01-01-2026",
  },
];

TextEditingController instrumentSubmitcontroller = TextEditingController();

class InstrumentLibaryState extends State<Instrumentlibarary> {
  int totalOfficeTools = officeToolList.length;
  int totalSiteTools = sitelist.length;
  int totalvehicalTools = vehicalList.length;
  int totalMiscelleneous = miscToolList.length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 184, 203, 219),
                Color.fromARGB(255, 168, 243, 245)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "INSTRUMENTS LIBRARY",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: Scrollbar(
        radius: Radius.circular(20),
        thumbVisibility: false,
        child: SingleChildScrollView(
            child: Column(children: [
          //HERE ITS MAXIMUM LENGTH OF LIST MEANS WHERE IS THE END POINT OF LIST.....
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                 
                  // childAspectRatio: 3.2,
                  // // makes it button-like
                   childAspectRatio: 3.5,
                  children: [
                    _smallGridButton("Office Tools", 0, totalOfficeTools),
                    _smallGridButton("Site Tools", 1, totalSiteTools),
                    _smallGridButton("Vehicle", 2, totalvehicalTools),
                    _smallGridButton("Misc", 3, totalMiscelleneous),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color.fromARGB(255, 226, 230, 230),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("Issue-New-Instrument"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Selectlibarytools(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          Row(
            children: [
              Consumer<UserDashboardProvider>(builder: (context, prov, child) {
                return ElevatedButton.icon(
                  onPressed: () {
                    prov.showHideToolsList();
                  },
                  icon: prov.show
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  label: prov.show
                      ? Text("Hide-Assign-Tools")
                      : Text("Show-Assign-Tools"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 154, 173, 189),
                    foregroundColor: Colors.white,
                  ),
                );
              })
            ],
          ),
          Consumer<UserDashboardProvider>(
            builder: (context, pro, child) {
              if (pro.show == true) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      // height: SizeConFig.proportionalHeight * 4.5,
                      child: Column(children: [
                        // SizedBox(
                        //   height: SizeConFig.proportionalHeight * 0.1,
                        // ),
                        //CHANNGE NAME ACCORING SELECT TOOL LIKE OFFICE AND SITE TOOLS ETC......
                        Consumer<UserDashboardProvider>(
                          builder: (context, value, child) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 188, 129, 174),
                                      Color.fromARGB(255, 195, 195, 186)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  value.currentName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal.shade900,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
//list view tool consumer..........................................................................
                        Consumer<UserDashboardProvider>(
                            builder: (context, count, child) {
                          if (count.currentTool == 0) {
                            return _buildReusableToolList2(
                                officeToolList, officeToolConfig);
                          }
                          if (count.currentTool == 1) {
                            // Vehicle list
                            return _buildReusableToolList2(
                              sitelist,
                              siteToolConfig,
                            );
                          }
                          if (count.currentTool == 2) {
                            return _buildReusableToolList2(
                              vehicalList,
                              vehicalToolsConfig,
                            );
                          }
                          if (count.currentTool == 3) {
                            return _buildReusableToolList2(
                              miscToolList,
                              miscToolConfig,
                            );
                          }

                          return SizedBox();
                        }),
                      ])),
                );
              }
              return SizedBox();
            },
          ),

          //ending of tools lits..........................................
          Divider(),
          Row(
            children: [
              BuildCustomText(
                data: "Recived Tools ",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              Icon(Icons.arrow_forward)
            ],
          ),

          Container(
            height: SizeConFig.proportionalHeight * 2.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: receivedHandoverList.length,
              itemBuilder: (context, index) {
                final item = receivedHandoverList[index];

                return Container(
                  width: 340,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔹 Header Row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(Icons.handshake,
                                  color: Colors.green, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${item['instrumentType']} • ${item['model']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _statusBadge(item['status']),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// 🔹 Info Rows
                        _infoRow("Instrument ID", item['instrumentId'],
                            "Serial No", item['serialNo']),
                        _infoRow("Handover By", item['handoverBy'], "Received",
                            item['receivedDate']),
                        _infoRow("Condition", item['condition'], "Location",
                            item['location']),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Divider(),
          //start user instrument recived and all record history...........................
          Row(
            children: [
              BuildCustomText(
                data: "Track History :",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              Icon(Icons.arrow_downward)
            ],
          ),
          Container(
              height: SizeConFig.proportionalHeight * 4,
              child: ListView.separated(
                itemCount: instrumentHistoryList.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = instrumentHistoryList[index];

                  return ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -3),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    leading: Icon(
                      Icons.sync_alt,
                      size: 18,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "${item["event"]} • ${item["type"]}",
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "From: ${item["from"]}",
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_right_alt, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "To: ${item["to"]}",
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item["date"],
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          item["status"],
                          style: const TextStyle(
                              fontSize: 10, color: Colors.green),
                        ),
                      ],
                    ),
                  );
                },
              ))
        ])),
      ),
    );
  }

  Widget _smallGridButton(String label, int index, int totalItem) {
    return Consumer<UserDashboardProvider>(
      builder: (context, provider, _) {
        final bool isActive = provider.currentTool == index;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            provider.increaseToolCounter(index, label);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? Colors.cyan.shade600 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? Colors.cyan.shade700 : Colors.cyan.shade200,
                width: isActive ? 1.4 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isActive
                      // ignore: deprecated_member_use
                      ? Colors.cyan.withOpacity(0.35)
                      // ignore: deprecated_member_use
                      : Colors.black.withOpacity(0.06),
                  blurRadius: isActive ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : Colors.cyan.shade900,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.cyan.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$totalItem",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.cyan.shade800 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _toolCard(String label, IconData icon, int index, int totalItem) {
  //   return InkWell(
  //     borderRadius: BorderRadius.circular(18),
  //     onTap: () {
  //       Provider.of<UserDashboardProvider>(context, listen: false)
  //           .increaseToolCounter(index, label);
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(14),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(18),
  //         gradient: LinearGradient(
  //           colors: [
  //             Colors.cyan.shade50,
  //             Colors.cyan.shade100,
  //           ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Align(
  //             alignment: Alignment.topRight,
  //             child: CircleAvatar(
  //               radius: 14,
  //               backgroundColor: Colors.cyan.shade700,
  //               child: Text(
  //                 "$totalItem",
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Icon(
  //             icon,
  //             size: 34,
  //             color: Colors.cyan.shade900,
  //           ),
  //           Text(
  //             label,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontWeight: FontWeight.w600,
  //               color: Colors.cyan.shade900,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future buildButtomsheet(String label1) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          //Scrolling given for content in Container()
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                //Create a Column to display it's content
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                //Create a Column to display it's content
                child: Column(
                  children: [
                    Text(
                      label1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // TextField for giving some Input
                    TextField(
                      //  controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        hintText: "Add Item",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),

                    //Button for adding items
                    // ElevatedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       middleText = _controller.text;
                    //     });
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.green,
                    //     foregroundColor: Colors.white,
                    //   ),
                    //   child: const Text("Add"),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showEditTaskDialog(BuildContext context) {
    // final TextEditingController taskNameController =
    //     TextEditingController(text: item['taskName']);
    // final TextEditingController priorityController =
    //     TextEditingController(text: item['priority']);
    // final TextEditingController assignedController =
    //     TextEditingController(text: item['assinedTask']);
    // final TextEditingController teamController =
    //     TextEditingController(text: item['team']);
    // final TextEditingController allotmentDateController =
    //     TextEditingController(text: item['allotmentDate']);
    // final TextEditingController completionDateController =
    //     TextEditingController(text: item['completionDate']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Transfer-Tools"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: SizeConFig.proportionalWidth * 30.0,
              height: SizeConFig.proportionalHeight * 5.01,
              child: Column(
                children: [
                  // _buildTextField("Task Name", taskNameController),
                  // _buildTextField("Priority", priorityController),
                  // _buildTextField("Assigned To", assignedController),
                  // _buildTextField("Team", teamController),
                  // _buildTextField("Allotment Date", allotmentDateController),
                  // _buildTextField("Completion Date", completionDateController),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Updated JSON
                // Map<String, dynamic> updatedItem = {
                //   ...item,
                //   'taskName': taskNameController.text,
                //   'priority': priorityController.text,
                //   'assinedTask': assignedController.text,
                //   'team': teamController.text,
                //   'allotmentDate': allotmentDateController.text,
                //   'completionDate': completionDateController.text,
                // };

                //   print("Updated Item: $updatedItem");

                Navigator.pop(context);

               
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: _infoText(label1, value1)),
          Expanded(child: _infoText(label2, value2)),
        ],
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        Text(value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Widget _buildSingleText(String label1, String lable2) {
  //   return BuildCustomText(
  //     data: "${label1}: ${lable2}",
  //     fontSize: 10,
  //     fontWeight: FontWeight.w500,
  //   );
  // }

//TOOL CONFIG FOR NAME.............................................
  final siteToolConfig = ToolFieldConfig(
    id: "instrumentId",
    type: "instrumentType",
    model: "model",
    serialNo: "serialNo",
    condition: "instrumentCondition",
    location: "siteLocation",
    collectionDate: "collectionDate",
    dueDate: "dueDate",
    allotmentStatus: "allomentStatus",
  );
  final vehicalToolsConfig = ToolFieldConfig(
    id: "vehicalId",
    type: "vehicalType",
    model: "vehicalmodel",
    serialNo: "vehicalserialNo",
    condition: "vehicalCondition",
    location: "vehicalLocation",
    collectionDate: "vehicalcollectionDate",
    dueDate: "vehicaldueDate",
    allotmentStatus: "vehicalallomentStatus",
  );

  final miscToolConfig = ToolFieldConfig(
    id: "miscToolId",
    type: "miscToolType",
    model: "miscToolModel",
    serialNo: "miscToolSerialNo",
    condition: "miscToolCondition",
    location: "miscToolLocation",
    collectionDate: "miscToolCollectionDate",
    dueDate: "miscToolDueDate",
    allotmentStatus: "miscToolAllotmentStatus",
  );

  final officeToolConfig = ToolFieldConfig(
    id: "officeToolId",
    type: "officeToolType",
    model: "officeToolModel",
    serialNo: "officeToolSerialNo",
    condition: "officeToolCondition",
    location: "officeToolLocation",
    collectionDate: "officeToolCollectionDate",
    dueDate: "officeToolDueDate",
    allotmentStatus: "officeToolAllotmentStatus",
  );
  Widget _buildReusableToolList2(
    List<Map<String, dynamic>> list,
    ToolFieldConfig config,
  ) {
    return SizedBox(
      height: SizeConFig.proportionalHeight * 4,
      child: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = list[index];
          bool status = item[config.allotmentStatus] == "true";

          return SizedBox(
            height: 60, // compact row height
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  /// Status Icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          status ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        Icons.build,
                        size: 16,
                        color: status ? Colors.green : Colors.red,
                      ),
                    ),
                  ),

                  /// Type
                  // _chip(item[config.type]),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 200, 233, 231),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      item[config.type],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),

                  /// ID
                  _chip("ID: ${item[config.id]}"),

                  /// Model
                  _chip("Model: ${item[config.model]}"),

                  /// Serial
                  _chip("SN: ${item[config.serialNo]}"),

                  /// Location
                  _chip("Loc: ${item[config.location]}"),

                  /// Due Date
                  _chip("Due: ${item[config.dueDate]}"),

                  /// Action Buttons
                  Row(
                    children: [
                      _miniActionBtn("Transfer", Colors.blue, () {
                        // showEditTaskDialog(context);
                        buildButtomsheet("Transfer_Tools");
                      }),
                      _miniActionBtn("Return", Colors.orange, () {
                        buildButtomsheet("Handover_Tools");
                      }),
                      _miniActionBtn("Renew", Colors.green, () {
                        buildButtomsheet("Renew_Tools");
                      }),
                    ],
                  ),

                  const SizedBox(width: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _miniActionBtn(String text, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  ///RESUABLE LIST OF FOR TOOLS............................................
//   Widget _buildReusableToolList(
//     List<Map<String, dynamic>> list,
//     ToolFieldConfig config,
//   ) {
//     return Container(
//       height: SizeConFig.proportionalHeight * 4,
//       child: ListView.builder(
//         itemCount: list.length,
//         itemBuilder: (context, index) {
//           final item = list[index];
//           bool status = item[config.allotmentStatus] == "true";

//           return Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             margin: const EdgeInsets.all(8),
//             child: Column(
//               children: [
//                 // Title
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.cyan.shade50,
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(15),
//                     ),
//                   ),
//                   child: Text(
//                     item[config.type],
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.cyan,
//                     ),
//                   ),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildInfoColumn(
//                         "ID:",
//                         item[config.id],
//                         "Model:",
//                         item[config.model],
//                         "Serial:",
//                         item[config.serialNo],
//                         "Condition:",
//                         item[config.condition],
//                       ),
//                       _buildInfoColumn(
//                         "Status:",
//                         item[config.allotmentStatus],
//                         "Location:",
//                         item[config.location],
//                         "Collect:",
//                         item[config.collectionDate],
//                         "Due:",
//                         item[config.dueDate],
//                         status: status,
//                       ),
//                     ],
//                   ),
//                 ),

//                 const Divider(),
// //THRE BUTTON TRANSFER AND RETURN AND RENEW HERE ITS MAIN CALLLING FUNCTION...............................
//                 _buildActionButtons(),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

  // Widget _buildActionButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       ElevatedButton(onPressed: () {}, child: const Text("Transfer")),
  //       ElevatedButton(onPressed: () {}, child: const Text("Return")),
  //       ElevatedButton(onPressed: () {}, child: const Text("Renew")),
  //     ],
  //   );
  // }

  //build grid box...................

  // ignore: unused_element
  Widget _buildgridBox(String label, int index, int totalItem) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        splashColor: Colors.cyan.withOpacity(0.25),
        // ignore: deprecated_member_use
        highlightColor: Colors.cyan.withOpacity(0.15),
        onTap: () {
          Provider.of<UserDashboardProvider>(context, listen: false)
              .increaseToolCounter(index, label);
        },
        child: Container(
          height: SizeConFig.proportionalHeight * 0.3,
          width: SizeConFig.proportionalWidth * 2.7,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE0F7FA),
                Color(0xFFB2EBF2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.cyan.shade200,
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "$label",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.cyan.shade900,
                  ),
                ),
                Text(
                  "${"($totalItem)"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 100, 30, 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///DROP DOWN MENU FOR SELECTING THE MEMBER OF USER WHERE USER SUBMIT INSTRUMENT....................
  // Widget _buildDropDownSelectMember() {
  //   return TextField(
  //       controller: instrumentSubmitcontroller,
  //       textAlignVertical: TextAlignVertical.center,
  //       style: const TextStyle(fontSize: 12),
  //       readOnly: true,
  //       maxLines: 1,
  //       cursorColor: Colors.transparent,
  //       decoration: InputDecoration(
  //         isDense: true,
  //         labelText: "Select Memeber for submit Instrument",
  //         labelStyle: const TextStyle(
  //           fontWeight: FontWeight.w600,
  //           fontSize: 10,
  //           color: Colors.black87,
  //         ),
  //         filled: true,
  //         fillColor: Colors.grey.shade100,
  //         border: const OutlineInputBorder(),
  //         suffixIcon: PopupMenuButton<String>(
  //           icon: const Icon(Icons.arrow_drop_down),
  //           onSelected: (value) {
  //             instrumentSubmitcontroller.text = value;
  //           },
  //           itemBuilder: (context) {
  //             return submitInstrument.map((aim) {
  //               return PopupMenuItem<String>(
  //                 value: aim,
  //                 child: Row(
  //                   children: [
  //                     Icon(Icons.select_all, size: 15),
  //                     const SizedBox(width: 10),
  //                     Expanded(
  //                       child: Text(
  //                         aim,
  //                         style: const TextStyle(fontSize: 15),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList();
  //           },
  //         ),
  //       ));
  // }

  // Widget _buidRowAndColumn(String label1, String label2, [bool? status]) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       BuildCustomText(
  //         data: label1,
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //         color: status == null
  //             ? Colors.black
  //             : status
  //                 ? Colors.green
  //                 : Colors.red,
  //       ),
  //       BuildCustomText(
  //         data: label2,
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //         color: status == null
  //             ? Colors.black
  //             : status
  //                 ? Colors.green
  //                 : Colors.red,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildField(String label, String value) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       BuildCustomText(
  //         data: "$label:",
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       const SizedBox(height: 4),
  //       BuildCustomText(
  //         data: value,
  //         fontSize: 12,
  //         fontWeight: FontWeight.w400,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildInfoColumn(
  //   String l1,
  //   String v1,
  //   String l2,
  //   String v2,
  //   String l3,
  //   String v3,
  //   String l4,
  //   String v4, {
  //   bool? status,
  // }) {
  //   return SizedBox(
  //     width: SizeConFig.proportionalHeight * 2,
  //     child: Column(
  //       children: [
  //         _buidRowAndColumn(l1, v1, status),
  //         _buidRowAndColumn(l2, v2),
  //         _buidRowAndColumn(l3, v3),
  //         _buidRowAndColumn(l4, v4),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildColumnContent(List<String> items, int count) {
  //   return Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: List.generate(count, (index) {
  //         final item = items;
  //         return Column(
  //           children: [
  //             Container(
  //               alignment: Alignment.centerLeft,
  //               width: SizeConFig.proportionalWidth * 2.0,
  //               child: BuildCustomText(
  //                 data: item[index],
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             )
  //           ],
  //         );
  //       }));
  // }
}

class ToolFieldConfig {
  final String id;
  final String type;
  final String model;
  final String serialNo;
  final String condition;
  final String location;
  final String collectionDate;
  final String dueDate;
  final String allotmentStatus;

  ToolFieldConfig({
    required this.id,
    required this.type,
    required this.model,
    required this.serialNo,
    required this.condition,
    required this.location,
    required this.collectionDate,
    required this.dueDate,
    required this.allotmentStatus,
  });
}
