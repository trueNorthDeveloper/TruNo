import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
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
TextEditingController instrumentSubmitcontroller = TextEditingController();

class InstrumentLibaryState extends State<Instrumentlibarary> {
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
      body: Container(
          child: Column(children: [
//CONTAINER FOR FOUR TOOLS LIKE OFFICER TOOLS AND SITE TOOLS AND VEHICAL AND MISCELLENEOUS...........................
        Container(
            height: SizeConFig.proportionalHeight * 1.5,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 251, 251, 251),
                  Color.fromARGB(255, 250, 249, 245),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildgridBox("Office-Tools", 0),
                    _buildgridBox("Site-Tools", 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildgridBox("Vehical", 2),
                    _buildgridBox("Miscellaneous", 3),
                  ],
                )
              ],
            )),
//HERE ITS MAXIMUM LENGTH OF LIST MEANS WHERE IS THE END POINT OF LIST.....
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: double.infinity,
              height: SizeConFig.proportionalHeight * 5.8,
              decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 71, 143, 215),
                border: Border.all(width: 0.5, color: Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 143, 141, 141),
                    offset: const Offset(
                      5.0,
                      5.0,
                    ), //Offset
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: const Color.fromARGB(255, 241, 236, 236),
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: Column(children: [
                SizedBox(
                  height: SizeConFig.proportionalHeight * 0.1,
                ),
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

//USING CONSUMER FOR INCRESE COUNTER FOR RESUABLE LIST OF ITEM OFFICEA ND SITE TOOOLS VEHICAL AND MISCELLENOUS
                Consumer<UserDashboardProvider>(
                    builder: (context, count, child) {
                  if (count.currentTool == 0) {
                    return _buildReusableToolList(
                        officeToolList, officeToolConfig);
                  }
                  if (count.currentTool == 1) {
                    // Vehicle list
                    return _buildReusableToolList(
                      sitelist,
                      siteToolConfig,
                    );
                  }
                  if (count.currentTool == 2) {
                    return _buildReusableToolList(
                      vehicalList,
                      vehicalToolsConfig,
                    );
                  }
                  if (count.currentTool == 3) {
                    return _buildReusableToolList(
                      miscToolList,
                      miscToolConfig,
                    );
                  }

                  return SizedBox();
                })
              ])),
        ),
      ])),
    );
  }

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

  ///RESUABLE LIST OF FOR TOOLS............................................
  Widget _buildReusableToolList(
    List<Map<String, dynamic>> list,
    ToolFieldConfig config,
  ) {
    return Container(
      height: SizeConFig.proportionalHeight * 5.2,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          bool status = item[config.allotmentStatus] == "true";

          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                // Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade50,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    item[config.type],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.cyan,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn(
                        "ID:",
                        item[config.id],
                        "Model:",
                        item[config.model],
                        "Serial:",
                        item[config.serialNo],
                        "Condition:",
                        item[config.condition],
                      ),
                      _buildInfoColumn(
                        "Status:",
                        item[config.allotmentStatus],
                        "Location:",
                        item[config.location],
                        "Collect:",
                        item[config.collectionDate],
                        "Due:",
                        item[config.dueDate],
                        status: status,
                      ),
                    ],
                  ),
                ),

                const Divider(),
//THRE BUTTON TRANSFER AND RETURN AND RENEW HERE ITS MAIN CALLLING FUNCTION...............................
                _buildActionButtons(),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text("Transfer")),
        ElevatedButton(onPressed: () {}, child: const Text("Return")),
        ElevatedButton(onPressed: () {}, child: const Text("Renew")),
      ],
    );
  }

  Widget _buildShowTooloflist(
      List<Map<String, dynamic>> listofItem, ToolFieldConfig config) {
    return Container(
      height: SizeConFig.proportionalHeight * 5.2,
      // color: Colors.amber,
      child: ListView.builder(
        itemCount: listofItem.length,
        itemBuilder: (context, index) {
          final instu = listofItem[index];
          bool status = instu["allomentStatus"] == "true";
          // print(status);
          return Card(
              elevation: 50.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15)),
              borderOnForeground: true,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(
                    child: Card(
                      elevation: 50,
                      shadowColor: Colors.black,
                      color: const Color.fromARGB(255, 206, 235, 232),
                      child: BuildCustomText(
                          data: instu["instrumentType"],
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.cyan),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: SizeConFig.proportionalHeight * 0.8,
                          // color: Colors.red,
                          width: SizeConFig.proportionalHeight * 2,
                          child: Column(
                            children: [
                              _buidRowAndColumn(
                                  "Instrument Id:", instu["instrumentId"]),
                              _buidRowAndColumn(
                                  "Instrument Model:", instu["model"]),
                              _buidRowAndColumn("SerialNo:", instu["serialNo"]),
                              _buidRowAndColumn("instrument Condition:",
                                  instu["instrumentCondition"]),
                            ],
                          ),
                        ),
                        Container(
                          height: SizeConFig.proportionalHeight * 0.8,
                          width: SizeConFig.proportionalHeight * 2,
                          child: Column(
                            children: [
                              _buidRowAndColumn("Allotment-Status:",
                                  instu["allomentStatus"], status),
                              _buidRowAndColumn(
                                  "Site Location:", instu["siteLocation"]),
                              _buidRowAndColumn(
                                  "Collection Date:", instu["collectionDate"]),
                              _buidRowAndColumn("Due Date:", instu["dueDate"]),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: SizeConFig.proportionalHeight * 0.4,
                          width: SizeConFig.proportionalWidth * 3.3,
                          child: _buildDropDownSelectMember()),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Perform an action
                                print('Button pressed!');
                              },
                              icon: Icon(Icons.edit), // The icon widget
                              label: Text('Edit'), // The text label widget
                            ),
                            SizedBox(
                              width: SizeConFig.proportionalWidth * 0.5,
                            ),
                            SizedBox(
                              height: SizeConFig.proportionalHeight * 0.3,
                              width: SizeConFig.proportionalWidth * 2.3,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Perform an action
                                  print('Button pressed!');
                                },
                                icon: Icon(Icons.delete), // The icon widget
                                label: Text('Delete'), // The text label widget
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConFig.proportionalHeight * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text("Transfer"))),
                      Container(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text("Return"))),
                      Container(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text("Renew"))),
                    ],
                  ),
                  SizedBox(
                    height: SizeConFig.proportionalHeight * 0.1,
                  ),
                ],
              ));
        },
      ),
    );
  }

  //build grid box...................

  Widget _buildgridBox(String label, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.cyan.withOpacity(0.25),
        highlightColor: Colors.cyan.withOpacity(0.15),
        onTap: () {
          Provider.of<UserDashboardProvider>(context, listen: false)
              .increaseToolCounter(index, label);
        },
        child: Container(
          height: SizeConFig.proportionalHeight * 0.5,
          width: SizeConFig.proportionalWidth * 2,
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
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.cyan.shade900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///DROP DOWN MENU FOR SELECTING THE MEMBER OF USER WHERE USER SUBMIT INSTRUMENT....................
  Widget _buildDropDownSelectMember() {
    return TextField(
        controller: instrumentSubmitcontroller,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 12),
        readOnly: true,
        maxLines: 1,
        cursorColor: Colors.transparent,
        decoration: InputDecoration(
          isDense: true,
          labelText: "Select Memeber for submit Instrument",
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: const OutlineInputBorder(),
          suffixIcon: PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (value) {
              instrumentSubmitcontroller.text = value;
            },
            itemBuilder: (context) {
              return submitInstrument.map((aim) {
                return PopupMenuItem<String>(
                  value: aim,
                  child: Row(
                    children: [
                      Icon(Icons.select_all, size: 15),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          aim,
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ));
  }

  Widget _buidRowAndColumn(String label1, String label2, [bool? status]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildCustomText(
          data: label1,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: status == null
              ? Colors.black
              : status
                  ? Colors.green
                  : Colors.red,
        ),
        BuildCustomText(
          data: label2,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: status == null
              ? Colors.black
              : status
                  ? Colors.green
                  : Colors.red,
        ),
      ],
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildCustomText(
          data: "$label:",
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 4),
        BuildCustomText(
          data: value,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildInfoColumn(
    String l1,
    String v1,
    String l2,
    String v2,
    String l3,
    String v3,
    String l4,
    String v4, {
    bool? status,
  }) {
    return SizedBox(
      width: SizeConFig.proportionalHeight * 2,
      child: Column(
        children: [
          _buidRowAndColumn(l1, v1, status),
          _buidRowAndColumn(l2, v2),
          _buidRowAndColumn(l3, v3),
          _buidRowAndColumn(l4, v4),
        ],
      ),
    );
  }

  Widget _buildColumnContent(List<String> items, int count) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(count, (index) {
          final item = items;
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: SizeConFig.proportionalWidth * 2.0,
                child: BuildCustomText(
                  data: item[index],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          );
        }));
  }
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
