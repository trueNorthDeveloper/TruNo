import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';

class Usertranscationhistory extends StatefulWidget {
  const Usertranscationhistory({super.key});
  @override
  State<StatefulWidget> createState() => _UsertranscationHistoryState();
}

class _UsertranscationHistoryState extends State<Usertranscationhistory> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final provider = Provider.of<Expensecontroller>(context, listen: false);
  //     provider.fatchTranscationHistory();
  //   });
  //   _scrollController = ScrollController();
  //   _scrollController.addListener(_onScroll);
  // }

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Expensecontroller>(context, listen: false)
          .fatchTranscationHistory();
    });
  }

  // void _onScroll() {
  //   // Check if the user is near the end of the scroll position
  //   if (_scrollController.position.pixels >=
  //           _scrollController.position.maxScrollExtent * 0.8 &&
  //       !Provider.of<Expensecontroller>(context, listen: false)
  //           .isLoadTranscation) {
  //     Provider.of<Expensecontroller>(context, listen: false)
  //         .fatchTranscationHistory();
  //   }
  // }
  void _onScroll() {
    final provider = Provider.of<Expensecontroller>(context, listen: false);
    // Triggers load when user scrolls 80% down the page
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!provider.isLoadTranscation) {
        provider.fatchTranscationHistory();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:  SafeArea(
        child: Consumer<Expensecontroller>(
          builder: (context, pro, child) {
            // FIXED: Handle empty state outside ListView builder
            if (pro.transcationHistory.isEmpty && !pro.isLoadTranscation) {
              return const Center(child: Text("No Transactions Available"));
            }

            // FIXED: Initial full screen loading indicator
            if (pro.transcationHistory.isEmpty && pro.isLoadTranscation) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              controller: _scrollController,
              // Add +1 to the length to dynamically append a loading indicator at bottom row
              itemCount: pro.transcationHistory.length + (pro.isLoadTranscation ? 1 : 0),
              itemBuilder: (context, index) {
                // If it reaches the final extra index item, render a small pagination spinner
                if (index == pro.transcationHistory.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final item = pro.transcationHistory[index];

                final String displayAmount = item.amount != null
                    ? '${item.amount!.toStringAsFixed(2)}'
                    : '\$0.00';

                final String displayDate = item.createdAt != null
                    ? DateFormat('MMM dd, yyyy • hh:mm a').format(item.createdAt!)
                    : 'Unknown Date';

                final Color amountColor =
                    item.type?.toLowerCase() == 'credit' ? Colors.green : Colors.red;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: Text(
                        item.category != null && item.category.toString().isNotEmpty
                            ? item.category.toString()[0].toUpperCase()
                            : 'T',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      '${item.category ?? "Unknown"} (${item.type ?? "N/A"})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${item.description ?? "No description"}\n$displayDate',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    trailing: Text(
                      displayAmount,
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
