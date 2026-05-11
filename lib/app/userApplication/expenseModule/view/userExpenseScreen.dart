import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/view/userExpenseCategory.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class UserExpenseScreens extends StatefulWidget {
  const UserExpenseScreens({super.key});

  @override
  State<UserExpenseScreens> createState() => _UserexpensescreenzsState();
}

class _UserexpensescreenzsState extends State<UserExpenseScreens> {
  @override
  void initState() {
    super.initState();
    // Fetch and format on page open
    Provider.of<Expensecontroller>(context, listen: false).resetDate();
  }

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
          "EXPENSE",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            // SizedBox(
            //   height: SizeConFig.screenHeight * 1 / 100,
            // ),
            //TOTAL SUMMARY TOP OF THE SCREEN...
            _buildTotalSummary(),
            //SHOW CALENDAR WITH AMOUNT
            _expenseShowCalendar(),

            Consumer<Expensecontroller>(
              builder: (context, xpensecontroller, child) {
                if (xpensecontroller.itemAmount.isEmpty) {
                  return const Text("empty");
                }

                final data = xpensecontroller.itemAmount;

                return ExpansionTile(
                  // The "Header" showing the total amount
                  title: Text(
                    "Total Amount: ₹${data["dayTotalAmount"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Date: ${data["date"]}"),
                  // The "Expanded" list showing other details
                  children: data.entries
                      .where((entry) =>
                          entry.key != "dayTotalAmount" && entry.key != "date")
                      .map((entry) => ListTile(
                            title: Text(entry.key[0].toUpperCase() +
                                entry.key.substring(1)), // Capitalize key
                            trailing: Text("₹${entry.value}"),
                          ))
                      .toList(),
                );
              },
            ),

            _buildCoroseal(),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Userexpensecategory(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _expenseShowCalendar() {
    return Consumer<Expensecontroller>(
        builder: (context, expenseProvider, child) {
      return TableCalendar(
        holidayPredicate: (day) {
          return day.weekday == DateTime.sunday;
        },
        calendarBuilders: CalendarBuilders(
          holidayBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    0, 188, 30, 30), // Or a light red if you prefer
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color:
                      Color.fromARGB(255, 165, 207, 220), // Makes the text red
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          defaultBuilder: (context, day, focusedDay) {
            //final dateKey = DateFormat('yyyy-MM-dd').format(day);
            //final status = pro.attendanceListMap[dateKey];
            // 3. Define styling based on attendance status
            Color? bgColor;
            Color textColor = Colors.black;
            BoxBorder? border;
            // if (status == "Present") {
            //   bgColor = Colors.green.shade100;
            //   textColor = Colors.green.shade900;
            //   border = Border.all(color: Colors.green, width: 1);
            // } else if (status == "Absent") {
            //   bgColor = Colors.red.shade50;
            //   textColor = Colors.red.shade900;
            // } else if (status == "Upcoming") {
            //   bgColor = const Color.fromARGB(255, 227, 223, 224);
            //   textColor = const Color.fromARGB(255, 159, 166, 165);
            // } else if (status == "Holiday") {
            //   bgColor = Colors.amber.shade100;
            //   textColor = Colors.amber.shade900;
            //   border = Border.all(color: Colors.amber, width: 1);
            // }
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
                  // fontWeight: status == "Present"
                  //   ? FontWeight.bold
                  // : FontWeight.normal,
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
        focusedDay: expenseProvider.focusedDay!,
        firstDay: expenseProvider.firstDay,
        lastDay: expenseProvider.lastDay,
        calendarFormat: CalendarFormat.month,
        dayHitTestBehavior: HitTestBehavior.opaque,
        // selectedDayPredicate: (day) {
        //   return isSameDay(_selectedDate, day);
        // },
        onDaySelected: (selectedDay, focusDay) {
          final selectedKey = DateFormat('dd-MM-yyyy').format(selectedDay);
          //yyyy-MM-dd').
          print(selectedKey);
          expenseProvider.callexpenseAmountDateWise(selectedKey);
          //final sessions = pro.attendanceEvent[selectedKey] ?? [];
          // pro.updateFocusedDay(focusDay);
          //  pro.updateSelectedSessions(selectedKey);
          // setState(() {
          //   _selectedDate = selectedDay;
          // });
        },

        onPageChanged: (focusedDay) {
          // pro.updateFocusedDay(focusedDay);
          // pro.fatchUserDailyAttendance(focusedDay.year.toString(),
          //   focusedDay.month.toString().padLeft(2, '0'));
        },
      );
    });
  }

  final List<String> textList = ['hey navendra welcome to trueNorth'];
  Widget _buildCoroseal() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 50.0,
        autoPlay: true,
        animateToClosest: true,
        enableInfiniteScroll: true,
      ), // autoPlay
      items: textList.map((text) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: const Color.fromARGB(255, 136, 157, 194),
          ),
          width: SizeConFig.proportionalWidth * 7,
          child:
              Center(child: Text(text, style: TextStyle(color: Colors.white))),
        );
      }).toList(),
    );
  }

  Widget _buildTotalSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTextAndAmount("Paid", "2,000", Colors.green),
            _divider(),
            _buildTextAndAmount("Balance", "900", Colors.blueGrey),
            _divider(),
            _buildTextAndAmount("Total", "100", Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAndAmount(String name, String amount, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: SizeConFig.screenHeight * 0.4 / 100),
        Text(
          "$amount",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
