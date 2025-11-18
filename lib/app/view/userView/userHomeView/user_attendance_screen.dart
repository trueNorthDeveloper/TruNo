import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';

class UserAttendanceScreen extends StatefulWidget {
  const UserAttendanceScreen({super.key});

  @override
  State<UserAttendanceScreen> createState() => _UserAttendanceScreenState();
}

class _UserAttendanceScreenState extends State<UserAttendanceScreen> {
  // DateTime _focusedDay = DateTime.now();
  //Map<DateTime, List<dynamic>> _events = {};
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserDashboardProvider>(context, listen: false)
            .attendanceEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<UserDashboardProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Attendance')),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Consumer<UserDashboardProvider>(
                builder: (context, provider, child) {
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
                  formatButtonVisible:
                      false, // Hide 
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
                  return provider
                          .events[DateTime.utc(day.year, day.month, day.day)] ??
                      [];
                },
              );
            })
          ],
        )));
  }
}
