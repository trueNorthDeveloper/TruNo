import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class UserAttendanceScreen extends StatefulWidget {
  const UserAttendanceScreen({super.key});

  @override
  State<UserAttendanceScreen> createState() => _UserAttendanceScreenState();
}

class _UserAttendanceScreenState extends State<UserAttendanceScreen> {
  // DateTime _focusedDay = DateTime.now();
  //Map<DateTime, List<dynamic>> _events = {};
  final TextEditingController applyLeaveController = TextEditingController();
  final TextEditingController leaveReasonController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserDashboardProvider>(context, listen: false)
            .attendanceEvent(context));
  }

  final List<String> leave = ["ML", "CL", "LWP"];
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<UserDashboardProvider>(context, listen: false);
    return Scaffold(
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

                Center(
                  child: Container(
                    width: SizeConFig.proportionalWidth * 9,
                    height: SizeConFig.proportionalHeight * 2.3,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    child: Column(
                      children: [
                        _buildRowField<String>(
                          controller: applyLeaveController,
                          label: "Leave  Type",
                          items: leave,
                          itemLabel: (item) => item,
                          leadingIcon: Icons.work_outline,
                        ),
                        SizeConFig.verticalBox(0.01),
                        _buildRowField<String>(
                          controller: applyLeaveController,
                          label: "From",
                          items: leave,
                          itemLabel: (item) => item,
                          leadingIcon: Icons.work_outline,
                        ),
                        SizeConFig.verticalBox(0.01),
                        _buildRowField<String>(
                          controller: applyLeaveController,
                          label: "To",
                          items: leave,
                          itemLabel: (item) => item,
                          leadingIcon: Icons.work_outline,
                        ),
                        SizeConFig.verticalBox(0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildFormLabel("Leave Days"),
                            SizedBox(
                                width: SizeConFig.proportionalWidth * 3.5,
                                child: buildFormLabel("0")),
                          ],
                        ),
                        SizeConFig.verticalBox(0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildFormLabel("Leave Reason"),
                            SizedBox(
                                child: buildSizedTextField(
                              controller: leaveReasonController,
                              hintText: "Enter Reason",
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
  }

  Widget _buildRowField<T>(
      {required controller,
      required String label,
      required List<String> items,
      required Function(dynamic item) itemLabel,
      required IconData leadingIcon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFormLabel(label),
        SizedBox(
          width: SizeConFig.proportionalWidth * 3.5,
          child: buildSelectField<String>(
            controller: controller,
            label: label,
            items: items,
            itemLabel: (item) => item,
            leadingIcon: Icons.leave_bags_at_home_sharp,
          ),
        ),
      ],
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
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
        letterSpacing: 0.2,
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
      width: SizeConFig.proportionalWidth * 3.5,
      height: SizeConFig.proportionalHeight * 0.3,
      child: TextField(
        controller: controller,
        readOnly: true,
        cursorColor: Colors.transparent,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: PopupMenuButton<T>(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 28,
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
                        Icon(leadingIcon, size: 18),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Text(
                          itemLabel(item),
                          style: const TextStyle(fontSize: 14),
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
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
