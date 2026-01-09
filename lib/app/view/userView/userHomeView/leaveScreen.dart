import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class LeavescreenUi extends StatefulWidget {
  const LeavescreenUi({super.key});

  @override
  State<LeavescreenUi> createState() => LeavescreenUiState();
}

class LeavescreenUiState extends State<LeavescreenUi> {
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
            "Leave",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Leave History",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SizedBox(
                  width: SizeConFig.proportionalWidth * 9,
                  //  height: SizeConFig.proportionalHeight * 3.0,
                  child: ListView(
                    children: [
                      userLeaveStatusCard(
                        leaveType: "Casual Leave",
                        dateRange: "12 Jan - 14 Jan 2026",
                        status: "Approved",
                        message: "Approved by TL MR Jonh",
                      ),
                      userLeaveStatusCard(
                        leaveType: "Medical Leave",
                        dateRange: "20 Jan - 22 Jan 2026",
                        status: "Pending",
                      ),
                      userLeaveStatusCard(
                        leaveType: "Paid Leave",
                        dateRange: "05 Jan - 06 Jan 2026",
                        status: "Rejected",
                        message: "Insufficient leave balance",
                      ),
                      userLeaveStatusCard(
                        leaveType: "Paid Leave",
                        dateRange: "05 Jan - 06 Jan 2026",
                        status: "Rejected",
                        message: "Insufficient leave balance",
                      ),
                      userLeaveStatusCard(
                        leaveType: "Paid Leave",
                        dateRange: "05 Jan - 06 Jan 2026",
                        status: "Rejected",
                        message: "Insufficient leave balance",
                      ),
                      userLeaveStatusCard(
                        leaveType: "Casual Leave",
                        dateRange: "12 Jan - 14 Jan 2026",
                        status: "Approved",
                        message: "Approved by TL MR Jonh",
                      ),
                      userLeaveStatusCard(
                        leaveType: "Casual Leave",
                        dateRange: "12 Jan - 14 Jan 2026",
                        status: "Approved",
                        message: "Approved by TL MR Jonh",
                      ),
                    ],
                  ),
                ),
              ),
              buildLine(Colors.black),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pending Leave Requests (3)",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) => leaveRequestCard(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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

  Widget leaveRequestCard() {
    return SizedBox(
      //width: SizeConFig.proportionalWidth * 9,
      height: SizeConFig.proportionalHeight * 1.7,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Name + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "John Doe",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  //Text("pending")
                  _buildChip("pending", Colors.orange)
                  // Chip(

                  //   label: Text("Pending",style: TextStyle(fontSize: 12),),
                  //   backgroundColor: Colors.orangeAccent,
                  // ),
                ],
              ),

              const SizedBox(height: 1),

              Text("Casual Leave",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey)),

              const SizedBox(height: 1),
              Text("12 Jan 2026 - 14 Jan 2026",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),

              const SizedBox(height: 1),
              Text("Reason: Family function",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),

              const SizedBox(height: 1),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("Reject",
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Approve",
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
