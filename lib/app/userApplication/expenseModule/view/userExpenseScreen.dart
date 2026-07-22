import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/dailyExpenseReponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/myBalanceResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/view/userExpenseCategoryScreen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/view/userTranscationHistory.dart';
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
    Provider.of<Expensecontroller>(context, listen: false).resetDate2();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Expensecontroller>().getMyAccountBalace();
    });
    //call daily expense method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Expensecontroller>().callingDailyExpense();
    });
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
        actions: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Usertranscationhistory(),
                      ));
                },
                icon: const Icon(Icons.remove_red_eye),
                label: const Text('Transcations'),
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            // SizedBox(
            //   height: SizeConFig.screenHeight * 1 / 100,
            // ),
            //TOTAL SUMMARY TOP OF THE SCREEN...

            Consumer<Expensecontroller>(builder: (context, prov, child) {
              if (prov.showBalance) return CircularProgressIndicator();
              return _buildTotalSummary(prov.myBalanceResponse);
            }),

            //SHOW CALENDAR WITH AMOUNT
            Consumer<Expensecontroller>(builder: (context, pro, child) {
              return _expenseShowCalendar(pro);
            }),

            // Consumer<Expensecontroller>(
            //   builder: (context, xpensecontroller, child) {
            //     if (xpensecontroller.itemAmount.isEmpty) {
            //       return const Text("empty");
            //     }

            //     final data = xpensecontroller.itemAmount;

            //     return ExpansionTile(
            //       // The "Header" showing the total amount
            //       title: Text(
            //         "Total Amount: ₹${data["dayTotalAmount"]}",
            //         style: const TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //       subtitle: Text("Date: ${data["date"]}"),
            //       // The "Expanded" list showing other details
            //       children: data.entries
            //           .where((entry) =>
            //               entry.key != "dayTotalAmount" && entry.key != "date")
            //           .map((entry) => ListTile(
            //                 title: Text(entry.key[0].toUpperCase() +
            //                     entry.key.substring(1)), // Capitalize key
            //                 trailing: Text("₹${entry.value}"),
            //               ))
            //           .toList(),
            //     );
            //   },
            // ),

            // _buildCoroseal(),
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

  // Widget _expenseShowCalendar(Expensecontroller expenseProvider) {
  //   return SingleChildScrollView(
  //     child: Column(children: [
  //       TableCalendar(
  //         holidayPredicate: (day) {
  //           return day.weekday == DateTime.sunday;
  //         },
  //         calendarBuilders: CalendarBuilders(
  //           holidayBuilder: (context, day, focusedDay) {
  //             return Container(
  //               margin: const EdgeInsets.all(4.0),
  //               alignment: Alignment.center,
  //               decoration: const BoxDecoration(
  //                 color: Color.fromARGB(
  //                     0, 188, 30, 30), // Or a light red if you prefer
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Text(
  //                 '${day.day}',
  //                 style: const TextStyle(
  //                   color: Color.fromARGB(
  //                       255, 165, 207, 220), // Makes the text red
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             );
  //           },
  //           // Handles standard cells styles
  //           defaultBuilder: (context, day, focusedDay) {
  //             final normalizedDate = DateTime(day.year, day.month, day.day);
  //             final DailySummary? summary =
  //                 expenseProvider.summaryByDate[normalizedDate];
  //             Color? bgColor;
  //             Color textColor = Colors.black87;
  //             BoxBorder? border;
  //             String? amountText;
  //             if (summary != null) {
  //               final apiStatus =
  //                   summary.status?.toString().toUpperCase() ?? '';
  //               final expenses = summary.totalExpensesPerDay ?? 0;
  //               if (apiStatus == "PRESENT") {
  //                 bgColor = Colors.green.shade50;
  //                 textColor = Colors.green.shade900;
  //                 border = Border.all(color: Colors.green.shade200, width: 1);
  //                 if (expenses > 0) amountText = "₹$expenses";
  //               } else if (apiStatus == "UPCOMING") {
  //                 bgColor = Colors.grey.shade100;
  //                 textColor = Colors.grey.shade500;
  //               }
  //             }

  //             // return Container(
  //             //   margin: const EdgeInsets.all(4.0),
  //             //   alignment: Alignment.center,
  //             //   decoration: BoxDecoration(
  //             //     color: bgColor,
  //             //     shape: BoxShape.circle,
  //             //     border: border,
  //             //   ),
  //             //   child: Text(
  //             //     '${day.day}',
  //             //     style: TextStyle(
  //             //       color: textColor,
  //             //       // fontWeight: status == "Present"
  //             //       //   ? FontWeight.bold
  //             //       // : FontWeight.normal,
  //             //     ),
  //             //   ),
  //             // );
  //           },
  //           todayBuilder: (context, day, focusedDay) {
  //             return Container(
  //               margin: const EdgeInsets.all(4.0),
  //               alignment: Alignment.center,
  //               decoration: const BoxDecoration(
  //                 color: Colors.blueAccent,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Text(
  //                 '${day.day}',
  //                 style: const TextStyle(
  //                     color: Colors.white, fontWeight: FontWeight.bold),
  //               ),
  //             );
  //           },
  //         ),
  //         headerStyle: HeaderStyle(
  //           // Title styling
  //           titleTextStyle: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 20.0,
  //             fontWeight: FontWeight.bold,
  //           ),
  //           // Header background decoration
  //           decoration: BoxDecoration(
  //             color: const Color.fromARGB(
  //                 182, 167, 166, 169), // Example background color
  //             borderRadius: BorderRadius.circular(10.0), // Rounded corners
  //           ),
  //           // Center the title
  //           titleCentered: true,
  //           // Hide the format button
  //           formatButtonVisible: false,
  //           // Custom chevron icons
  //           leftChevronIcon: const Icon(
  //             Icons.chevron_left,
  //             color: Colors.white,
  //             size: 28,
  //           ),
  //           rightChevronIcon: const Icon(
  //             Icons.chevron_right,
  //             color: Colors.white,
  //             size: 28,
  //           ),
  //           // Custom title format (e.g., "Month\nYear")
  //           titleTextFormatter: (date, locale) {
  //             final month = DateFormat.MMMM(locale).format(date);
  //             final years = DateFormat.y(locale).format(date);
  //             return '$month\n$years';
  //           },
  //         ),
  //         // Other
  //         pageAnimationDuration: Duration(milliseconds: 500),
  //         weekNumbersVisible: false,

  //         daysOfWeekHeight: 27.0,
  //         availableGestures: AvailableGestures.none,
  //         pageAnimationCurve: Curves.easeInCubic,
  //         daysOfWeekStyle: DaysOfWeekStyle(
  //             weekdayStyle:
  //                 TextStyle(color: const Color.fromARGB(255, 54, 79, 244))),
  //         startingDayOfWeek: StartingDayOfWeek.sunday,
  //         sixWeekMonthsEnforced: false,
  //         firstDay: DateTime(2020),
  //         lastDay: DateTime(2030),
  //         focusedDay: expenseProvider.curreentDate,

  //         calendarFormat: CalendarFormat.month,
  //         dayHitTestBehavior: HitTestBehavior.opaque,
  //         // CRITICAL: Tells the calendar which cell needs the active selection visual ri
  //         selectedDayPredicate: (day) {
  //           return isSameDay(expenseProvider.chosenDate, day);
  //         },
  //         // Handles day tapping action
  //         onDaySelected: (selectedDay, focusDay) {
  //           expenseProvider.curreentDate = focusDay;

  //           expenseProvider.selectDay(selectedDay);
  //         },

  //         onPageChanged: (focusedDay) {
  //           expenseProvider.curreentDate = focusedDay;
  //           expenseProvider.callingDailyExpense();
  //         },
  //       ),
  //       //SHOW TOTAL.................SUMMARY OF MONTHS..........
  //       Text(
  //         "${expenseProvider.dailyExpenseRespone?.data?.totalDaysWithExpenses ?? 0}",
  //         style: TextStyle(fontSize: 15),
  //       ),
  //       Text(
  //         "${expenseProvider.dailyExpenseRespone?.data?.aggregateExpense ?? 0}",
  //         style: TextStyle(fontSize: 15),
  //       )
  //     ]),
  //   );
  // }
  Widget _buildMonthSummary(
      {required dynamic totalDays, required dynamic totalAmount}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(
            icon: Icons.calendar_month,
            label: "Days with Expenses",
            value: "$totalDays",
          ),
          Container(height: 36, width: 1, color: Colors.blue.shade100),
          _summaryItem(
            icon: Icons.currency_rupee,
            label: "Total Amount",
            value: "₹$totalAmount",
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _expenseShowCalendar(Expensecontroller expenseProvider) {
    final data = expenseProvider.dailyExpenseRespone?.data;
    final totalDays = data?.totalDaysWithExpenses ?? 0;
    final totalAmount = data?.aggregateExpense ?? 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ---- TOP SUMMARY BAR ----
          _buildMonthSummary(totalDays: totalDays, totalAmount: totalAmount),

          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: expenseProvider.curreentDate,
            selectedDayPredicate: (day) {
              return isSameDay(expenseProvider.chosenDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              expenseProvider.curreentDate = focusedDay;
              expenseProvider.selectDay(
                  selectedDay); // sets selectedDaySummary + chosenDate
            },
            onPageChanged: (focusedDay) {
              expenseProvider.curreentDate = focusedDay;
              expenseProvider.callingDailyExpense();
            },
            holidayPredicate: (day) {
              return day.weekday == DateTime.sunday;
            },
            calendarBuilders: CalendarBuilders(
              holidayBuilder: (context, day, focusedDay) {
                return _buildCalendarCell(
                    day: day, textColor: Colors.red.shade300);
              },
              defaultBuilder: (context, day, focusedDay) {
                final normalizedDate = DateTime(day.year, day.month, day.day);
                final DailySummary? summary =
                    expenseProvider.summaryByDate[normalizedDate];

                Color? bgColor;
                Color textColor = Colors.black87;
                BoxBorder? border;
                String? amountText;

                if (summary != null) {
                  final String apiStatus =
                      summary.status?.toString().toUpperCase() ?? '';
                  final num expenses = summary.totalExpensesPerDay ?? 0;

                  if (apiStatus == "PRESENT") {
                    bgColor = Colors.green.shade50;
                    textColor = Colors.green.shade900;
                    border = Border.all(color: Colors.green.shade200, width: 1);
                    if (expenses > 0) amountText = "₹$expenses";
                  } else if (apiStatus == "UPCOMING") {
                    bgColor = Colors.grey.shade100;
                    textColor = Colors.grey.shade500;
                  }
                }

                return _buildCalendarCell(
                  day: day,
                  bgColor: bgColor,
                  textColor: textColor,
                  border: border,
                  amountText: amountText,
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          _buildExpenseBreakdown(expenseProvider),
        ],
      ),
    );
  }

  Widget _buildCalendarCell({
    required DateTime day,
    Color? bgColor,
    required Color textColor,
    BoxBorder? border,
    String? amountText,
  }) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (amountText != null)
            Text(
              amountText,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown(Expensecontroller provider) {
    final summary = provider.selectedDaySummary;

    // Guard clause: Shows placeholder message when no date has been tapped yet
    if (summary == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Text(
          "Please tap a highlighted date to view categories.",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }

    final categories = summary.categories;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.between,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Date: ${summary.expenseDate}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "Total Spent: ₹${summary.totalExpensesPerDay}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const Divider(thickness: 1.2),
          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child:
                  Text("No individual category expenses logged for this day."),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Scroll managed by parent
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 0.5,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.payment, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      cat.categoryName ?? "General Expense",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("Status: ${cat.status ?? 'N/A'}"),
                    trailing: Text(
                      "₹${cat.expenseAmount}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            )
        ],
      ),
    );
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

  Widget _buildTotalSummary(MyBalanceRespone? myBalanceResponse) {
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
            // _buildTextAndAmount("Paid", "2,000", Colors.green),
            // _divider(),
            // _buildTextAndAmount("Balance", "900", Colors.blueGrey),
            // _divider(),
            // _buildTextAndAmount("Total", "100", Colors.redAccent),
            _buildTextAndAmount("Paid",
                myBalanceResponse?.data?.totalCreditAmount, Colors.green),
            _divider(),
            _buildTextAndAmount("Balance",
                myBalanceResponse?.data?.availableAmount, Colors.blueGrey),
            _divider(),
            _buildTextAndAmount("Expense",
                myBalanceResponse?.data?.totalExpenseAmount, Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAndAmount(String name, dynamic amount, Color color) {
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
