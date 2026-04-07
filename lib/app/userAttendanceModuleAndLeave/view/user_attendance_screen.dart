import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/controller/attendanceController.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/apply_leave.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_leave_logs.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/buildCustomText.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class UserAttendanceScreen extends StatefulWidget {
  const UserAttendanceScreen({super.key});

  @override
  State<UserAttendanceScreen> createState() => _UserAttendanceScreenState();
}

class _UserAttendanceScreenState extends State<UserAttendanceScreen> {
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController leaveReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller =
          Provider.of<Attendancecontroller>(context, listen: false);
      //fatch user leave logs
      controller.getLeaveLogs();
      controller.canApplyLeaveGet();

      final now = DateTime.now();

      controller.resetToToday();
      controller.fatchUserDailyAttendance(
        now.year.toString(),
        now.month.toString().padLeft(2, '0'),
      );
    });
  }

  final List<String> leave = ["ML", "CL", "LWP"];
  final List<String> typeList = ["Type", "CL", "ML", "LWP"];
  final List<String> usedList = ["Used", "10", "5", "2"];
  final List<String> balancedList = ["Balance", "20", "15", "8"];
  //new attendance

  DateTime? _selectedDate;

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
                          //-----------------------------------------BUILD FULL MONTHLY CALENDAR WITH DATE----------------------------
                          _buildFullMonthlyAttendance(),

                          SizeConFig.verticalBox(0.01),

                          ///THIS CONSUMER MEHTHOD HELP TO VIEW LIST VIEW OF USER DAILT LOGOUT LOG
                          _buildSessionListView(),

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
                                  color:
                                      const Color.fromARGB(255, 220, 215, 215),
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
                                                                  leaveTypeController,
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
                                                        _buildTextSection(
                                                            "To:"),
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
                                                              controller:
                                                                  leaveReasonController,
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
                                                  //APPLY LEAVE BUTTON CODE.................................................................................................
                                                  _buildleaveApplyButton()
                                                ],
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 8),
                                          //BUILD LEAVE LOGS ABD ATTOTED TOTAL LEAVE
                                          _buildAttotedLeave()
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

//BUILD LEAV LEAVE APPLY BUTTON
  Widget _buildleaveApplyButton() {
    return Consumer<Attendancecontroller>(
      builder: (context, controller, child) {
        // 1. LOADING STATE
        if (controller.isApply) {
          // Matches your variable name '_isAppy'
          return SizedBox(
            width: SizeConFig.proportionalWidth * 5,
            height: SizeConFig.proportionalHeight * 0.5,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.canApplyLeave != null &&
            controller.canApplyLeave!.data == true) {
          return Container(
            width: SizeConFig.proportionalWidth * 5,
            height: SizeConFig.proportionalHeight * 0.5,
            alignment: Alignment.center,
            child: Text(
              controller.canApplyLeave!.message ??
                  "Already Applied Leave Request",
              style: const TextStyle(
                  fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          );
        }

        // 3. APPLY BUTTON STATE
        return SizedBox(
          width: SizeConFig.proportionalWidth * 5,
          height: SizeConFig.proportionalHeight * 0.5,
          child: ElevatedButton(
            onPressed: () async {
              // Access other providers if needed
              final dashboardProvider =
                  Provider.of<UserDashboardProvider>(context, listen: false);

              // Prepare the request object
              ApplyLeaveRequest leave = ApplyLeaveRequest(
                leaveType: leaveTypeController.text,
                fromDate: dashboardProvider.fromDateController.text,
                toDate: dashboardProvider.toDateController.text,
                reason: leaveReasonController.text,
              );

              // Call the service using the 'controller' from Consumer
              final result = await controller.applyMonthlyLeave(leave.tojson());

              if (result != null && context.mounted) {
                ///call again method
                controller.canApplyLeaveGet();
                final bool isSuccess = result.success ?? false;
                final Color primaryColor =
                    isSuccess ? Colors.green.shade700 : Colors.red.shade700;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 5),
                    elevation: 6,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        Icon(
                          isSuccess ? Icons.check_circle : Icons.error_outline,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.message ?? "Update",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (result.data != null &&
                                  result.data!['suggestion'] != null)
                                Text(
                                  result.data!['suggestion'],
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    action: SnackBarAction(
                      label: 'OK',
                      textColor: primaryColor,
                      onPressed: () =>
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    ),
                  ),
                );
              }
            },
            child: const Text("Apply Leave"),
          ),
        );
      },
    );
  }

//BUILD TOTAL ALLOTED LEAVE

  Widget _buildAttotedLeave() {
    return Consumer<Attendancecontroller>(
      builder: (context, contro, child) {
        if (contro.isLeaveLogs) {
          return Expanded(
              child: Container(
            width: SizeConFig.proportionalWidth * 5,
            height: SizeConFig.proportionalHeight * 1.2,
            child: CircularProgressIndicator(),
          ));
        }
        if (contro.userLeaveLogs == null ||
            contro.userLeaveLogs!.data == null) {
          return const Center(child: Text("No leave logs found"));
        }

        return _buildLeaveLogs(contro.userLeaveLogs!);
      },
    );
  }

  ///BUILD FULL ATTENDANCE CALENDAR
  Widget _buildFullMonthlyAttendance() {
    return Consumer<Attendancecontroller>(
      builder: (context, pro, child) {
        return Stack(children: [
          if (pro.isLoadAttendace)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          TableCalendar(
            holidayPredicate: (day) {
              return day.weekday == DateTime.sunday;
            },
            calendarBuilders: CalendarBuilders(
              holidayBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.transparent, // Or a light red if you prefer
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 165, 207, 220), // Makes the text red
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                final dateKey = DateFormat('yyyy-MM-dd').format(day);
                final status = pro.attendanceListMap[dateKey];
                // 3. Define styling based on attendance status
                Color? bgColor;
                Color textColor = Colors.black;
                BoxBorder? border;
                if (status == "Present") {
                  bgColor = Colors.green.shade100;
                  textColor = Colors.green.shade900;
                  border = Border.all(color: Colors.green, width: 1);
                } else if (status == "Absent") {
                  bgColor = Colors.red.shade50;
                  textColor = Colors.red.shade900;
                } else if (status == "Upcoming") {
                  bgColor = const Color.fromARGB(255, 227, 223, 224);
                  textColor = const Color.fromARGB(255, 159, 166, 165);
                } else if (status == "Holiday") {
                  bgColor = Colors.amber.shade100;
                  textColor = Colors.amber.shade900;
                  border = Border.all(color: Colors.amber, width: 1);
                }
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: border,
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: status == "Present"
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            headerStyle: HeaderStyle(
              // Title styling
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              // Header background decoration
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    182, 167, 166, 169), // Example background color
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              // Center the title
              titleCentered: true,
              // Hide the format button
              formatButtonVisible: false,
              // Custom chevron icons
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 28,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 28,
              ),
              // Custom title format (e.g., "Month\nYear")
              titleTextFormatter: (date, locale) {
                final month = DateFormat.MMMM(locale).format(date);
                final years = DateFormat.y(locale).format(date);
                return '$month\n$years';
              },
            ),
            // Other
            pageAnimationDuration: Duration(milliseconds: 500),
            weekNumbersVisible: false,

            daysOfWeekHeight: 27.0,
            availableGestures: AvailableGestures.none,
            pageAnimationCurve: Curves.easeInCubic,
            daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle:
                    TextStyle(color: const Color.fromARGB(255, 54, 79, 244))),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            sixWeekMonthsEnforced: false,
            focusedDay: pro.focusedDay!,
            firstDay: pro.firstDay,
            lastDay: pro.lastDay,
            calendarFormat: CalendarFormat.month,
            dayHitTestBehavior: HitTestBehavior.opaque,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (selectedDay, focusDay) {
              final selectedKey = DateFormat('yyyy-MM-dd').format(selectedDay);

              final sessions = pro.attendanceEvent[selectedKey] ?? [];
              pro.updateFocusedDay(focusDay);
              pro.updateSelectedSessions(selectedKey);
              setState(() {
                _selectedDate = selectedDay;
              });
            },

            onPageChanged: (focusedDay) {
              pro.updateFocusedDay(focusedDay);
              pro.fatchUserDailyAttendance(focusedDay.year.toString(),
                  focusedDay.month.toString().padLeft(2, '0'));
            },
          )
        ]);
      },
    );
  }

  Widget _buildBalance(UsedLeaves? used) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BuildCustomText(
          data: used!.usedCl.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        SizeConFig.verticalBox(0.01),
        BuildCustomText(
          data: used.usedMl.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        SizeConFig.verticalBox(0.01),
        BuildCustomText(
          data: used.usedLwp.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildBalanceLeave(BalancedLeaves? balance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BuildCustomText(
          data: "Balance",
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        BuildCustomText(
          data: balance!.balancedCl.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        SizeConFig.verticalBox(0.01),
        BuildCustomText(
          data: balance.balancedMl.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        SizeConFig.verticalBox(0.01),
        BuildCustomText(
          data: balance.balancedLwp.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildUsedLeave(UsedLeaves? used) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BuildCustomText(
          data: "Used",
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        BuildCustomText(
          data: used!.usedCl.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        SizeConFig.verticalBox(0.01),
        BuildCustomText(
          data: used.usedMl.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        SizeConFig.verticalBox(0.01),
        BuildCustomText(
          data: used.usedLwp.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildLeaveLogs(UserLeaveLogs userLeaveLogs) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Container(
              width: SizeConFig.proportionalWidth * 5,
              height: SizeConFig.proportionalHeight * 1.2,
              // color: Colors.pink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTotalLeaveRecondchart(typeList),
                  _buildUsedLeave(userLeaveLogs.data!.used),
                  _buildBalanceLeave(userLeaveLogs.data!.balance)
                ],
              ),
            ),
            SizeConFig.verticalBox(0.01),
            Container(
              alignment: Alignment.centerLeft,
              width: SizeConFig.proportionalWidth * 5,
              height: SizeConFig.proportionalHeight * 0.2,
              // color: const Color.fromARGB(
              //     255, 192, 128, 85),
              child: BuildCustomText(
                  data: "Alloted:", fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: SizeConFig.proportionalWidth * 5,
              height: SizeConFig.proportionalHeight * 0.3,
              // color: const Color.fromARGB(
              //     255, 192, 128, 85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BuildCustomText(
                      data: "CL: ${userLeaveLogs.data!.alloted!.allotedCl}",
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                  SizeConFig.horizontalBox(0.1),
                  BuildCustomText(
                      data: "ML: ${userLeaveLogs.data!.alloted!.alllotedMl}",
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: SizeConFig.proportionalWidth * 5,
              height: SizeConFig.proportionalHeight * 0.2,
              child: BuildCustomText(
                data: "Renews on: 02-12-2027",
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSessionListView() {
    return Consumer<Attendancecontroller>(
      builder: (context, p, child) {
        // Check the filtered list, not the whole Map
        if (p.selectedDaySessions.isEmpty) {
          return const Center(child: Text("No sessions for this day"));
        }

        return ListView.builder(
          shrinkWrap: true, // Use this if inside a Column
          // physics:
          //     NeverScrollableScrollPhysics(), // Use this if inside a ScrollView
          itemCount: p.selectedDaySessions.length,
          itemBuilder: (context, index) {
            final session = p.selectedDaySessions[index];
            return sessionLogCard(session);
          },
        );
      },
    );
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
        controller: leaveTypeController,
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
              leaveTypeController.text = itemLabel(value);
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

  Widget _buildTotalLeave(List<String> items) {
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

  Widget sessionLogCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Login Time Column
          _buildMetricColumn(
            icon: Icons.login_rounded,
            label: "Login",
            value: item.loginTime.toString().substring(11, 19) ?? "--:--",
            color: Colors.green,
          ),

          _buildVerticalDivider(),

          // 2. Logout Time Column
          _buildMetricColumn(
            icon: Icons.logout_rounded,
            label: "Logout",
            value: item.logOutTime.substring(11, 19) ?? "Active",
            color: Colors.orangeAccent,
          ),

          _buildVerticalDivider(),

          // 3. Working Hour Column
          _buildMetricColumn(
            icon: Icons.timelapse_rounded,
            label: "Working",
            value: item.workingHour ?? "0h 0m",
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

// Helper for the columns to keep code DRY (Don't Repeat Yourself)
  Widget _buildMetricColumn({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

// Simple vertical line to separate sections
  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
