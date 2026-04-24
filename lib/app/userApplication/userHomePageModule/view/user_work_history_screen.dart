import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/user_dashboard_provider.dart';

class UserWorkHistory extends StatefulWidget {
  const UserWorkHistory({super.key});

  @override
  State<UserWorkHistory> createState() => _MyUserWorkHistory();
}

class _MyUserWorkHistory extends State<UserWorkHistory> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<UserDashboardProvider>(context, listen: false);
      provider.userWorkHistory();
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Check if the user is near the end of the scroll position
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !Provider.of<UserDashboardProvider>(context, listen: false)
            .isHistoryload) {
      Provider.of<UserDashboardProvider>(context, listen: false)
          .userWorkHistory();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Exit App'),
                    content: const Text('Are you sure you want to exit?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ));
          if (shouldExit == true) {
            SystemNavigator.pop(); // Recommended way to exit
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Center(child: const Text("Work history")),
          ),
          body: Consumer<UserDashboardProvider>(
            builder: (context, prov, child) {
              if (prov.isHistoryload && prov.usWrkHistory.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (prov.error != null) {
                return Center(child: Text(prov.error.toString()));
              }
              if(prov.usWrkHistory.isEmpty)
              {
                return Center(
                  child: Text("There is nothing to view"),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount:
                    prov.usWrkHistory.length + (prov.isHistoryload ? 1 : 0),
                itemBuilder: (context, index) {
                  /// 🔹 Loader at bottom for infinite scroll
                  if (index == prov.usWrkHistory.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final item = prov.usWrkHistory[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Task Name
                          Text(
                            item.taskName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          /// Project Name
                          Text(
                            item.projectName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Assigned By
                          Text(
                            "Assign By: ${item.createdBy}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Status & Priority
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildChip(
                                  item.taskStatus.toString(), Colors.orange),
                              _buildChip(item.priority.toString(), Colors.red),
                            ],
                          ),

                          const SizedBox(height: 6),

                          /// Dates
                          Text(
                            "Assign: ${item.allotmentDate}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Due: ${item.completionDate}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
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
}
