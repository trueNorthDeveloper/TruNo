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
    Future.microtask(() =>
        Provider.of<UserDashboardProvider>(context, listen: false)
            .attendanceEvent(context));
    print("many time");
  }

  final List<String> leave = ["ML", "CL", "LWP"];
  final List<String> typeList = ["Type", "CL", "ML", "LWP"];
  final List<String> usedList = ["Used", "10", "5", "2"];
  final List<String> balancedList = ["Balanced", "20", "15", "8"];
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
            body: SafeArea(
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
                        Container(
                          child: Column(
                            children: [
                              _buildChip("Apply For Leave", Colors.blueGrey),
                              buildLine(Colors.black),
                            ],
                          ),
                        ),
                        SizeConFig.verticalBox(0.01),
//card container-----------------------------------------------------------------------------------------------------------------
                        Container(
                          width: SizeConFig.proportionalWidth * 9,
                          height: SizeConFig.proportionalHeight * 2.3,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            //  /color: Colors.amber,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                //width: SizeConFig.proportionalWidth * 3.5,
                                // height: SizeConFig.proportionalHeight * 2.0,
                                // color: Colors.pink,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildRowField<String>(
                                      controller: applyLeaveController,
                                      label: "Leave  Type",
                                      items: leave,
                                      itemLabel: (item) => item,
                                      leadingIcon: Icons.work_outline,
                                    ),
                                    SizeConFig.verticalBox(0.01),
                                    //HERE IS USED HELPER METHOD FOR .....FROM DATE SELECTED..............................................................................
                                    Consumer<UserDashboardProvider>(
                                      builder: (context, pro, _) {
                                        return _buildCompleteSelectFromAndToDate(
                                            "From", onTap: () {
                                          pro.selectDate(
                                            context: context,
                                            isFromDate: true,
                                          );
                                        }, controller: pro.fromDateController);
                                      },
                                    ),
                                    SizeConFig.verticalBox(0.01),
                                    //HERE IS USED HELPER METHOD FOR .....To DATE SELECTED..............................................................................
                                    Consumer<UserDashboardProvider>(
                                      builder: (context, pro, _) {
                                        return _buildCompleteSelectFromAndToDate(
                                            "To", onTap: () {
                                          pro.selectDate(
                                            context: context,
                                            isFromDate: false,
                                          );
                                        }, controller: pro.toDateController);
                                      },
                                    ),
                                    SizeConFig.verticalBox(0.005),
                                    Container(
                                      width: SizeConFig.proportionalWidth * 3,
                                      height:
                                          SizeConFig.proportionalHeight * 0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width:
                                                  SizeConFig.proportionalWidth *
                                                      1.8,
                                              height: SizeConFig
                                                      .proportionalHeight *
                                                  0.2,
                                              child: BuildCustomText(
                                                data: "Leave Days",
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              )),
                                          Consumer<UserDashboardProvider>(
                                            builder: (context, value, child) {
                                              int finalValue = 0;
                                              String fromm =
                                                  value.fromDateController.text;
                                              String too =
                                                  value.toDateController.text;
                                              if (fromm.isNotEmpty &&
                                                  too.isNotEmpty) {
                                                int f = int.parse(
                                                    fromm.substring(8, 10));
                                                int t = int.parse(
                                                    too.substring(8, 10));

                                                finalValue = t - f;
                                              }

                                              return SizedBox(
                                                child: BuildCustomText(
                                                    data: "${finalValue}"),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    //END CONATINER END............................................................................................................
                                    Container(
                                      //color: Colors.black,
                                      width: SizeConFig.proportionalWidth * 4.0,
                                      height:
                                          SizeConFig.proportionalHeight * 0.5,
                                      child: Center(
                                        child: SizedBox(
                                          width: SizeConFig.proportionalWidth *
                                              2.01,
                                          height:
                                              SizeConFig.proportionalHeight *
                                                  0.2,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                print("apply button working");
                                              },
                                              child: BuildCustomText(
                                                data: "Apply",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: SizeConFig.proportionalWidth * 3.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizeConFig.verticalBox(0.005),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //---------------------
//build total leave and TYPE AND USED BALANCED----------------------------------------------------------------------------------------------------
                                        _buildTotalLeaveRecondchart(typeList),
                                        _buildTotalLeaveRecondchart(usedList),
                                        _buildTotalLeaveRecondchart(
                                            balancedList),
                                      ],
                                    ),
                                    SizeConFig.verticalBox(0.01),
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1 /
                                                100,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                51 /
                                                100,
                                        color: Colors.black),
                                    Container(
                                      width: SizeConFig.proportionalWidth * 4.0,
                                      height:
                                          SizeConFig.proportionalHeight * 0.7,
                                      //padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          // BoxShadow(
                                          //   color: Colors.black12,
                                          //   blurRadius: 4,
                                          // ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // HEADLINE
                                          // SizeConFig.verticalBox(0.02),
                                          BuildCustomText(
                                            data: "Total Available",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),

                                          // const Divider(),

                                          // CL ROW
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              BuildCustomText(
                                                  data: "CL:",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                              BuildCustomText(
                                                  data: "10",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              BuildCustomText(
                                                data: "ML:",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              Row(
                                                children: [
                                                  BuildCustomText(
                                                      data: "12",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                  // const SizedBox(width: 8),
                                                ],
                                              ),
                                            ],
                                          ),
                                          BuildCustomText(
                                            data: "Renew on 12-01-2026",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            // color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]))),
            )));
  }

  Widget _buildTotalLeaveRecondchart(List<String> items) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(4, (index) {
          // final item = ["Type", "CL", "ML", "LWP"];
          final item = items;
          return Column(
            children: [
              BuildCustomText(
                data: item[index],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              SizeConFig.verticalBox(0.01),
            ],
          );
        }));
  }

//------------------------------------------------BUILD CALENDER TEXT FILED.................
  Widget _buildCompleteSelectFromAndToDate(String fieldName,
      {required Null Function() onTap,
      required TextEditingController controller}) {
    return Container(
      // color: Colors.black,
      width: SizeConFig.proportionalWidth * 4.8,
      height: SizeConFig.proportionalHeight * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: SizeConFig.proportionalWidth * 1.8,
              height: SizeConFig.proportionalHeight * 0.2,
              child: BuildCustomText(
                data: fieldName,
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )),
//THIS BUILD SELECTDATEfILED METHOD SELECTED DATE USING CONTROLLER.................................................

          buildSelectDateField(
              label: "Select Date", controller: controller, onTap: onTap)
        ],
      ),
    );
  }

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

  Widget _buildRowField<T>(
      {required controller,
      required String label,
      required List<String> items,
      required Function(dynamic item) itemLabel,
      required IconData leadingIcon}) {
    return Container(
      // color: Colors.amber,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFormLabel(label),
          SizedBox(
            // width: SizeConFig.proportionalWidth * 1.5,
            // height: SizeConFig.proportionalHeight * 0.2,
            width: SizeConFig.proportionalWidth * 2.8,
            height: SizeConFig.proportionalHeight * 0.3,
            child: buildSelectField<String>(
              controller: controller,
              label: label,
              items: items,
              itemLabel: (item) => item,
              leadingIcon: Icons.leave_bags_at_home_sharp,
            ),
          ),
        ],
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
      width: SizeConFig.proportionalWidth * 1.8,
      height: SizeConFig.proportionalHeight * 0.2,
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

  Widget _buildChip(String text, Color color) {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
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
 // children: [
                                            //   BuildCustomText(
                                            //     data: "Type",
                                            //     fontSize: 12,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            //   SizeConFig.verticalBox(0.01),
                                            //   BuildCustomText(
                                            //     data: "CL",
                                            //     fontSize: 12,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            //   SizeConFig.verticalBox(0.01),
                                            //   BuildCustomText(
                                            //     data: "ML",
                                            //     fontSize: 12,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            //   SizeConFig.verticalBox(0.01),
                                            //   BuildCustomText(
                                            //     data: "LWP",
                                            //     fontSize: 12,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            // ],
                                              //-------------------------------
                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.start,
                                        //   children: [
                                        //     BuildCustomText(
                                        //       data: "Used",
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w400,
                                        //     ),
                                        //     SizeConFig.verticalBox(0.01),
                                        //     BuildCustomText(
                                        //       data: "10",
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w400,
                                        //     ),
                                        //     SizeConFig.verticalBox(0.01),
                                        //     BuildCustomText(
                                        //       data: "5",
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w400,
                                        //     ),
                                        //     SizeConFig.verticalBox(0.01),
                                        //     BuildCustomText(
                                        //       data: "2",
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w400,
                                        //     ),
                                        //   ],
                                        // ),
                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.start,
                                        //   children: [
                                        //     BuildCustomText(
                                        //       data: "Balanced",
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w400,
                                        //     ),
                                        //     SizeConFig.verticalBox(0.01),
                                        //     BuildCustomText(
                                        //         data: "20",
                                        //         fontSize: 12,
                                        //         fontWeight: FontWeight.w400),
                                        //     SizeConFig.verticalBox(0.01),
                                        //     BuildCustomText(
                                        //         data: "15",
                                        //         fontSize: 12,
                                        //         fontWeight: FontWeight.w400),
                                        //     SizeConFig.verticalBox(0.01),
                                        //     BuildCustomText(
                                        //         data: "8",
                                        //         fontSize: 12,
                                        //         fontWeight: FontWeight.w400),
                                        //   ],
                                        // ),
                                          // Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: List.generate(4, (index) {
                                        //       final item = [
                                        //         "Type",
                                        //         "CL",
                                        //         "ML",
                                        //         "LWP"
                                        //       ];
                                        //       return Column(
                                        //         children: [
                                        //           BuildCustomText(
                                        //             data: item[index],
                                        //             fontSize: 12,
                                        //             fontWeight: FontWeight.w400,
                                        //           ),
                                        //           SizeConFig.verticalBox(0.01),
                                        //         ],
                                        //       );
                                        //     })),
                                        // Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: List.generate(4, (index) {
                                        //       final item = [
                                        //         "Used",
                                        //         "10",
                                        //         "5",
                                        //         "2"
                                        //       ];
                                        //       return Column(
                                        //         children: [
                                        //           BuildCustomText(
                                        //             data: item[index],
                                        //             fontSize: 12,
                                        //             fontWeight: FontWeight.w400,
                                        //           ),
                                        //           SizeConFig.verticalBox(0.01),
                                        //         ],
                                        //       );
                                        //     })),
                                        // Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: List.generate(4, (index) {
                                        //       final item = [
                                        //         "Balanced",
                                        //         "20",
                                        //         "15",
                                        //         "8"
                                        //       ];
                                        //       return Column(
                                        //         children: [
                                        //           BuildCustomText(
                                        //             data: item[index],
                                        //             fontSize: 12,
                                        //             fontWeight: FontWeight.w400,
                                        //           ),
                                        //           SizeConFig.verticalBox(0.01),
                                        //         ],
                                        //       );
                                        //     })),