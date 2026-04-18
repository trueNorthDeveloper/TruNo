import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/controller/teamLeaderCon.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/model/leaveRequestResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAttendanceAndLeaveModule/controller/attendanceController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAttendanceAndLeaveModule/model/leave_history.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class LeavescreenUi extends StatefulWidget {
  const LeavescreenUi({super.key});

  @override
  State<LeavescreenUi> createState() => LeavescreenUiState();
}

class LeavescreenUiState extends State<LeavescreenUi> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final leaderProvider =
          Provider.of<TeamleaderControllerPro>(context, listen: false);

      leaderProvider.initializeUserDashboard();
    });

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Attendancecontroller>(context, listen: false)
          .showUserLeaveApplyHistory(
              isRefresh: true); // Use refresh to start clean
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<Attendancecontroller>(context, listen: false);

    // Trigger when user is 200 pixels from the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // The provider already has checks for !_hasNextPage and _isLoadingMore
      // so it is safe to call here.
      provider.showUserLeaveApplyHistory();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Clean up listener
    _scrollController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            "Leave History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Consumer<TeamleaderControllerPro>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //this for all comman user............
                  _buildEmpui(provider),
                  if (provider.isTeamLeader) ...[
                    const SizedBox(height: 20),
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    //show team leader dashboard for teamleadr
                    // Expanded(child: _buildTeamLeader(provider)),
                    _buildTeamLeader(provider)
                  ]
                ],
              );
            },
          ),
        ));
  }

//build normal empyloy normal user
  Widget _buildEmpui(TeamleaderControllerPro provider) {
    return Expanded(
      child: Consumer<Attendancecontroller>(
        builder: (context, provider, child) {
          if (provider.leaveList.isEmpty && provider.isLoadingMore) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.leaveList.isEmpty) {
            return const Center(child: Text("No leave history found."));
          }

          return RefreshIndicator(
            onRefresh: () =>
                provider.showUserLeaveApplyHistory(isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              physics:
                  const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
              itemCount: provider.leaveList.length + 1,
              itemBuilder: (context, index) {
                if (index == provider.leaveList.length) {
                  return provider.isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox(height: 80); // Extra space at bottom
                }

                final leave = provider.leaveList[index];
                //BUILD LEAVE CARD FOR UI
                return _buildLeaveCard(leave);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamLeader(TeamleaderControllerPro provider) {
    return Expanded(child:
        Consumer<TeamleaderControllerPro>(builder: (context, provider, child) {
      if (provider.isShowRequest) {
        return const Center(child: CircularProgressIndicator());
      }
      final list = provider.leaveRequestResponse?.data ?? [];
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Pending Leave Requests (${list.length})",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final leave = list[index];
                  //BUILD LEAVE CARD FOR  TEAM LEADER..
                  return leaveRequestCard(leave);
                }),
          ),
        ]),
      );
    }));
  }

  Widget _buildLeaveCard(LeaveRequest leave) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text("${leave.leaveType} - ${leave.numberOfDays} Days",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("From: ${leave.fromDate} To: ${leave.toDate}",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        trailing: _buildStatusChip(leave.finalStatus ?? "PENDING"),
        children: [
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Approval Timeline",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...leave.leaderStatus!.map((leader) => ListTile(
                dense: true,
                leading: const Icon(Icons.person_outline),
                title: Text(leader.name ?? "Unknown"),
                subtitle: Text(leader.eid ?? ""),
                trailing: _buildStatusChip(leader.approverStatus ?? "PENDING",
                    isSmall: true),
              )),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, {bool isSmall = false}) {
    Color color;
    switch (status) {
      case 'APPROVED':
        color = Colors.green;
        break;
      case 'REJECTED':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmall ? 4 : 6),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: color,
            fontSize: isSmall ? 10 : 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildLine(Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          // height: MediaQuery.of(context).size.height * 0.1 / 100,
          //width: MediaQuery.of(context).size.width * 17 / 100,
          color: color),
    );
  }

  Widget userLeaveStatusCard({
    required String leaveType,
    required String dateRange,
    required String status,
    String? message,
  }) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case "Approved":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "Rejected":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_bottom;
    }

    return SizedBox(
      width: SizeConFig.proportionalWidth * 8,
      height: SizeConFig.proportionalHeight * 1.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leaveType,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 1),
              Text(dateRange,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),

              const SizedBox(height: 1),
              Text(
                message ?? "Waiting for approval",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leaveRequestCard(LeaveData leave) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Status Chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leave.userName ?? "Unknown",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "ID: ${leave.userEid ?? 'N/A'}",
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
                _buildStatusChip(leave.leaveStatus ?? "PENDING"),
              ],
            ),
            const Divider(height: 16),

            // Leave Details
            Row(
              children: [
                _infoTile(Icons.category_outlined, leave.leaveType ?? "N/A"),
                const SizedBox(width: 16),
                _infoTile(Icons.calendar_month_outlined,
                    "${leave.numberOfDays} Days"),
              ],
            ),
            const SizedBox(height: 6),
            _infoTile(Icons.date_range, "${leave.fromDate} to ${leave.toDate}"),
            const SizedBox(height: 6),
            _infoTile(Icons.notes, "Reason: ${leave.leaveReason}",
                isLongText: true),

            const SizedBox(height: 12),

            // Action Buttons
            //HERE USED CONSUMER FOR UPDATE LEAVE STATUS VIA TEAM LEADER WITH DIALOGE AND CONFIRM BOX
            Consumer<TeamleaderControllerPro>(
              builder: (context, leadProvider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          Map<String, dynamic> toRejected = {};
                          toRejected["status"] = "REJECTED";
                          toRejected["approvalId"] = leave.requestId!;
                          toRejected["comment"] = "rejected leave by me";
                          print(toRejected);
                          bool? result =
                              await _buildConfirmBox(context, "Rejected");
                          if (result!) {
                            leadProvider
                                .updateLeaveStatusByTeamLeader(toRejected);
                          }
                        },
                        child: const Text("Reject",
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          Map<String, dynamic> toApproval = {};
                          toApproval["status"] = "APPROVED";
                          toApproval["approvalId"] = leave.requestId!;
                          toApproval["comment"] = "Approved leave by me";
                          bool? result =
                              await _buildConfirmBox(context, "Approve");
                          if (result!) {
                            print(result);
                            leadProvider
                                .updateLeaveStatusByTeamLeader(toApproval);
                          }
                        },
                        child: const Text("Approve",
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _buildConfirmBox(BuildContext context, String msg) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Would you like to $msg? leave '),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                // Dismiss the dialog and return false
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Dismiss the dialog and return true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

// Helper for smaller icons/text rows
  Widget _infoTile(IconData icon, String text, {bool isLongText = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.blueGrey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          overflow: isLongText ? TextOverflow.ellipsis : null,
        ),
      ],
    );
  }
}
