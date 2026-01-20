import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/buildCustomText.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class UserAttendanceScreen extends StatefulWidget {
  const UserAttendanceScreen({super.key});

  @override
  State<UserAttendanceScreen> createState() => _UserAttendanceScreenState();
}

class _UserAttendanceScreenState extends State<UserAttendanceScreen> {
  final TextEditingController applyLeaveController = TextEditingController();
  final TextEditingController leaveReasonController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<UserDashboardProvider>(context, listen: false)
    //         .attendanceEvent(context));
    // print("many time");
  }

  final List<String> leave = ["ML", "CL", "LWP"];
  final List<String> typeList = ["Type", "CL", "ML", "LWP"];
  final List<String> usedList = ["Used", "10", "5", "2"];
  final List<String> balancedList = ["Balance", "20", "15", "8"];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          context.read<UserDashboardProvider>().clearDates();
          return true; // allows back navigation
        },
        child: Scaffold(
            appBar: AppBar(
              title: Center(child: const Text('Attendance')),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          //show caleinder.........................................................................
                          _buildCalender(),
                          SizeConFig.verticalBox(0.01),
                          _buildBreakLine(),
                          SizeConFig.verticalBox(0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTextName("Present Days", "1"),
                              _buildTextName("Absent Days", "10"),
                              _buildTextName("Average Days", "1.1"),
                              _buildTextName("Total Hours", "200"),
                            ],
                          ),
                          SizeConFig.verticalBox(0.01),
                          //apply leave and leave log start here------------------------------

                          Container(
                              width: double.infinity,
                              height: SizeConFig.proportionalHeight * 2.9,
                              decoration: BoxDecoration(
                                //  / color: Colors.amber,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Column(children: [
                                SizeConFig.verticalBox(0.01),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    BuildCustomText(
                                      data: "Apply for Leave",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    BuildCustomText(
                                      data: "Leave Log",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    // Top red divider
                                    SizeConFig.verticalBox(0.01),
                                    Container(
                                      height:
                                          SizeConFig.proportionalHeight * 0.01,
                                      color: Colors.grey.shade300,
                                      width: double.infinity,
                                    ),

                                    SizeConFig.verticalBox(0.01),

                                    // Main content
                                    SizedBox(
                                      height:
                                          SizeConFig.proportionalHeight * 2.4,
                                      child: Row(
                                        children: [
                                          //-----------------------NEW LEFT SECTION.............................
                                          Expanded(
                                            child: Container(
                                              //   color: Colors.amber,
                                              child: Column(
                                                children: [
                                                  //LEAVE TYPE................................CONTAINER--------------------------------
                                                  Container(
                                                    height: SizeConFig
                                                            .proportionalHeight *
                                                        0.3,
                                                    child: Row(
                                                      children: [
                                                        _buildTextSection(
                                                            "Leave Type:"),
                                                        SizedBox(
                                                          width: SizeConFig
                                                                  .proportionalWidth *
                                                              3,
                                                          child: _createFiled<
                                                                  String>(
                                                              controller:
                                                                  applyLeaveController,
                                                              itemLabel:
                                                                  (item) =>
                                                                      item,
                                                              items: leave,
                                                              righLabelText:
                                                                  "select leave type"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizeConFig.verticalBox(0.01),
                                                  // SELECT FROM DATE CONTAINER FOR DATE...........................
                                                  Container(
                                                      height: SizeConFig
                                                              .proportionalHeight *
                                                          0.3,
                                                      child: Row(children: [
                                                        _buildTextSection(
                                                            "From:"),
                                                        Consumer<
                                                            UserDashboardProvider>(
                                                          builder: (context,
                                                              pro, child) {
                                                            return _buildFromDate(
                                                              controller: pro
                                                                  .fromDateController,
                                                              onTap: () {
                                                                pro.selectDate(
                                                                    context:
                                                                        context,
                                                                    isFromDate:
                                                                        true);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ])),
                                                  SizeConFig.verticalBox(0.01),
                                                  //SELECT TO DATE FILED CALENDER..........................................................

                                                  Container(
                                                      width: SizeConFig
                                                              .proportionalWidth *
                                                          5,
                                                      height: SizeConFig
                                                              .proportionalHeight *
                                                          0.3,
                                                      child: Row(children: [
                                                        _buildTextSection("To:"),
                                                        Consumer<
                                                            UserDashboardProvider>(
                                                          builder: (context,
                                                              pro, child) {
                                                            return _buildFromDate(
                                                              controller: pro
                                                                  .toDateController,
                                                              onTap: () {
                                                                pro.selectDate(
                                                                    context:
                                                                        context,
                                                                    isFromDate:
                                                                        false);
                                                              },
                                                            );
                                                          },
                                                        )
                                                      ])),
                                                  //       SizeConFig.verticalBox(0.01),
                                                  //       //------------------------------------------------------total leave Days
                                                  Container(
                                                      width: SizeConFig
                                                              .proportionalWidth *
                                                          5,
                                                      height: SizeConFig
                                                              .proportionalHeight *
                                                          0.3,
                                                      child: Row(children: [
                                                        _buildTextSection(
                                                            "Leave Days:"),
                                                        Consumer<
                                                                UserDashboardProvider>(
                                                            builder: (context,
                                                                value, child) {
                                                          int finalValue = 0;
                                                          String fromm = value
                                                              .fromDateController
                                                              .text;
                                                          String too = value
                                                              .toDateController
                                                              .text;
                                                          if (fromm
                                                                  .isNotEmpty &&
                                                              too.isNotEmpty) {
                                                            int f = int.parse(
                                                                fromm.substring(
                                                                    8, 10));
                                                            int t = int.parse(
                                                                too.substring(
                                                                    8, 10));

                                                            finalValue =
                                                                (t - f) + 1;
                                                          }

                                                          return SizedBox(
                                                            child: BuildCustomText(
                                                                data:
                                                                    "${finalValue}"),
                                                          );
                                                        })
                                                      ])),
                                                  Container(
                                                      width: SizeConFig
                                                              .proportionalWidth *
                                                          5,
                                                      height: SizeConFig
                                                              .proportionalHeight *
                                                          0.3,
                                                      child: Row(children: [
                                                        _buildTextSection(
                                                            "Leave Reason:"),
                                                        SizedBox(
                                                          width: SizeConFig
                                                                  .proportionalWidth *
                                                              3,
                                                          child: TextField(
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                              readOnly: false,
                                                              maxLines: 1,
                                                              cursorColor: Colors
                                                                  .transparent,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .grey
                                                                    .shade100,
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                isDense: true,
                                                                labelText:
                                                                    "Reason",
                                                                labelStyle:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              )),
                                                        ),
                                                      ])),
                                                  SizeConFig.verticalBox(0.01),
                                                  Container(
                                                    width: SizeConFig
                                                            .proportionalWidth *
                                                        5,
                                                    height: SizeConFig
                                                            .proportionalHeight *
                                                        0.5,
                                                    //color: Colors.amber,
                                                    child: Center(
                                                      child: ElevatedButton(
                                                          onPressed: () {},
                                                          child: Text(
                                                              "Submit For Approval")),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          // Right section..................................................
                                          Expanded(
                                            child: Container(
                                              // color: const Color.fromARGB(
                                              //   255,
                                              //   60,
                                              //   201,
                                              //   67,
                                              // ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: SizeConFig
                                                            .proportionalWidth *
                                                        5,
                                                    height: SizeConFig
                                                            .proportionalHeight *
                                                        1.2,
                                                    // color: Colors.pink,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        _buildTotalLeaveRecondchart(
                                                            typeList),
                                                        _buildTotalLeaveRecondchart(
                                                            usedList),
                                                        _buildTotalLeaveRecondchart(
                                                            balancedList),
                                                      ],
                                                    ),
                                                  ),
                                                  SizeConFig.verticalBox(0.01),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: SizeConFig
                                                            .proportionalWidth *
                                                        5,
                                                    height: SizeConFig
                                                            .proportionalHeight *
                                                        0.2,
                                                    // color: const Color.fromARGB(
                                                    //     255, 192, 128, 85),
                                                    child: BuildCustomText(
                                                        data: "Alloted:",
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: SizeConFig
                                                            .proportionalWidth *
                                                        5,
                                                    height: SizeConFig
                                                            .proportionalHeight *
                                                        0.3,
                                                    // color: const Color.fromARGB(
                                                    //     255, 192, 128, 85),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        BuildCustomText(
                                                            data: "CL: 12",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        SizeConFig
                                                            .horizontalBox(0.1),
                                                        BuildCustomText(
                                                            data: "ML: 3",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: SizeConFig
                                                            .proportionalWidth *
                                                        5,
                                                    height: SizeConFig
                                                            .proportionalHeight *
                                                        0.2,
                                                    child: BuildCustomText(
                                                      data:
                                                          "Renews on: 02-12-2027",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ]))

                          //apply leave and leave log end here--------------------------------
                        ]))),
              ),
            )));
  }

  Widget _buildFromDate(
      {required Null Function() onTap,
      required TextEditingController controller}) {
    return Expanded(
      child: TextField(
        readOnly: true,
        controller: controller,
        style: TextStyle(fontSize: 12),
        cursorColor: Colors.transparent,
        decoration: InputDecoration(
          labelText: "Select Date",
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 10),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 20,
            ),
            onPressed: onTap,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
      ),
    );
  }

  Widget _createFiled<T>({
    required String righLabelText,
    required TextEditingController controller,
    required List<T> items,
    required String Function(T item) itemLabel,
  }) {
    return TextField(
        controller: applyLeaveController,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 12),
        readOnly: true,
        maxLines: 1,
        cursorColor: Colors.transparent,
        decoration: InputDecoration(
          isDense: true,
          labelText: righLabelText,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: const OutlineInputBorder(),
          suffixIcon: PopupMenuButton<T>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (value) {
              applyLeaveController.text = itemLabel(value);
            },
            itemBuilder: (context) {
              return items.map((aim) {
                return PopupMenuItem<T>(
                  value: aim,
                  child: Row(
                    children: [
                      Icon(Icons.select_all, size: 15),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          itemLabel(aim),
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

  Widget _buildTotalLeaveRecondchart(List<String> items) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(4, (index) {
          final item = items;
          return Column(
            children: [
              BuildCustomText(
                data: item[index],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              SizeConFig.verticalBox(0.01),
            ],
          );
        }));
  }
//crete test section

  Widget _buildTextSection(String data) {
    return Container(
      alignment: Alignment.centerLeft,
      width: SizeConFig.proportionalWidth * 1.7,
      child: BuildCustomText(
        data: data,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

//------------------------------------------------BUILD CALENDER TEXT FILED.................

//SELECTED DATE IN BOTH FROM AND TO DATE  ON TAP ON CALENDER.........................................................
  Widget buildSelectDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: SizeConFig.proportionalWidth * 2.8,
      height: SizeConFig.proportionalHeight * 0.3,
      child: TextField(
        readOnly: true,
        controller: controller,
        style: TextStyle(fontSize: 12),
        cursorColor: Colors.transparent,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 10),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 20,
            ),
            onPressed: onTap,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
      ),
    );
  }

  Widget buildSizedTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      width: SizeConFig.proportionalWidth * 3.5,
      height: SizeConFig.proportionalHeight * 0.3,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 1.3),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget buildFormLabel(String text) {
    return SizedBox(
      //width: SizeConFig.proportionalWidth * 1.8,
      //  height: SizeConFig.proportionalHeight * 0.2,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget buildLine(Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.1 / 100,
          width: MediaQuery.of(context).size.width * 17 / 100,
          color: color),
    );
  }

  Widget buildSelectField<T>({
    required TextEditingController controller,
    required String label,
    required List<T> items,
    required String Function(T item) itemLabel,
    IconData? leadingIcon,
    void Function(T selected)? onSelected,
  }) {
    return SizedBox(
      // width: SizeConFig.proportionalWidth * 3.5,
      //height: SizeConFig.proportionalHeight * 0.1,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: TextStyle(fontSize: 12),
        readOnly: true,
        maxLines: null,
        cursorColor: Colors.transparent,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: PopupMenuButton<T>(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 15.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            onSelected: (value) {
              controller.text = itemLabel(value);
              if (onSelected != null) {
                onSelected(value);
              }
            },
            itemBuilder: (context) {
              return items.map((item) {
                return PopupMenuItem<T>(
                  value: item,
                  child: Row(
                    children: [
                      if (leadingIcon != null) ...[
                        Icon(leadingIcon, size: 15),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Text(
                          itemLabel(item),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        ),
      ),
    );
  }

  Widget _buildTextName(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 24, 18, 18),
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakLine() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15 / 100,
      decoration:
          BoxDecoration(color: const Color.fromARGB(255, 186, 176, 176)),
    );
  }

  Widget _buildCalender() {
    return Consumer<UserDashboardProvider>(builder: (context, provider, child) {
      return TableCalendar(
        // onPageChanged: (focusedDay) {

        // },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return const SizedBox();

            // Get first event type (Present/Absent)
            final eventType = events.first.toString();

            Color color = Colors.grey;
            if (eventType == 'Present') {
              color = Colors.green;
            } else if (eventType == 'Absent') {
              color = Colors.red;
            }

            return Positioned(
              bottom: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),

        calendarFormat: CalendarFormat.month, // Or week, twoWeeks
        headerStyle: HeaderStyle(
          formatButtonVisible: false, // Hide
        ),
        calendarStyle: CalendarStyle(
          weekNumberTextStyle: TextStyle(color: Colors.red),
          weekendTextStyle: TextStyle(color: Colors.red),
          markerDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        focusedDay: provider.focusedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        eventLoader: (day) {
          return provider.events[DateTime.utc(day.year, day.month, day.day)] ??
              [];
        },
      );
    });
  }
}
